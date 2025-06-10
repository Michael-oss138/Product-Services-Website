import authService from "../services/authService";
import catchAsync from "../utils/catchAsync";

export const signupUser = catchAsync(async (req, res) => {
  await authService.signupUser(req.body, req.headers);
  res.status(201).json({
    success: true,
    message: "User created!",
  });
});
