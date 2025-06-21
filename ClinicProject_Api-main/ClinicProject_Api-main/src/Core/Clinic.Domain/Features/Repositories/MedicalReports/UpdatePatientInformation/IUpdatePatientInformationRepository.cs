﻿using System;
using System.Threading;
using System.Threading.Tasks;
using Clinic.Domain.Commons.Entities;

namespace Clinic.Domain.Features.Repositories.MedicalReports.UpdatePatientInformation;

public interface IUpdatePatientInformationRepository
{
    Task<PatientInformation> FindPatientInformationByIdQueryAsync(
        Guid patientInformationId,
        CancellationToken ct
    );
    Task<bool> UpdatePatientInformationCommandAsync(
        PatientInformation patientInformation,
        CancellationToken ct
    );
}
