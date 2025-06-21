﻿using System;
using System.Collections.Generic;
using Clinic.Application.Commons.Abstractions;
using FastEndpoints;

namespace Clinic.Application.Features.Schedules.UpdateSchedule;

/// <summary>
///     CreateSchedules Request
/// </summary>

public class UpdateScheduleRequest : IFeatureRequest<UpdateScheduleResponse>
{
    public Guid ScheduleId { get; set; }
    public Guid? DoctorId { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }   
}
