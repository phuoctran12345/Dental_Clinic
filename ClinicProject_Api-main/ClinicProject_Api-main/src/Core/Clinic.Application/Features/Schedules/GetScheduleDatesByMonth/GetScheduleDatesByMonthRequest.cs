﻿using System;
using System.Diagnostics.CodeAnalysis;
using Clinic.Application.Commons.Abstractions;
using FastEndpoints;

namespace Clinic.Application.Features.Schedules.GetScheduleDatesByMonth;

/// <summary>
///     GetScheduleDatesByMonth Request
/// </summary>

public class GetScheduleDatesByMonthRequest : IFeatureRequest<GetScheduleDatesByMonthResponse>
{
    [BindFrom("year")]
    public int Year { get; set; }

    [BindFrom("month")]
    public int Month { get; set; }

    [BindFrom("doctorId")]
    public Guid? DoctorId { get; set; }
}
