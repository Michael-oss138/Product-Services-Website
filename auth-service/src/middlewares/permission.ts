import { Request, Response, NextFunction } from "express";
import Security from "../database/models/Security";
import { AuthenticationError } from "../utils/CustomError";
import config from "../config";
import Jwt from "../utils/Jwt";
const jwt = new Jwt();

export default async function permission(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) throw new AuthenticationError("Invalid auth token");
    const decoded = jwt.verifyToken(token);
    const securityData = await Security.findById(decoded.id);
    if (!securityData) throw new Error("Invaid Auth token");
    const userPermissions: string[] =
      config.permission[securityData.role as keyof typeof permission];
    const isPermitted = userPermissions.includes(req.body.role);
    if (!isPermitted) {
      throw new AuthenticationError("Unauthorized request received!");
    }
    next();
  } catch (error) {
    next(error);
  }
}
