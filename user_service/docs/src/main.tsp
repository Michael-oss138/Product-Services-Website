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

    @example("johndoe")
    scalar Username extends string;

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
    @route("/users")
    namespace Users {
        model BaseUser {
            id: Id;
            first_name: FirstName;
            last_name: LastName;
            middle_name?: MiddleName;
            username: Username;
            phone: PhoneNumber;
            email: Email;
            created_at: DateTime;
            updated_at: DateTime;
        }

        model StudentProfile {
            class_id: Id;
            school_id: Id;
            student_unique_id: string;
            date_of_birth: string;
            gender: Gender;
            medical_conditions?: string;
            doctor_name?: string;
            doctor_phone?: string;
        }

        model TeacherProfile {
            school_id: Id;
            qualification: string;
            image_url?: string;
            certificate_url?: string;
            resume_url?: string;
            other_positions?: string;
            description: string;
        }

        model AdminProfile {
            school_id: Id;
            role: AdminRole;
            permissions: string;
            last_login: DateTime;
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
                    username: Username;
                    phone: PhoneNumber;
                    email: Email;
                    profile: StudentProfile;
                }

                @discriminator("type")
                model TeacherCreate {
                    type: "TEACHER";
                    first_name: FirstName;
                    last_name: LastName;
                    middle_name?: MiddleName;
                    username: Username;
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
                    username: Username;
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
                    username: Username;
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
                    model UsernameAlreadyExistsError {
                        @statusCode _code: 409;
                        code: "ERR_USERNAME_ALREADY_EXISTS";
                    }

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

                    alias Error =
                        | UsernameAlreadyExistsError
                        | PhoneAlreadyExistsError
                        | EmailAlreadyExistsError
                        | StudentIdAlreadyExistsError
                        | BadRequestError
                        | UnexpectedError;
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
                    @query
                    type?: UserType;

                    school_id?: Id;
                    class_id?: Id;
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
                        username?: Username;
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
                        username?: Username;
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
                        username?: Username;
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
                        username?: Username;
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

                @patch
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

    @tag("Students")
    @route("/students")
    namespace Students {
        model Student {
            id: Id;
            class_id: Id;
            school_id: Id;
            first_name: FirstName;
            last_name: LastName;
            middle_name?: MiddleName;
            student_unique_id: string;
            date_of_birth: string;
            gender: Gender;
            medical_conditions?: string;
            doctor_name?: string;
            doctor_phone?: string;
            created_at: DateTime;
            updated_at: DateTime;
        }

        namespace Create {
            namespace Request {
                model Body {
                    class_id: Id;
                    school_id: Id;
                    first_name: FirstName;
                    last_name: LastName;
                    middle_name?: MiddleName;
                    student_unique_id: string;
                    date_of_birth: string;
                    gender: Gender;
                    medical_conditions?: string;
                    doctor_name?: string;
                    doctor_phone?: string;
                }
            }

            namespace Response {
                namespace Success {
                    model Success {
                        @statusCode _code: 201;
                        code: "STUDENT_CREATED";
                        data: Student;
                    }
                }

                namespace Error {
                    @error
                    model StudentIdAlreadyExistsError {
                        @statusCode _code: 409;
                        code: "ERR_STUDENT_ID_ALREADY_EXISTS";
                    }

                    alias Error = StudentIdAlreadyExistsError | BadRequestError | UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @post
            @doc("Create a new student")
            op createStudent(@body body: Request.Body): Response.Response;
        }

        namespace List {
            namespace Request {
                model StudentListQuery {
                    @query
                    class_id?: Id;

                    school_id?: Id;
                }

                alias Query = Pagination.Query & StudentListQuery;
            }

            namespace Response {
                namespace Success {
                    alias Success = Pagination.Paginated<Student>;
                }

                namespace Error {
                    alias Error = UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @get
            @doc("List students")
            op listStudents(...Request.Query): Response.Response;
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
                            code: "STUDENT_FOUND";
                            data: Student;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"STUDENT"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @get
                @doc("Get a student by ID")
                op getStudentById(@path id: Request.Path): Response.Response;
            }

            namespace Update {
                namespace Request {
                    model Path {
                        @path
                        id: Id;
                    }

                    model Body {
                        class_id?: Id;
                        school_id?: Id;
                        first_name?: FirstName;
                        last_name?: LastName;
                        middle_name?: MiddleName;
                        student_unique_id?: string;
                        date_of_birth?: string;
                        gender?: Gender;
                        medical_conditions?: string;
                        doctor_name?: string;
                        doctor_phone?: string;
                    }
                }

                namespace Response {
                    namespace Success {
                        model Success {
                            @statusCode _code: 200;
                            code: "STUDENT_UPDATED";
                            data: Student;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"STUDENT"> | BadRequestError | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @patch
                @doc("Update a student by ID")
                op updateStudentById(
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
                            code: "STUDENT_DELETED";
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"STUDENT"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @delete
                @doc("Delete a student by ID")
                op deleteStudentById(@path id: Request.Path): Response.Response;
            }
        }
    }

    @tag("Teachers")
    @route("/teachers")
    namespace Teachers {
        model Teacher {
            id: Id;
            user_id: Id;
            school_id: Id;
            qualification: string;
            image_url?: string;
            certificate_url?: string;
            resume_url?: string;
            other_positions?: string;
            description: string;
            created_at: DateTime;
            updated_at: DateTime;
        }

        namespace Create {
            namespace Request {
                model Body {
                    user_id: Id;
                    school_id: Id;
                    qualification: string;
                    image_url?: string;
                    certificate_url?: string;
                    resume_url?: string;
                    other_positions?: string;
                    description: string;
                }
            }

            namespace Response {
                namespace Success {
                    model Success {
                        @statusCode _code: 201;
                        code: "TEACHER_CREATED";
                        data: Teacher;
                    }
                }

                namespace Error {
                    alias Error = BadRequestError | UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @post
            @doc("Create a new teacher")
            op createTeacher(@body body: Request.Body): Response.Response;
        }

        namespace List {
            namespace Request {
                model TeacherListQuery {
                    @query
                    school_id?: Id;
                }

                alias Query = Pagination.Query & TeacherListQuery;
            }

            namespace Response {
                namespace Success {
                    alias Success = Pagination.Paginated<Teacher>;
                }

                namespace Error {
                    alias Error = UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @get
            @doc("List teachers")
            op listTeachers(...Request.Query): Response.Response;
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
                            code: "TEACHER_FOUND";
                            data: Teacher;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"TEACHER"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @get
                @doc("Get a teacher by ID")
                op getTeacherById(@path id: Request.Path): Response.Response;
            }

            namespace Update {
                namespace Request {
                    model Path {
                        @path
                        id: Id;
                    }

                    model Body {
                        school_id?: Id;
                        qualification?: string;
                        image_url?: string;
                        certificate_url?: string;
                        resume_url?: string;
                        other_positions?: string;
                        description?: string;
                    }
                }

                namespace Response {
                    namespace Success {
                        model Success {
                            @statusCode _code: 200;
                            code: "TEACHER_UPDATED";
                            data: Teacher;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"TEACHER"> | BadRequestError | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @patch
                @doc("Update a teacher by ID")
                op updateTeacherById(
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
                            code: "TEACHER_DELETED";
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"TEACHER"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @delete
                @doc("Delete a teacher by ID")
                op deleteTeacherById(@path id: Request.Path): Response.Response;
            }
        }
    }

    @tag("Guardians")
    @route("/guardians")
    namespace Guardians {
        model Guardian {
            id: Id;
            user_id: Id;
            created_at: DateTime;
            updated_at: DateTime;
        }

        namespace Create {
            namespace Request {
                model Body {
                    user_id: Id;
                }
            }

            namespace Response {
                namespace Success {
                    model Success {
                        @statusCode _code: 201;
                        code: "GUARDIAN_CREATED";
                        data: Guardian;
                    }
                }

                namespace Error {
                    alias Error = BadRequestError | UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @post
            @doc("Create a new guardian")
            op createGuardian(@body body: Request.Body): Response.Response;
        }

        namespace List {
            namespace Response {
                namespace Success {
                    alias Success = Pagination.Paginated<Guardian>;
                }

                namespace Error {
                    alias Error = UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @get
            @doc("List guardians")
            op listGuardians(...Pagination.Query): Response.Response;
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
                            code: "GUARDIAN_FOUND";
                            data: Guardian;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"GUARDIAN"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @get
                @doc("Get a guardian by ID")
                op getGuardianById(@path id: Request.Path): Response.Response;
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
                            code: "GUARDIAN_DELETED";
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"GUARDIAN"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @delete
                @doc("Delete a guardian by ID")
                op deleteGuardianById(
                    @path id: Request.Path,
                ): Response.Response;
            }
        }
    }

    @tag("Admins")
    @route("/admins")
    namespace Admins {
        enum AdminRole {
            SUPER_ADMIN,
            ACADEMIC_ADMIN,
            FINANCIAL_ADMIN,
        }

        model Admin {
            id: Id;
            user_id: Id;
            school_id: Id;
            role: AdminRole;
            permissions: string;
            last_login: DateTime;
            created_at: DateTime;
            updated_at: DateTime;
        }

        namespace Create {
            namespace Request {
                model Body {
                    user_id: Id;
                    school_id: Id;
                    role: AdminRole;
                    permissions: string;
                }
            }

            namespace Response {
                namespace Success {
                    model Success {
                        @statusCode _code: 201;
                        code: "ADMIN_CREATED";
                        data: Admin;
                    }
                }

                namespace Error {
                    alias Error = BadRequestError | UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @post
            @doc("Create a new admin")
            op createAdmin(@body body: Request.Body): Response.Response;
        }

        namespace List {
            namespace Request {
                model AdminListQuery {
                    @query
                    school_id?: Id;

                    role?: AdminRole;
                }

                alias Query = Pagination.Query & AdminListQuery;
            }

            namespace Response {
                namespace Success {
                    alias Success = Pagination.Paginated<Admin>;
                }

                namespace Error {
                    alias Error = UnexpectedError;
                }

                alias Response = Success.Success | Error.Error;
            }

            @get
            @doc("List admins")
            op listAdmins(...Request.Query): Response.Response;
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
                            code: "ADMIN_FOUND";
                            data: Admin;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"ADMIN"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @get
                @doc("Get an admin by ID")
                op getAdminById(@path id: Request.Path): Response.Response;
            }

            namespace Update {
                namespace Request {
                    model Path {
                        @path
                        id: Id;
                    }

                    model Body {
                        school_id?: Id;
                        role?: AdminRole;
                        permissions?: string;
                    }
                }

                namespace Response {
                    namespace Success {
                        model Success {
                            @statusCode _code: 200;
                            code: "ADMIN_UPDATED";
                            data: Admin;
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"ADMIN"> | BadRequestError | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @patch
                @doc("Update an admin by ID")
                op updateAdminById(
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
                            code: "ADMIN_DELETED";
                        }
                    }

                    namespace Error {
                        alias Error = NotFoundError<"ADMIN"> | UnexpectedError;
                    }

                    alias Response = Success.Success | Error.Error;
                }

                @delete
                @doc("Delete an admin by ID")
                op deleteAdminById(@path id: Request.Path): Response.Response;
            }
        }
    }
}
