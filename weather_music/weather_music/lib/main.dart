import 'package:weather_music/pages/homePage.dart';
import 'package:weather_music/pages/login.dart';
import 'package:flutter/material.dart';

import 'utils/sp_utils.dart';

void main() {
  runApp(MyApp());
}

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();

class MyApp extends StatelessWidget {

  MyApp({super.key});

  bool isLogin = false;

  Future<bool> obtionSharedPrefs() async {
    // 在启动页中检查用户的登录状态
    var bool = await AuthManager.isLoggedIn();
    if (bool) {
      isLogin = true;
    } else {
      // 用户未登录，跳转到登录页
      isLogin = false;
    }
    return isLogin;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
          future: obtionSharedPrefs(),
          builder: (BuildContext context,AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); //加载中
            } else if (snapshot.connectionState == ConnectionState.done) { //加载完成
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.data == true) {
                return const HomePage(); //已经登录过 直接进入首页
              } else {
                return const LoginPage(); //没有登录过 进入登录页面
              }
            } else { //异常
              return Text('State: ${snapshot.connectionState}');
            }
          }
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins", primarySwatch: Colors.orange),
    );
  }
}
