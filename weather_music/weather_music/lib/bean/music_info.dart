import 'package:weather_music/network/dio_options.dart';

class MusicInfo {
  int? musicId;
  String ? musicName;
  String ? weatherName;
  int ? weather;
  String? musicPath;

  MusicInfo.fromMap(Map map) {
    musicId = map["musicId"];
    musicName = map["musicName"];
    weather = map["weather"];
    musicPath = DioOptions.getBaseUrl() + map["musicPath"];
  }
}