import bcrypt from "bcryptjs";

class Encryption {
  hashInput(input: string): Promise<string> {
    return bcrypt.hash(input, 12);
  }
  verifyHash(input: string, hash: string): Promise<boolean> {
    return bcrypt.compare(input, hash);
  }
}

export default Encryption;
