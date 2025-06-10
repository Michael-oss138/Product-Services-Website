import axios, {
  AxiosRequestConfig,
  AxiosRequestHeaders,
  AxiosResponse,
} from "axios";

class ApiService {
  constructor(public baseUrl: string) {
    this.baseUrl = baseUrl;
  }
  private init() {
    const request = axios.create({
      baseURL: this.baseUrl,
      withCredentials: true,
    });
    return request;
  }
  public post(
    url: string,
    data: object,
    config: AxiosRequestHeaders
  ): Promise<AxiosResponse> {
    return this.init().post(url, data, {
      headers: config,
    });
  }
}

export default ApiService;
