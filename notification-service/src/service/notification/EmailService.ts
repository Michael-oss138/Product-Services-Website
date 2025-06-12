import nodemailer from "nodemailer";
import EmailTemplate from "../../utils/EmailTemplate";
import env from "../../config/env";

class EmailService {
  constructor(
    public name: string,
    public email: string,
    public subject: string,
    public message: string
  ) {
    this.name = name;
    this.email = email;
    this.subject = subject;
    this.message = message;
  }
  init() {
    return nodemailer.createTransport({
      auth: {
        user: env.email,
        pass: env.e_pass,
      },
      secure: true,
      tls: {
        rejectUnauthorized: false,
      },
      port: 465,
      host: "mail.metroblue.com.ng",
    });
  }
  sendSingleEmail() {
    const template = new EmailTemplate(this.name, this.message);
    return this.init().sendMail({
      from: `"Educesol"<${env.email}>`,
      to: this.email,
      subject: this.subject,
      html: template.defaultTemplate(),
    });
  }
}

export default EmailService;
