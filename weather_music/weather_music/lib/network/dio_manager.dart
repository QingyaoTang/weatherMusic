import 'dart:async';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:weather_music/utils/sp_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'dio_options.dart';
import 'log_interceptor.dart';

class HttpResponse {
  int statusCode = 200;
  dynamic data;
  String statusMessage = "请求成功";

  bool isOk() => statusCode == 200;

  HttpResponse.ok({
    this.data,
    this.statusCode = 200,
    this.statusMessage = "请求成功",
  });

  HttpResponse.err({int? statusCode, String? statusMessage}) {
    this.statusCode = statusCode ?? 500;
    this.statusMessage = statusMessage ?? "网络错误";
  }
}

///设置代理[setProxy]
class DioManager {
  static Dio? _dio;

  // 工厂模式
  factory DioManager() => _getInstance();

  static DioManager get instance => _getInstance();
  static DioManager? _instance;

  static DioManager _getInstance() {
    _instance ??= DioManager._internal();
    return _instance!;
  }

  // 获取dio
  Dio? get dio => _dio;

  // 初始化
  DioManager._internal() {
    _dio ??= Dio(DioOptions.defaultOption());

    //当App运行在Release环境时，inProduction为true；
    // 当App运行在Debug和Profile环境时，inProduction为false。
    bool inProduction = const bool.fromEnvironment("dart.vm.product");
    if (!inProduction) {
      debugFunction();
    }
  }

  /// 设置代理
  static setProxy({String? address}) {
    (_dio?.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        if (address != null && address.isNotEmpty) {
          return 'PROXY $address';
        } else {
          return 'DIRECT';
        }
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        //忽略证书
        return true;
      };
      return null;
    };
  }

  debugFunction() {
    // 添加log
    _dio?.interceptors.add(LogsInterceptors());
  }

  /// get 方法
  Future<HttpResponse> getRequest(
      {required String path,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    _dio?.options = await buildOptions(_dio!.options);
    Response? response = await _dio?.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
    return _commonResponse(response);
  }

  static HttpResponse _commonResponse(Response? response) {
    if (response == null) {
      return HttpResponse.err();
    }
    int? statusCode = response.statusCode;
    String? statusMessage = response.statusMessage;
    if (statusCode != null && statusCode == 200) {
      dynamic result = response.data;
      if (result == null) {
        return HttpResponse.ok();
      }
      int code = result["code"];
      String msg = result["msg"];
      dynamic data = result["data"];
      return HttpResponse.ok(data: data, statusCode: code, statusMessage: msg);
    } else {
      return HttpResponse.err(
          statusCode: statusCode, statusMessage: statusMessage);
    }
  }

  static Future<BaseOptions> buildOptions(BaseOptions options,
      {String contentType = "application/json"}) async {
    ///请求header的配置
    options.headers["productId"] = Platform.isAndroid ? "Android" : "IOS";
    options.headers["application"] = "yuxi";

    //添加token
    String? token = await AuthManager.getToken();
    if(token != null){
      options.headers["Authorization"] = "Bearer $token";
    }
    /// 打包配置
    options.headers["appChannle"] = "common";
    options.headers["content-type"] = contentType;
    if (Platform.isAndroid || Platform.isIOS) {
      //获取当前App的版本信息
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      options.headers["appVersion"] = version;
      options.headers["buildNumber"] = buildNumber;
    }
    return Future.value(options);
  }

  /// post 方法
  Future<HttpResponse> postRequest(
      {required String path,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      ProgressCallback? onSendProgress,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    _dio?.options = await buildOptions(_dio!.options);
    Response? response = await _dio?.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return _commonResponse(response);
  }


  /// put 方法
  Future<HttpResponse> putRequest(
      {required String path,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    Response? response = await _dio?.put(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return _commonResponse(response);
  }

  /// head 方法
  static Future<HttpResponse> head(
      {required String path,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    Response? response = await _dio?.head(path,
        data: data, queryParameters: queryParameters, options: options);
    return _commonResponse(response);
  }

  /// delete 方法
  static Future<HttpResponse> deleteRequest(
      {required String path,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    Response? response = await _dio?.delete(path,
        data: data, queryParameters: queryParameters, options: options);
    return _commonResponse(response);
  }

  /// patch 方法
  static Future<HttpResponse> patch(
      {required String path,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    Response? response = await _dio?.patch(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return _commonResponse(response);
  }

  /// download 方法
  static Future<Response> downloadRequest(
      {required String urlPath,
      required String savePath,
      Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options,
      ProgressCallback? onReceiveProgress}) async {
    Response? response = await _dio?.download(urlPath, savePath,
        queryParameters: queryParameters,
        data: data,
        options: options,
        onReceiveProgress: onReceiveProgress);
    return response?.data;
  }

  /// upload 方法 (eg:formData可以是字符串路径,也可以是文件的二进制数据data)
  Future<dynamic> uploadRequest(
      {required String path,
      dynamic formData,
      Map<String, dynamic>? queryParameters,
      Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    FormData uploadFormData;
    switch (formData.runtimeType) {
      case String:
        uploadFormData = FormData.fromMap({
          'file': MultipartFile.fromFileSync(
            formData,
            filename: '${DateTime.now().microsecondsSinceEpoch}.mp3',
          )
        });
        break;

      case List:
        uploadFormData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            formData,
            filename: '${DateTime.now().microsecondsSinceEpoch}.mp3',
          )
        });
        break;

      default:
        uploadFormData = FormData.fromMap({});
        break;
    }
    _dio?.options = await buildOptions(_dio!.options);
    Response? response = await _dio?.post(path,
        data: uploadFormData,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return response?.data;
  }
}
