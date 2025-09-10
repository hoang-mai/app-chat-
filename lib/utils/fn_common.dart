class FnCommon {
  static bool isResponseClientSuccess(int statusCode){
    return statusCode >= 200 && statusCode < 300;
  }

  static bool isResponseClientError(int statusCode){
    return statusCode >= 400 && statusCode < 500;
  }
}