class UserInfo {
  int? userId;
  String ? token;
  String ? username;
  String ? nickName;
  String ? password;
  int? userAge;
  String? worke;
  String? email;

  UserInfo();

  UserInfo.fromMap(Map map) {
    userId = map["userId"];
    username = map["username"];
    nickName = map["nickName"];
    token = map["token"];
    userAge = map["userAge"];
    worke = map["worke"];
    email = map["email"];
  }
}