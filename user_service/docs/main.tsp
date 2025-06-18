import "@typespec/rest";

using TypeSpec.Http;

@service(#{ title: "Educesol User Service API Documentation" })
namespace ApiDocs;

@doc("API Documentation for the Educesol User Service")
namespace Api {
    model Media {
        @example("h93suhw7mzyujf9tbugy")
        public_id: string;

        @example("https://res.cloudinary.com/dyirc2dvg/image/upload/v1747581547/foodhut/h93suhw7mzyujf9tbugy.jpg")
        url: string;
    }

    namespace Pagination {
        model Options {
            page: integer;
            per_page: integer;
        }

        model Meta {
            ...Api.Pagination.Options;
            total: integer;
        }

        model Paginated<T> {
            code: "LIST";
            data: T[];
            meta: Api.Pagination.Meta;
        }

        model Query {
            @query
            @minValue(1)
            page?: integer;

            @query
            @minValue(10)
            @maxValue(100)
            per_page?: integer;
        }
    }

    @error
    model UnexpectedError {
        @statusCode _code: 500;
        code: "ERR_UNEXPECTED";
    }

    model ValidationErrorDetail {
        type: string;
        loc: (string | integer)[];
        msg: string;
        input?: string;
        ctx?: Record<string>;
        url?: string;
    }

    @error
    model BadRequestError {
        @statusCode _code: 400;
        code: "ERR_EXPECTED_DATA_NOT_RECEIVED";
        errors: ValidationErrorDetail[];
    }

    @error
    model NotFoundError<T> {
        @statusCode _code: 404;
        code: "ERR_${T}_NOT_FOUND";
    }
    @error
    model UserNotFoundError {
        ...NotFoundError<"USER">;
    }

    @tag("Users")
    @route("/")
    namespace Users {
        model BaseUser {
            id: string;
            first_name: string;
            last_name: string;
            middle_name?: string;
            phone?: string;
            email?: string;
            user_type: "STUDENT" | "TEACHER" | "ADMIN" | "GUARDIAN";
            created_at: string;
            updated_at: string;
        }

        model StudentProfile {
            id: string;

            @example("2000-01-01")
            date_of_birth: string;

            gender: "M" | "F";
            medical_conditions?: string;
            school_id: string;
        }

        model TeacherProfile {
            id: string;
            school_id: string;
        }

        model AdminProfile {
            id: string;
            role: "SUPER_ADMIN" | "ACADEMIC_ADMIN" | "FINANCIAL_ADMIN";
            permissions: string;
            school_id?: string;
        }

        @discriminator("type")
        model StudentUser extends BaseUser {
            type: "STUDENT";
            profile: StudentProfile;
        }

        @discriminator("type")
        model TeacherUser extends BaseUser {
            type: "TEACHER";
            profile: TeacherProfile;
        }

        @discriminator("type")
        model AdminUser extends BaseUser {
            type: "ADMIN";
            profile: AdminProfile;
        }

        @discriminator("type")
        model GuardianUser extends BaseUser {
            type: "GUARDIAN";
            id: string;
        }

        union User {
            student: StudentUser,
            teacher: TeacherUser,
            admin: AdminUser,
            guardian: GuardianUser,
        }

        namespace Create {
            namespace Request {
                @discriminator("type")
                model StudentCreate {
                    type: "STUDENT";
                    first_name: string;
                    last_name: string;
                    middle_name?: string;
                    phone?: string;
                    email?: string;
                    profile: OmitProperties<StudentProfile, "id">;
                }

                @discriminator("type")
                model TeacherCreate {
                    type: "TEACHER";
                    first_name: string;
                    last_name: string;
                    middle_name?: string;
                    phone: string;
                    email: string;
                    profile: OmitProperties<TeacherProfile, "id">;
                }

                @discriminator("type")
                model AdminCreate {
                    type: "ADMIN";
                    first_name: string;
                    last_name: string;
                    middle_name?: string;
                    phone: string;
                    email: string;
                    profile: OmitProperties<AdminProfile, "id">;
                }

                @discriminator("type")
                model GuardianCreate {
                    type: "GUARDIAN";
                    first_name: string;
                    last_name: string;
                    middle_name?: string;
                    phone: string;
                    email: string;
                }

                union Body {
                    student: StudentCreate,
                    teacher: TeacherCreate,
                    admin: AdminCreate,
                    guardian: GuardianCreate,
                }
            }

            namespace Response {
                namespace Success {
                    model UserCreated {
                        @statusCode _code: 201;
                        code: "USER_CREATED";
                        data: User;
                    }

                    union Success {
                        user_created: UserCreated,
                    }
                }

                namespace Error {
                    @error
                    model PhoneAlreadyExistsError {
                        @statusCode _code: 409;
                        code: "ERR_PHONE_ALREADY_EXISTS";
                    }

                    @error
                    model EmailAlreadyExistsError {
                        @statusCode _code: 409;
                        code: "ERR_EMAIL_ALREADY_EXISTS";
                    }

                    union Error {
                        phone_already_exists: PhoneAlreadyExistsError,
                        email_already_exists: EmailAlreadyExistsError,
                        bad_request: BadRequestError,
                        unexpected: UnexpectedError,
                    }
                }

                alias Response = Success.Success | Error.Error;
            }

            @post
            @doc("Create a new user")
            op createUser(@body body: Request.Body): Response.Response;
        }

        namespace List {
            namespace Request {
                model UserListQuery {
                    ...Pagination.Query;

                    @query
                    type?: "STUDENT" | "TEACHER" | "ADMIN" | "GUARDIAN";
                }

                model Query {
                    ...UserListQuery;
                }
            }

            namespace Response {
                namespace Success {
                    union Success {
                        users: Pagination.Paginated<User>,
                    }
                }

                namespace Error {
                    union Error {
                        unexpected: UnexpectedError,
                    }
                }

                alias Response = Success.Success | Error.Error;
            }

            @get
            @doc("List users")
            op listUsers(...Request.Query): Response.Response;
        }

        @route("/{id}")
        namespace ById {
            namespace Get {
                namespace Request {
                    model Path {
                        @path
                        id: string;
                    }
                }

                namespace Response {
                    namespace Success {
                        model Success {
                            @statusCode _code: 200;
                            code: "USER_FOUND";
                            data: User;
                        }
                    }

                    namespace Error {
                        union Error {
                            not_found: UserNotFoundError,
                            unexpected: UnexpectedError,
                        }
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @get
                @doc("Get a user by ID")
                op getUserById(@path id: Request.Path): Response.Response;
            }

            namespace Update {
                namespace Request {
                    model Path {
                        @path
                        id: string;
                    }

                    model Body {
                        ...OmitProperties<
                            BaseUser,
                            "id" | "user_type" | "created_at" | "updated_at"
                        >;
                    }
                }

                namespace Response {
                    namespace Success {
                        model UserUpdated {
                            @statusCode _code: 200;
                            code: "USER_UPDATED";
                            // data: User;
                        }

                        union Success {
                            user_updated: UserUpdated,
                        }
                    }

                    namespace Error {
                        union Error {
                            user_not_found: UserNotFoundError,
                            bad_request: BadRequestError,
                            unexpected: UnexpectedError,
                        }
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @patch(#{ implicitOptionality: false })
                @doc("Update a user by ID")
                op updateUserById(
                    @path id: Request.Path,
                    @body body: Request.Body,
                ): Response.Response;
            }
        }
    }
}
