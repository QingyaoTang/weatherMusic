
import '../dio_manager.dart';
import '../dio_options.dart';


Future getMonthHistoryList(data) async {
  String url = "${DioOptions.baseUrl}appservice/history/app/list";
  Map<String, dynamic> queryParameters = data;
  return await DioManager.instance
      .getRequest(path: url, queryParameters: queryParameters);
}

Future addHistory(data) async {
  String url = "${DioOptions.baseUrl}appservice/history";
  Map<String, dynamic> queryParameters = data;
  return await DioManager.instance
      .postRequest(path: url, data: queryParameters);
}
Future upHistory(data) async {
  String url = "${DioOptions.baseUrl}appservice/history/forAppRecord";
  Map<String, dynamic> queryParameters = data;
  return await DioManager.instance
      .postRequest(path: url, data: queryParameters);
}