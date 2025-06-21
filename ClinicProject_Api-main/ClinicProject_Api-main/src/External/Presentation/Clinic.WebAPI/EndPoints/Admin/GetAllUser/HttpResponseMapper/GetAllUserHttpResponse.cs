﻿using System.Collections.Generic;
using System;
using System.Text.Json.Serialization;
using Clinic.Application.Features.Admin.GetAllUser;

namespace Clinic.WebAPI.EndPoints.Admin.GetAllUser.HttpResponseMapper;

/// <summary>
///     GetAllUser http response
/// </summary>
public sealed class GetAllUserHttpResponse
{
    [JsonIgnore]
    public int HttpCode { get; set; }

    public string AppCode { get; init; } =
        GetAllUserResponseStatusCode.OPERATION_SUCCESS.ToAppCode();

    public DateTime ResponseTime { get; init; } =
        TimeZoneInfo.ConvertTimeFromUtc(
            dateTime: DateTime.UtcNow,
            destinationTimeZone: TimeZoneInfo.FindSystemTimeZoneById(id: "SE Asia Standard Time")
        );

    public object Body { get; set; } = new();

    public IEnumerable<string> ErrorMessages { get; init; } = [];
}

