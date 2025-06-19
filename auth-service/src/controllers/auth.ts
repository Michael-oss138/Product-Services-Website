import authService from "../services/authService";
import catchAsync from "../utils/catchAsync";

export const signupUser = catchAsync(async (req, res) => {
  await authService.signupUser(req.body, req.headers);
  res.status(201).json({
    success: true,
    message: "User created!",
  });
});
export const signinUser = catchAsync(async (req, res) => {
  const tokens = await authService.signinUser(req.body, req.headers, req.ip);
  res.status(200).json({
    success: true,
    message: "Signin successful!",
    tokens,
  });
});
export const renewToken = catchAsync(async (req, res) => {
  const accessToken = await authService.renewToken(req.headers);
  res.status(200).json({
    success: true,
    message: "Signin successful!",
    accessToken,
  });
});
export const logout = catchAsync(async (req, res) => {
  await authService.logout(req.headers);
  res.status(200).json({
    success: true,
    message: "Logout successful",
  });
});
