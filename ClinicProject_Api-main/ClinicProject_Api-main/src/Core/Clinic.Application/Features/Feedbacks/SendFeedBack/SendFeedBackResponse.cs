﻿using Clinic.Application.Commons.Abstractions;

namespace Clinic.Application.Features.Feedbacks.SendFeedBack;

/// <summary>
///     SendFeedBackResponse
/// </summary>
public sealed class SendFeedBackResponse : IFeatureResponse
{
    public SendFeedBackResponseStatusCode StatusCode { get; set; }

}
