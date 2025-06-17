import "@typespec/rest";

using TypeSpec.Http;

@service(#{ title: "Educesol User Service API Documentation" })
namespace ApiDocs;

@doc("API Documentation for the Educesol User Service")
namespace Api {
    @example("f47ac10b-58cc-4372-a567-0e02b2c3d479")
    scalar Id extends string;

    @example("John")
    scalar FirstName extends string;

    @example("Doe")
    scalar LastName extends string;

    @example("Smith")
    scalar MiddleName extends string;

    @example("+2348123456789")
    scalar PhoneNumber extends string;

    @example("john.doe@mail.com")
    scalar Email extends string;

    @example("2021-09-01T12:00:00Z")
    scalar DateTime extends string;

    enum UserType {
        TEACHER,
        GUARDIAN,
        ADMIN,
        SUPER_ADMIN,
        STUDENT,
    }

    enum Gender {
        M,
        F,
    }

    enum AdminRole {
        SUPER_ADMIN,
        ACADEMIC_ADMIN,
        FINANCIAL_ADMIN,
    }

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
            id: Id;
            first_name: FirstName;
            last_name: LastName;
            middle_name?: MiddleName;
            phone?: PhoneNumber;
            email?: Email;
            user_type: UserType;
            created_at: DateTime;
            updated_at: DateTime;
        }

        model StudentProfile {
            id: string;
            date_of_birth: string;
            gender: Gender;
            medical_conditions?: string;
            school_id: Id;
        }

        model TeacherProfile {
            school_id: Id;
        }

        model AdminProfile {
            role: AdminRole;
            permissions: string;
            school_id?: Id;
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
                    first_name: FirstName;
                    last_name: LastName;
                    middle_name?: MiddleName;
                    phone?: PhoneNumber;
                    email?: Email;
                    profile: StudentProfile;
                }

                @discriminator("type")
                model TeacherCreate {
                    type: "TEACHER";
                    first_name: FirstName;
                    last_name: LastName;
                    middle_name?: MiddleName;
                    phone: PhoneNumber;
                    email: Email;
                    profile: TeacherProfile;
                }

                @discriminator("type")
                model AdminCreate {
                    type: "ADMIN";
                    first_name: FirstName;
                    last_name: LastName;
                    middle_name?: MiddleName;
                    phone: PhoneNumber;
                    email: Email;
                    profile: AdminProfile;
                }

                @discriminator("type")
                model GuardianCreate {
                    type: "GUARDIAN";
                    first_name: FirstName;
                    last_name: LastName;
                    middle_name?: MiddleName;
                    phone: PhoneNumber;
                    email: Email;
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
                    type?: UserType;
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
                        id: Id;
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
                        id: Id;
                    }

                    @discriminator("type")
                    model StudentUpdate {
                        type: "STUDENT";
                        first_name?: FirstName;
                        last_name?: LastName;
                        middle_name?: MiddleName;
                        phone?: PhoneNumber;
                        email?: Email;
                        profile?: StudentProfile;
                    }

                    @discriminator("type")
                    model TeacherUpdate {
                        type: "TEACHER";
                        first_name?: FirstName;
                        last_name?: LastName;
                        middle_name?: MiddleName;
                        phone?: PhoneNumber;
                        email?: Email;
                        profile?: TeacherProfile;
                    }

                    @discriminator("type")
                    model AdminUpdate {
                        type: "ADMIN";
                        first_name?: FirstName;
                        last_name?: LastName;
                        middle_name?: MiddleName;
                        phone?: PhoneNumber;
                        email?: Email;
                        profile?: AdminProfile;
                    }

                    @discriminator("type")
                    model GuardianUpdate {
                        type: "GUARDIAN";
                        first_name?: FirstName;
                        last_name?: LastName;
                        middle_name?: MiddleName;
                        phone?: PhoneNumber;
                        email?: Email;
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
                        id: Id;
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
