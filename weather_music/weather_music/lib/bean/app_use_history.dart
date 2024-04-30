class AppHistory {
  int? historyId;
  int? time;
  String ? date;


  AppHistory.fromMap(Map map) {
    historyId = map["historyId"];
    time = map["time"];
  }
}