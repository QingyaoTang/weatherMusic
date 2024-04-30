
import 'package:weather_music/network/dio_manager.dart';
import 'package:weather_music/network/dio_options.dart';

Future login(data) async {

  String url = "${DioOptions.baseUrl}appservice/login";

  Map<String, dynamic> queryParameters = data;

  return await DioManager.instance
      .postRequest(path: url, data: queryParameters);

}

Future register(data) async {

  String url = "${DioOptions.baseUrl}appservice/register";

  Map<String, dynamic> queryParameters = data;

  return await DioManager.instance
      .postRequest(path: url, data: queryParameters);

}

Future logout() async {

  String url = "${DioOptions.baseUrl}logout";

  return await DioManager.instance
      .postRequest(path: url);

}
Future getUserInfo(int userId) async {
  String url = "${DioOptions.baseUrl}system/user/$userId";
  // Map<String, dynamic> queryParameters = data;
  return await DioManager.instance
      .getRequest(path: url);
}

Future editUserInfo(data) async {
  String url = "${DioOptions.baseUrl}system/user";
  return await DioManager.instance
      .putRequest(path: url, data: data);
}

Future editPassword(data) async {
  String url = "${DioOptions.baseUrl}system/user/resetPwd";
  return await DioManager.instance
      .putRequest(path: url, data: data);
}