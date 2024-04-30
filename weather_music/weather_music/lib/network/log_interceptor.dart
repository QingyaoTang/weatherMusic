import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_music/main.dart';
import 'package:weather_music/utils/sp_utils.dart';

class LogsInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    super.onRequest(options, handler);
    debugPrint("================== 请求数据 ==========================");
    debugPrint("|请求url：${options.path}");
    debugPrint('|请求头: ${options.headers}');
    debugPrint('|请求参数: ${options.queryParameters}');
    debugPrint('|请求方法: ${options.method}');
    debugPrint("|contentType = ${options.contentType}");
    debugPrint('|请求时间: ${DateTime.now()}');
    if (options.data != null) {
      debugPrint('|请求数据体: ${options.data}');
    }
  }

  @override
  Future<void> onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    super.onResponse(response, handler);
    debugPrint("\n|================== 响应数据 ==========================");

    debugPrint("|url = ${response.realUri.path}");
    debugPrint("|code = ${response.statusCode}");
    debugPrint("|data = ${response.data}");
    debugPrint('|返回时间: ${DateTime.now()}');
    debugPrint("\n");

    if(response.data["code"] == 401){
      debugPrint('认证不通过');
      await AuthManager.logout();
      globalNavigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void onError(
      DioError err,
      ErrorInterceptorHandler handler,
      ) {
    super.onError(err, handler);
    debugPrint("\n================== 错误响应数据 ======================");
    debugPrint("|type = ${err.type}");
    debugPrint("|message = ${err.message}");

    debugPrint('|response = ${err.response}');
    debugPrint("\n");
  }
}
