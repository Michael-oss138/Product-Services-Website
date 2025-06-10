export default class CustomError extends Error {
  constructor(
    public message: string,
    public code: number,
    public path?: string,
    public field?: string,
    public value?: string
  ) {
    super(message);
    this.code = code;
    this.field = field;
    this.path = path;
    this.value = value;
    Object.setPrototypeOf(this, CustomError.prototype);
  }
}
export class BadRequestError extends CustomError {
  constructor(
    public message: string,
    public path?: string,
    public field?: string,
    public value?: string
  ) {
    super(message, 400, path, field, value);
    Object.setPrototypeOf(this, BadRequestError.prototype);
  }
}
export class InternalServerError extends CustomError {
  constructor(
    public message: string,
    public path?: string,
    public field?: string,
    public value?: string
  ) {
    super(message, 500, path, field, value);
    Object.setPrototypeOf(this, InternalServerError.prototype);
  }
}

export class AuthenticationError extends CustomError {
  constructor(
    public message: string,
    public path?: string,
    public field?: string,
    public value?: string
  ) {
    super(message, 401, path, field, value);
    Object.setPrototypeOf(this, AuthenticationError.prototype);
  }
}
export class ValidationError extends CustomError {
  constructor(
    public message: string,
    public path?: string,
    public field?: string,
    public value?: string
  ) {
    super(message, 422, path, field, value);
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}
