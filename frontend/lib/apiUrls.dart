class ApiUrl {
  static const debug = true;

  static const serverIp = ApiUrl.debug ? "http://209.38.241.139:8000" : "";

  static get getQuery {
    return ApiUrl.serverIp + "/get-sql-query";
  }

  static get getData {
    return ApiUrl.serverIp + "/get-query-data";
  }
}
