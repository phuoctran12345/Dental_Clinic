﻿using System;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using Clinic.Application.Commons.Abstractions;
using Clinic.Application.Commons.FIleObjectStorage;
using Clinic.Domain.Features.UnitOfWorks;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.JsonWebTokens;

namespace Clinic.Application.Features.Schedules.UpdateSchedule;

/// <summary>
///     CreateSchedules Handler
/// </summary>
public class UpdateScheduleHandler
    : IFeatureHandler<UpdateScheduleRequest, UpdateScheduleResponse>
{
    private readonly IUnitOfWork _unitOfWork;
    private IDefaultUserAvatarAsUrlHandler _defaultUserAvatarAsUrlHandler;
    private readonly IHttpContextAccessor _contextAccessor;

    public UpdateScheduleHandler(
        IUnitOfWork unitOfWork,
        IDefaultUserAvatarAsUrlHandler defaultUserAvatarAsUrlHandlerl,
        IHttpContextAccessor contextAccessor
    )
    {
        _unitOfWork = unitOfWork;
        _defaultUserAvatarAsUrlHandler = defaultUserAvatarAsUrlHandlerl;
        _contextAccessor = contextAccessor;
    }

    /// <summary>
    ///     Entry of new request handler.
    /// </summary>
    /// <param name="request">
    ///     Request model.
    /// </param>
    /// <param name="ct">
    ///     A token that is used for notifying system
    ///     to cancel the current operation when user stop
    ///     the request.
    /// </param>
    /// <returns>
    ///     A task containing the response.
    public async Task<UpdateScheduleResponse> ExecuteAsync(
        UpdateScheduleRequest request,
        CancellationToken cancellationToken
    )
    {
        // Get userRole from sub type jwt
        var role = _contextAccessor.HttpContext.User.FindFirstValue(claimType: "role");

        if (!(Equals(objA: role, objB: "doctor") || Equals(objA: role, objB: "staff")))
        {
            return new() { StatusCode = UpdateScheduleResponseStatusCode.FORBIDEN };
        }

        // Get userId from sub type jwt
        var doctorId = Guid.Empty;
        if(request.DoctorId == null)
        {
            doctorId = Guid.Parse(
                _contextAccessor.HttpContext.User.FindFirstValue(claimType: JwtRegisteredClaimNames.Sub)
            ); 
        } else doctorId = (Guid)request.DoctorId;


        // Check schedule is exist or not
        var isScheduleExist = await _unitOfWork.UpdateScheduleByIdRepository.IsScheduleExist(
            scheduleId: request.ScheduleId
            );

        // Respond if schedule not exsit
        if (!isScheduleExist)
        {
            return new() { StatusCode = UpdateScheduleResponseStatusCode.NOT_FOUND_SCHEDULE };
        }

        // Check schedule is had appointment
        var isScheduleHadAppoitment = await _unitOfWork.UpdateScheduleByIdRepository.IsScheduleHadAppoitment(
            scheduleId: request.ScheduleId,
            cancellationToken: cancellationToken
            );

        // Respond if schedule not exsit
        if (isScheduleHadAppoitment)
        {
            return new() { StatusCode = UpdateScheduleResponseStatusCode.SCHEDULE_HAD_APPOINTMENT };
        }

        // Check overlapping in database
        var isOverlapping = await _unitOfWork.UpdateScheduleByIdRepository.AreOverLappedSchedule(
            doctorId: doctorId,
            scheduleId: request.ScheduleId,
            startDate : request.StartDate,
            endDate : request.EndDate,
            cancellationToken: cancellationToken
        );

        // Respond if overlapping.
        if (isOverlapping)
        {
            return new() { StatusCode = UpdateScheduleResponseStatusCode.SCHEDULE_WAS_OVERLAPED };
        }

        // Database operation
        var dbResult = await _unitOfWork.UpdateScheduleByIdRepository.UpdateScheduleByIdCommandAsync(
            scheduleId: request.ScheduleId,
            startDate: request.StartDate,
            endDate: request.EndDate,
            cancellationToken: cancellationToken
        );

        // Respond if database operation failed.
        if (!dbResult)
        {
            return new() { StatusCode = UpdateScheduleResponseStatusCode.DATABASE_OPERATION_FAIL };
        }

        // Response successfully.
        return new UpdateScheduleResponse()
        {
            StatusCode = UpdateScheduleResponseStatusCode.OPERATION_SUCCESS,
        };
    }

}
