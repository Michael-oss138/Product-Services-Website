import jwt, { JwtPayload } from "jsonwebtoken";
import config from "../config";

interface JwtPayloadType extends JwtPayload {
  id?: string;
  role: string;
}
class Jwt {
  createToken(payload: JwtPayloadType): string {
    return jwt.sign(payload, config.env.jwt_secret!);
  }
  verifyToken(token: string): JwtPayloadType {
    return <JwtPayloadType>jwt.verify(token, config.env.jwt_secret!);
  }
}

export default Jwt;
