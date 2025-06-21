using System;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using Clinic.Application.Commons.Abstractions;
using Clinic.Application.Commons.Abstractions.GetProfileUser;
using Clinic.Domain.Features.UnitOfWorks;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.JsonWebTokens;

namespace Clinic.Application.Features.Users.GetProfileUser;

/// <summary>
///     GetProfileUser Handler
/// </summary>
public class GetProfileUserHandler : IFeatureHandler<GetProfileUserRequest, GetProfileUserResponse>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IHttpContextAccessor _contextAccessor;

    public GetProfileUserHandler(IUnitOfWork unitOfWork, IHttpContextAccessor contextAccessor)
    {
        _unitOfWork = unitOfWork;
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
    public async Task<GetProfileUserResponse> ExecuteAsync(
        GetProfileUserRequest request,
        CancellationToken cancellationToken
    )
    {
        // Get userId from sub type jwt
        var role = _contextAccessor.HttpContext.User.FindFirstValue(claimType: "role");
        if (!role.Equals("user"))
        {
            return new GetProfileUserResponse()
            {
                StatusCode = GetProfileUserResponseStatusCode.FORBIDDEN,
            };
        }

        // Get userId from sub type jwt
        var userId = Guid.Parse(
            _contextAccessor.HttpContext.User.FindFirstValue(claimType: JwtRegisteredClaimNames.Sub)
        );

        // Found user by userId
        var foundUser = await _unitOfWork.GetProfileUserRepository.GetUserByUserIdQueryAsync(
            userId: userId,
            cancellationToken: cancellationToken
        );

        // Responds if userId is not found
        if (Equals(objA: foundUser, objB: default))
        {
            return new GetProfileUserResponse()
            {
                StatusCode = GetProfileUserResponseStatusCode.USER_IS_NOT_FOUND,
            };
        }

        var isUserTemporarilyRemoved =
            await _unitOfWork.GetProfileUserRepository.IsUserTemporarilyRemovedQueryAsync(
                userId: userId,
                cancellationToken: cancellationToken
            );

        // Responds if current user is temporarily removed.
        if (isUserTemporarilyRemoved)
        {
            return new()
            {
                StatusCode = GetProfileUserResponseStatusCode.USER_IS_TEMPORARILY_REMOVED,
            };
        }

        // Response successfully.
        return new GetProfileUserResponse()
        {
            StatusCode = GetProfileUserResponseStatusCode.OPERATION_SUCCESS,
            ResponseBody = new()
            {
                User = new()
                {
                    Username = foundUser.UserName,
                    PhoneNumber = foundUser.PhoneNumber,
                    AvatarUrl = foundUser.Avatar,
                    FullName = foundUser.FullName,
                    Gender = new() { Id = foundUser.Gender.Id, GenderName = foundUser.Gender.Name },
                    DOB = foundUser.Patient.DOB,
                    Address = foundUser.Patient.Address,
                    Description = foundUser.Patient.Description,
                },
            },
        };
    }
}
