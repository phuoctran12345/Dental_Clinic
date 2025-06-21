﻿using Clinic.Configuration.Presentation.Authentication;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Clinic.WebAPI.Commons.wwwServiceConfigs;

/// <summary>
///     Core service config.
/// </summary>
internal static class CoreServiceConfig
{
    internal static void ConfigCore(
        this IServiceCollection services,
        IConfigurationManager configuration
    )
    {
        services.AddSingleton(
            configuration.GetRequiredSection("BaseEndpointUrl").Get<BaseEndpointUrlOption>()
        );
    }
}
