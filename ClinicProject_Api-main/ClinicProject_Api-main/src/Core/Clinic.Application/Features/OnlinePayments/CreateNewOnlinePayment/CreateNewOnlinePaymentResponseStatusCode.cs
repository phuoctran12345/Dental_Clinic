﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Clinic.Application.Features.OnlinePayments.CreateNewOnlinePayment;

public enum CreateNewOnlinePaymentResponseStatusCode
{
    INPUT_VALIDATION_FAIL,
    OPERATION_SUCCESS,
    UNAUTHORIZE,
    DATABASE_OPERATION_FAIL,
    FORBIDEN_ACCESS,
    USER_IS_NOT_FOUND,
    APPOINTMENT_IS_NOT_FOUND,
    APPOINTMENT_HAS_DEPOSITED
}
