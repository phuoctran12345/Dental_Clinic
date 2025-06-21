﻿using Clinic.Application.Commons.ChatMessage.Messaging;
using Clinic.Application.Commons.ChatMessage.Notifier;
using Clinic.Domain.Features.Repositories.ChatContents.CreateChatContent;
using Clinic.SignalR.Handler;
using Clinic.SignalR.Provider;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace Clinic.SignalR;

public static class DependencyInjection
{
    /// <summary>
    ///     Entry to configuring multiple services.
    /// </summary>
    /// <param name="services">
    ///     Service container.
    /// </param>
    public static void ConfigSignalR(this IServiceCollection services)
    {
        services.AddSignalR();
        services.AddScoped<IChatHandler, ChatHandler>();
        services.AddSingleton<INotifierHandler, NotifierHandler>();
        services.AddSingleton<IUserIdProvider, UserIdProvider>();
    }
}
