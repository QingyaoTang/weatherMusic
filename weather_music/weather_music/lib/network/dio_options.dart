import 'package:dio/dio.dart';

/// BaseOptions
class DioOptions {

  /// baseURL
  static String getBaseUrl() {
    return baseUrl;
  }

  static String getUrl() {
    return url;
  }

  static String url = "http://192.168.137.1:";

  static String baseUrl = "${url}8080/";

  // 默认配置
  static BaseOptions defaultOption() {
    return BaseOptions(
      baseUrl: baseUrl,
      sendTimeout: 7000,
      receiveTimeout: 7000,
      responseType: ResponseType.json,
    );
  }

  // 自定义配置
  static BaseOptions customOption({
    String baseUrl = '',
    int? connectTimeout = 5000,
    int? receiveTimeout = 5000,
    int? sendTimeout = 5000,
    Map<String, dynamic>? headers,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      headers: headers,
      contentType: contentType,
    );
  }
}