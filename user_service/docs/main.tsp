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
            page: int64;
            per_page: int64;
        }

        model Meta {
            ...Api.Pagination.Options;
            total: int64;
        }

        model Paginated<T> {
            code: "LIST";
            data: T[];
            meta: Api.Pagination.Meta;
        }

        model Query {
            @query
            @minValue(1)
            page?: int64;

            @query
            @minValue(10)
            @maxValue(100)
            per_page?: int64;
        }
    }

    @error
    model UnexpectedError {
        @statusCode _code: 500;
        code: "ERR_UNEXPECTED";
    }

    @error
    model BadRequestError {
        @statusCode _code: 400;
        code: "ERR_EXPECTED_DATA_NOT_RECEIVED";
    }

    @error
    model NotFoundError<T> {
        @statusCode _code: 404;
        code: "ERR_${T}_NOT_FOUND";
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
            date_of_birth: string;
            gender: "M" | "F";
            medical_conditions?: string;
            school_id: string;
        }

        model TeacherProfile {
            school_id: string;
        }

        model AdminProfile {
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
                    profile: StudentProfile;
                }

                @discriminator("type")
                model TeacherCreate {
                    type: "TEACHER";
                    first_name: string;
                    last_name: string;
                    middle_name?: string;
                    phone: string;
                    email: string;
                    profile: TeacherProfile;
                }

                @discriminator("type")
                model AdminCreate {
                    type: "ADMIN";
                    first_name: string;
                    last_name: string;
                    middle_name?: string;
                    phone: string;
                    email: string;
                    profile: AdminProfile;
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
                    model Success {
                        @statusCode _code: 201;
                        code: "USER_CREATED";
                        data: User;
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

                    @error
                    model StudentIdAlreadyExistsError {
                        @statusCode _code: 409;
                        code: "ERR_STUDENT_ID_ALREADY_EXISTS";
                    }

                    union Error {
                        phone: PhoneAlreadyExistsError,
                        email: EmailAlreadyExistsError,
                        student_id: StudentIdAlreadyExistsError,
                        bad_request: BadRequestError,
                        unexpected: UnexpectedError,
                    }
                }

                union Response {
                    success: Success.Success,
                    error: Error.Error,
                }
            }

            @post
            @doc("Create a new user")
            op createUser(@body body: Request.Body): Response.Response;
        }

        namespace List {
            namespace Request {
                model UserListQuery {
                    @query
                    type?: "STUDENT" | "TEACHER" | "ADMIN" | "GUARDIAN";
                }

                alias Query = Pagination.Query & UserListQuery;
            }

            namespace Response {
                namespace Success {
                    alias Success = Pagination.Paginated<User>;
                }

                namespace Error {
                    alias Error = UnexpectedError;
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
                        alias Error = NotFoundError<"USER"> | UnexpectedError;
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

                    @discriminator("type")
                    model StudentUpdate {
                        type: "STUDENT";
                        first_name?: string;
                        last_name?: string;
                        middle_name?: string;
                        phone?: string;
                        email?: string;
                        profile?: StudentProfile;
                    }

                    @discriminator("type")
                    model TeacherUpdate {
                        type: "TEACHER";
                        first_name?: string;
                        last_name?: string;
                        middle_name?: string;
                        phone?: string;
                        email?: string;
                        profile?: TeacherProfile;
                    }

                    @discriminator("type")
                    model AdminUpdate {
                        type: "ADMIN";
                        first_name?: string;
                        last_name?: string;
                        middle_name?: string;
                        phone?: string;
                        email?: string;
                        profile?: AdminProfile;
                    }

                    @discriminator("type")
                    model GuardianUpdate {
                        type: "GUARDIAN";
                        first_name?: string;
                        last_name?: string;
                        middle_name?: string;
                        phone?: string;
                        email?: string;
                    }

                    union Body {
                        student: StudentUpdate,
                        teacher: TeacherUpdate,
                        admin: AdminUpdate,
                        guardian: GuardianUpdate,
                    }
                }

                namespace Response {
                    namespace Success {
                        model Success {
                            @statusCode _code: 200;
                            code: "USER_UPDATED";
                            data: User;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"USER"> | BadRequestError | UnexpectedError;
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

            namespace Delete {
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
                            code: "USER_DELETED";
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"USER"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @delete
                @doc("Delete a user by ID")
                op deleteUserById(@path id: Request.Path): Response.Response;
            }
        }
    }
}
