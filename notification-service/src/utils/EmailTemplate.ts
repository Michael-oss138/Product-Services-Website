class EmailTemplate {
  constructor(public username: string, public message: string) {
    this.username = username;
    this.message = message;
  }
  defaultTemplate(): string {
    return `<html>
      <p>Hello ${this.username}</p><br/>
      <p>${this.message}</p>
   </html>`;
  }
}

export default EmailTemplate;
