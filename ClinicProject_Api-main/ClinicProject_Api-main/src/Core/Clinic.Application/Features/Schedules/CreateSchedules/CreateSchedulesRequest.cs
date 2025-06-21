﻿using System;
using System.Collections.Generic;
using Clinic.Application.Commons.Abstractions;
using FastEndpoints;

namespace Clinic.Application.Features.Schedules.CreateSchedules;

/// <summary>
///     CreateSchedules Request
/// </summary>

public class CreateSchedulesRequest : IFeatureRequest<CreateSchedulesResponse>
{
    public Guid? DoctorId { get; set; }
    public IEnumerable<TimeSlot> TimeSlots { get; set; }

    public sealed class TimeSlot
    {
        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }
    }
}
