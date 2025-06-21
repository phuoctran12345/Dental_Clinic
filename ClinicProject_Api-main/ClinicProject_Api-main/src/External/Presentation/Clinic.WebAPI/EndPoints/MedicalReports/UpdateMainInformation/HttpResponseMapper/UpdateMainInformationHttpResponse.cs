﻿using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;
using Clinic.Application.Features.Auths.ChangingPassword;
using Clinic.Application.Features.MedicalReports.UpdateMainMedicalReportInformation;

namespace Clinic.WebAPI.EndPoints.MedicalReports.UpdateMainInformation.HttpResponseMapper;

public class UpdateMainInformationHttpResponse
{
    [JsonIgnore]
    public int HttpCode { get; set; }

    public string AppCode { get; init; } =
        UpdateMainMedicalReportInformationResponseStatusCode.OPERATION_SUCCESSFUL.ToAppCode();

    public DateTime ResponseTime { get; init; } =
        TimeZoneInfo.ConvertTimeFromUtc(
            dateTime: DateTime.UtcNow,
            destinationTimeZone: TimeZoneInfo.FindSystemTimeZoneById(id: "SE Asia Standard Time")
        );

    public object Body { get; init; } = new();

    public IEnumerable<string> ErrorMessages { get; init; } = [];
}
