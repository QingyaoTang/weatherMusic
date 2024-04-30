
import '../dio_manager.dart';
import '../dio_options.dart';
import 'package:dio/dio.dart';

Future getRandomOneMusic(data) async {

  String url = "${DioOptions.baseUrl}appservice/music/randomOne";
  Map<String, dynamic> queryParameters = data;

  return await DioManager.instance
      .getRequest(path: url, queryParameters: queryParameters);

}

Future getMusicList(data) async {

  String url = "${DioOptions.baseUrl}appservice/music/app/list";
  Map<String, dynamic> queryParameters = data;

  return await DioManager.instance
      .getRequest(path: url, queryParameters: queryParameters);

}
Future getMyMusicList(data) async {

  String url = "${DioOptions.baseUrl}appservice/music/app/mylist";
  Map<String, dynamic> queryParameters = data;

  return await DioManager.instance
      .getRequest(path: url, queryParameters: queryParameters);

}

Future uploadMusic(data,fileData) async {

  String url = "${DioOptions.baseUrl}common/upload";
  Map<String, dynamic> queryParameters = data;

  return await DioManager.instance
      .uploadRequest
    (path: url,
    formData: fileData,
    queryParameters: queryParameters,
    onSendProgress: (int sentBytes, int totalBytes) {
        // 上传进度回调
        double progress = sentBytes / totalBytes;
        print('上传进度：${(progress * 100).toStringAsFixed(2)}%');
      },
    onReceiveProgress: (int receivedBytes, int totalBytes) {
      // 接收进度回调
      double progress = receivedBytes / totalBytes;
      print('接收进度：${(progress * 100).toStringAsFixed(2)}%');
  },
  );

}

Future addMusicInfo(data) async {

  String url = "${DioOptions.baseUrl}appservice/music";
  Map<String, dynamic> queryParameters = data;

  return await DioManager.instance
      .postRequest(path: url, data: queryParameters);

}