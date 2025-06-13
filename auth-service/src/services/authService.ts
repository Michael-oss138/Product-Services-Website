import ApiService from "./ApiService";
import Security from "../database/models/Security";
import History from "../database/models/History";
import Encryption from "../utils/Encryption";
import { AuthenticationError } from "../utils/CustomError";
import Jwt from "../utils/Jwt";

const encrypt = new Encryption();
const jwt = new Jwt();
const apiRequest = new ApiService("http://localhost:4848/user");

class AuthService {
  async signupUser(body: any, headers: any) {
    try {
      const resp = await apiRequest.post("/create", body, headers);
      const data = resp.data.body;
      await Security.create({
        userId: data.userId,
        password: body.password,
        role: body.role,
      });
    } catch (error) {
      throw error;
    }
  }
  async signinUser(body: any, headers: any, ip?: string) {
    try {
      const resp = await apiRequest.post("/user", body, headers);
      const data = resp.data.body;
      const securityData = await Security.findOne({ userId: data.userId });
      if (!securityData) {
        throw new AuthenticationError("Incorrect creditials entered");
      }
      const { password, role, userId } = securityData;
      const doMatch = await encrypt.verifyHash(body.password, password);
      if (!doMatch) {
        throw new AuthenticationError("Incorrect creditials entered");
      }
      await History.create({
        ipAddress: ip || headers["x-forwared-for"],
        userId,
        device: headers["user-agent"],
      });
      const accessToken = jwt.createToken({ role, id: userId });
      return accessToken;
    } catch (error) {
      throw error;
    }
  }
}

export default new AuthService();
