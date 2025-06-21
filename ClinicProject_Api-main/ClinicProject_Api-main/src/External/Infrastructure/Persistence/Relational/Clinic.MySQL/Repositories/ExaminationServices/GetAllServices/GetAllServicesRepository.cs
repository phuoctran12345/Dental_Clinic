﻿using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Clinic.Domain.Commons.Entities;
using Clinic.Domain.Features.Repositories.ExaminationServices.GetAllServices;
using Clinic.MySQL.Data.Context;
using Microsoft.EntityFrameworkCore;

namespace Clinic.MySQL.Repositories.ExaminationServices.GetAllServices;

public class GetAllServicesRepository : IGetAllServicesRepository
{
    private readonly ClinicContext _context;
    private readonly DbSet<Service> _services;

    public GetAllServicesRepository(ClinicContext context)
    {
        _context = context;
        _services = _context.Set<Service>();
    }

    public async Task<int> CountAllServicesQueryAsync(
        string key,
        CancellationToken cancellationToken
    )
    {
        var results = _services.AsNoTracking().AsQueryable();
        if (key != default)
        {
            results = results.Where(service =>
                service.Name.Contains(key) || service.Code.Contains(key)
            );
        }

        return await results.AsNoTracking().CountAsync(cancellationToken: cancellationToken);
    }

    public async Task<IEnumerable<Service>> FindAllServicesQueryAsync(
        int pageIndex,
        int pageSize,
        string key,
        CancellationToken cancellationToken
    )
    {
        var results = _services.AsNoTracking().AsQueryable();
        if (key != default)
        {
            results = results.Where(service =>
                service.Name.Contains(key) || service.Code.Contains(key)
            );
        }

        results = results.OrderByDescending(service => service.CreatedAt);

        return await results
            .Select(service => new Service()
            {
                Id = service.Id,
                Name = service.Name,
                Code = service.Code,
                Descripiton = service.Descripiton,
                Price = service.Price,
                Group = service.Group,
                RemovedAt = service.RemovedAt,
                RemovedBy = service.RemovedBy
            })
            .Skip((pageIndex - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken: cancellationToken);
    }
}
