import jwt, { JwtPayload } from "jsonwebtoken";
import config from "../config";

interface JwtPayloadType extends JwtPayload {
  id?: string;
  role: string;
}
class Jwt {
  createAccessToken(payload: JwtPayloadType): string {
    return jwt.sign(payload, config.env.jwt_secret!, { expiresIn: "1h" });
  }
  createRefreshToken(payload: JwtPayloadType) {
    return jwt.sign({ id: payload.id }, config.env.jwt_secret!, {
      expiresIn: "30d",
    });
  }
  verifyToken(token: string): JwtPayloadType {
    return <JwtPayloadType>jwt.verify(token, config.env.jwt_secret!);
  }
}

export default Jwt;
