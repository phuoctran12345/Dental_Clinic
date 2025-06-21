using System;

namespace Clinic.Application.Commons.Abstractions.GetProfileUser;

/// <summary>
///     GetProfileUser Response
/// </summary>
public class GetProfileUserResponse : IFeatureResponse
{
    public GetProfileUserResponseStatusCode StatusCode { get; init; }

    public Body ResponseBody { get; init; }

    public sealed class Body
    {
        public UserDetail User { get; init; }

        public sealed class UserDetail
        {
            public string Username { get; init; }

            public string PhoneNumber { get; init; }

            public string AvatarUrl { get; init; }

            public string FullName { get; init; }

            public ResponseGender Gender { get; init; }

            public sealed class ResponseGender
            {
                public Guid Id { get; init; }
                public string GenderName { get; init; }
            }

            public DateTime? DOB { get; init; }

            public string Address { get; init; }

            public string Description { get; init; }
        }
    }
}
