class ApiUrl {
  static const debug = true;

  static const serverIp = ApiUrl.debug ? "http://209.38.241.139:8000" : "";

  static get getsqlQuery {
    return ApiUrl.serverIp + "/get-sql-query";
  }

  static get getnosqlQuery {
    return ApiUrl.serverIp + "/get-nosql-query";
  }

  static get getcollection {
    return ApiUrl.serverIp + "/get-collections";
  }

  static get getData {
    return ApiUrl.serverIp + "/get-query-data";
  }

  static get getnosqlData {
    return ApiUrl.serverIp + "/get-nosql-query-data";
  }
}
