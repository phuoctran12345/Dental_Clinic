﻿using System;
using System.Collections.Generic;
using Clinic.Domain.Commons.Entities.Base;

namespace Clinic.Domain.Commons.Entities;

/// <summary>
///     Represent the "ChatContent" table.
/// </summary>
public class ChatContent : IBaseEntity, ICreatedEntity, ITemporarilyRemovedEntity, IUpdatedEntity
{
    // Primary keys.
    public Guid Id { get; set; }

    // Normal columns.
    public string TextContent { get; set; }

    public bool IsRead { get; set; }

    public DateTime CreatedAt { get; set; }

    public Guid CreatedBy { get; set; }

    public DateTime UpdatedAt { get; set; }

    public Guid UpdatedBy { get; set; }

    public DateTime RemovedAt { get; set; }

    public Guid RemovedBy { get; set; }

    // Foreign keys.
    public Guid ChatRoomId { get; set; }

    public Guid SenderId { get; set; }

    // Navigation properties.
    public ChatRoom ChatRoom { get; set; }

    public User User { get; set; }

    // Navigation collections.
    public IEnumerable<Asset> Assets { get; set; }
}
