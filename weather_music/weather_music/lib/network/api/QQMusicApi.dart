import 'package:dio/dio.dart';
import 'package:weather_music/bean/qqmusic_info.dart';
import 'package:weather_music/network/dio_options.dart';


// String baseQQUrl = "http://127.0.0.1:3200/";
/*5.1
  "categoryId": 52,
  "categoryName": "伤感",
5.2
  "categoryId": 122,
  "categoryName": "安静",
5.3
  "categoryId": 117,
  "categoryName": "快乐",
5.4
  "categoryId": 116,
  "categoryName": "治愈",
5.5
  "categoryId": 125,
  "categoryName": "励志",
5.6
  "categoryId": 59,
  "categoryName": "甜蜜",
5.7
  "categoryId": 55,
  "categoryName": "寂寞",
5.8
  "categoryId": 126,
  "categoryName": "宣泄",
5.9
  "categoryId": 68,
  "categoryName": "思念",*/

String port = "3200";

String musicListKey = "/getSongLists?categoryId=";

String musicListDetailKey = "/getSongListDetail?disstid=";

String musicUrlKey = "/getMusicPlay?songmid=";

String musicLrcKey = "/getLyric?isFormat=true&songmid=";


Future getMusicInfoList(icon, dissCurrentIndex) async {
  int categoryId = getCategoryId(icon);
  var dio = Dio();
  var url = "${DioOptions.getUrl()}$port$musicListKey$categoryId";
  print(url);
  List<QQMusicInfo> qqMusicList = [];
  try {
    var response = await dio.get(url);

   // 请求成功
    if (response.statusCode == 200) {
      var responseData = response.data["response"]["data"]["list"];
      // if(responseData != null){
      //   for(int i = 0; i < responseData.length; i++){
          var item = responseData[dissCurrentIndex];
          print(item.toString());
          List musicList = await getMusicList(item["dissid"]);

            for(int j = 0; j < musicList.length; j++){
              var music = musicList[j];
              QQMusicInfo qqMusicInfo = QQMusicInfo();
              qqMusicInfo.musicNam = music["name"];
              qqMusicInfo.mid = music["ksong"]["mid"];
              qqMusicList.add(qqMusicInfo);
            }
      //   }
      // }

     // 处理响应数据
      return qqMusicList;
    } else {
      // 请求失败
      print('请求失败，状态码：${response.statusCode}');
    }
  } catch (error) {
    // 发生错误
    print('请求发生错误：$error');
  }
}
Future getMusicList(dissId) async {
  var dio = Dio();
  var url = "${DioOptions.getUrl()}$port$musicListDetailKey$dissId";
  print(url);
  try {
    var response = await dio.get(url);
    // 请求成功
    if (response.statusCode == 200) {
      List responseData = response.data["response"]["cdlist"][0]["songlist"];
      // 处理响应数据
      return responseData;
    } else {
      // 请求失败
      print('请求失败，状态码：${response.statusCode}');
    }
  } catch (error) {
    // 发生错误
    print('请求发生错误：$error');
  }
}

Future getMusicUrl(songId) async {
  var dio = Dio();
  var url = "${DioOptions.getUrl()}$port$musicUrlKey$songId";
  print(url);
  try {
    var response = await dio.get(url);
    // 请求成功
    if (response.statusCode == 200) {
      var responseData = response.data;
      // 处理响应数据

      var resp = responseData["data"]["playUrl"][songId];
      return resp["url"];
    } else {
      // 请求失败
      print('请求失败，状态码：${response.statusCode}');
    }
  } catch (error) {
    // 发生错误
    print('请求发生错误：$error');
  }
}
Future getMusicLrc(songId) async {
  var dio = Dio();
  var resp = "";
  var url = "${DioOptions.getUrl()}$port$musicLrcKey$songId";
  print(url);
  try {
    var response = await dio.get(url);
    // 请求成功
    if (response.statusCode == 200) {
      var responseData = response.data;
      if(responseData["response"]["code"] == 0){
        resp = responseData["response"]["lyric"]["lyric"];
      }
      // 处理响应数据
      return resp;
    } else {
      // 请求失败
      print('请求失败，状态码：${response.statusCode}');
      return "暂无音乐歌词";
    }
  } catch (error) {
    // 发生错误
    print('请求发生错误：$error');
    return "暂无音乐歌词";
  }
}

int getCategoryId(String icon){

  if(icon == "7" || icon == "9" || icon == "10" || icon == "11" || icon == "13" || icon == "14" || icon == "26" || icon == "15"){
    return 122;//安静
  }else if(icon == "24" || icon == "27" || icon == "28" || icon == "29" || icon == "30" || icon == "31" || icon == "32" || icon == "33" || icon == "34"){
     return 117;//快乐
  }else if(icon == "20" || icon == "21" || icon == "22"){
    return 116;//治愈
  }else if(icon == ""){
    return 59;//甜蜜
  }else if(icon == "3" || icon == "4" || icon == "20" || icon == "38" || icon == "39" || icon == "40" || icon == "42"|| icon == "43" || icon == "47"){
    return 55;//寂寞
  }else if(icon == ""){
    return 68;//思念
  }else {
    return 68;//思念
  }

  return 0;
}