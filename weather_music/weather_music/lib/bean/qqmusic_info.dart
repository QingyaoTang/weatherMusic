class QQMusicInfo {
  String ?mid;
  String ?musicNam;
  String ?url;
  String ?lrc;


  QQMusicInfo({
    this.musicNam,
    this.url,
    this.lrc,
    this.mid,
  });

  QQMusicInfo.fromMap(Map map) {
    musicNam = map["city"];
    url = map["day"]["phrase"];
    lrc = map["day"]["temperature"];

  }

}