﻿namespace Clinic.Application.Features.ChatRooms.AssignChatRoom;

/// <summary>
///     AssignChatRoom ExtensionMethod.
/// </summary>
public static class AssignChatRoomExtensionMethod
{
    public static string ToAppCode(this AssignChatRoomResponseStatusCode statusCode)
    {
        return $"{nameof(AssignChatRoom)}Feature: {statusCode}";
    }
}
