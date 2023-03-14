class ApiUrl {

  static const debug = true;

  static const serverIp = ApiUrl.debug ? "http://127.0.0.1:8000" : "";

  static get getQuery {
    return ApiUrl.serverIp + "/get-sql-query";
  }
}