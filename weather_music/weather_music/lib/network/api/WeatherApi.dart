
import 'package:geolocator/geolocator.dart';
import '../dio_manager.dart';
import 'package:dio/dio.dart';
import 'package:weather_music/bean/weather.dart';


String weatherUrl = "http://pitaya.tianqiapis.com/?version=today&unit=m&language=zh&language=en&";

String searchUrl = "query=";

String location = "36.68,116.99";

String appId = "&appid=test";

String secret = "&appsecret=test888";

// Future getWeather(data) async {
//   await getCurrentLocation();
//   String url = "$weatherUrl$searchUrl$location$appId$secret";
//   Map<String, dynamic> queryParameters = data;
//   return await DioManager.instance.getRequest(path: url);
// }

Future getWeather(data) async {
  await getCurrentLocation();

  var dio = Dio();

  var url = "$weatherUrl$searchUrl$location$appId$secret"; // 替换为您的 API URL

  try {
    var response = await dio.get(url);

    // 请求成功
    if (response.statusCode == 200) {
      var responseData = response.data;
      Weather weather = Weather.fromMap(responseData);
      // 处理响应数据
      print(weather.toString());
      return weather;
    } else {
      // 请求失败
      print('请求失败，状态码：${response.statusCode}');
    }
  } catch (error) {
    // 发生错误
    print('请求发生错误：$error');
  }
}

Future getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 检查位置服务是否启用
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 位置服务未启用，可以提示用户打开位置服务设置
    return;
  }

  // 获取位置权限
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // 位置权限被拒绝，可以请求位置权限
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      // 位置权限被拒绝，可以提示用户授权位置权限
      return;
    }
  }

  // 获取当前位置
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // 使用获取到的位置信息
  double latitude = position.latitude;
  double longitude = position.longitude;

  location="$latitude,$longitude";

  print('当前位置：$latitude, $longitude');
}