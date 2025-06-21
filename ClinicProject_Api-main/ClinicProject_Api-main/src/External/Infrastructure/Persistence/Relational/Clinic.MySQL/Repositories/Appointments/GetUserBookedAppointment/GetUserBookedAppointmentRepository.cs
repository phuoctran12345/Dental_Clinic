﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Clinic.Domain.Commons.Entities;
using Clinic.Domain.Features.Repositories.Appointments.GetUserBookedAppointment;
using Clinic.MySQL.Data.Context;
using Microsoft.EntityFrameworkCore;

namespace Clinic.MySQL.Repositories.Appointments.GetUserBookedAppointment;

internal class GetUserBookedAppointmentRepository : IGetUserBookedAppointmentRepository
{
    private readonly ClinicContext _context;
    private DbSet<Appointment> _appointments;

    public GetUserBookedAppointmentRepository(ClinicContext context)
    {
        _context = context;
        _appointments = _context.Set<Appointment>();
    }

    public async Task<IEnumerable<Appointment>> GetUserBookedAppointmentByUserIdQueryAsync(
        Guid userId,
        CancellationToken cancellationToken
    )
    {
        return await _appointments
            .AsNoTracking()
            .Where(appointment => appointment.Patient.UserId == userId)
            .Where(appointment => appointment.AppointmentStatus.Constant.Equals("Pending"))
            .Where(appointment => appointment.Schedule.StartDate > DateTime.Now)
            .Where(appointment => appointment.DepositPayment)
            .Where(appointment => appointment.MedicalReport != null)
            .Select(appointment => new Appointment()
            {
                Id = appointment.Id,
                Schedule = new Schedule()
                {
                    Id = appointment.Schedule.Id,
                    StartDate = appointment.Schedule.StartDate,
                    EndDate = appointment.Schedule.EndDate,
                    Doctor = new Domain.Commons.Entities.Doctor()
                    {
                        UserId = appointment.Schedule.Doctor.UserId,
                        DoctorSpecialties = appointment.Schedule.Doctor.DoctorSpecialties.Select(
                            specialty => new DoctorSpecialty()
                            {
                                Specialty = new Specialty()
                                {
                                    Name = specialty.Specialty.Name,
                                    Constant = specialty.Specialty.Constant,
                                    Id = specialty.Specialty.Id,
                                },
                            }
                        ),
                        User = new User()
                        {
                            FullName = appointment.Schedule.Doctor.User.FullName,
                            Avatar = appointment.Schedule.Doctor.User.Avatar,
                        },
                    },
                },
            })
            .ToListAsync(cancellationToken: cancellationToken);
    }
}
