﻿using Clinic.Application.Commons.SMS;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace Clinic.TwilioSMS.Handler;

/// <summary>
///     Twilio SMS Handler.
/// </summary>
internal class TwilioSmsHandler : ISmsHandler
{
    /// <summary>
    ///     Send notification.
    /// </summary>
    /// <param name="to"></param>
    /// <param name="body"></param>
    /// <returns></returns>
    public async Task<bool> SendNotification(string to, string body)
    {
        var accountSid = "ACfd522c74ee3e506d4114e0e1df570998";
        var authToken = "b5e44e54a341465ba60fb28833bb4074";
        var isCreated = false;
        try
        {
            TwilioClient.Init(accountSid, authToken);
            var messageOptions = new CreateMessageOptions(new PhoneNumber("+84356611341"));
            messageOptions.From = new PhoneNumber("+12088434177");
            messageOptions.Body = body;
            var message = await MessageResource.CreateAsync(messageOptions);
            isCreated = true;
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            isCreated = false;
        }

        return isCreated;
    }
}
