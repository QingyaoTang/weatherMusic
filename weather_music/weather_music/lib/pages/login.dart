import 'package:flutter/material.dart';
import 'package:weather_music/bean/user_info.dart';
import 'package:weather_music/common/app_colors.dart';
import 'package:weather_music/common/assets.dart';
import 'package:weather_music/common/button.dart';
import 'package:weather_music/network/api/UserApi.dart';
import 'package:weather_music/network/dio_manager.dart';
import 'package:weather_music/pages/homePage.dart';
import 'package:weather_music/pages/registerPage.dart';
import 'package:weather_music/utils/sp_utils.dart';
import 'package:weather_music/widgets/common_totast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 检查账号是否有效
  bool isUserNameValid = false;

  // 创建文本编辑控制器
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _buildView(),
    );
  }

  Widget _buildView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo
          Image.asset(
            AssetsImages.loginBg,
            width: 300,
            height: 220,
            fit: BoxFit.contain,
          ),

          const SizedBox(
            height: 0,
          ),

          // 主标题
          const Text(
            "Welcome",
            style: TextStyle(
                fontSize: 30, color: AppColors.backgroundTextColor, fontWeight: FontWeight.w800),
          ),

          // 副标题
          // const Text(
          //   "",
          //   style: TextStyle(
          //       fontSize: 13,
          //       color: AppColors.backgroundTextColor,
          //       fontWeight: FontWeight.w300),
          // ),
          // 表单
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username or E-Mail
          const Text(
            "Username",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Color(0xFF838383)),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: TextField(
              controller: emailController,
              onChanged: (value) {
                setState(() {
                  isUserNameValid = value.isNotEmpty && value.length > 6;
                });
              },
              decoration: InputDecoration(
                hintText: "Please enter your username",
                prefixIcon: Image.asset(
                  AssetsImages.userPng,
                  width: 23,
                  height: 23,
                ),
                suffixIcon: isUserNameValid
                    ? Image.asset(
                  AssetsImages.donePng,
                  width: 24,
                  height: 16,
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          // Password
          const Text(
            "Password",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Color(0xFF838383)),
          ),

          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Please enter password",
                prefixIcon: Image.asset(
                  AssetsImages.passPng,
                  width: 23,
                  height: 23,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          // Sign In
          ButtonWidget(
            text: "Login",
            height: 40,
            radius: 18,
            btnColor: AppColors.loginBtnColor,
            onPressed: () async {
              await loginRequest(context);
            },
          ),

          const SizedBox(
            height: 16,
          ),

          // Don’t have an account? + Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 文字
              const Text(
                "Don’t have an account?  ",
                style: TextStyle(
                    fontSize: 15,
                    color: AppColors.backgroundTextColor,
                    fontWeight: FontWeight.w300),
              ),
              // 文字按钮
              GestureDetector(
                child:
                const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColors.backgroundTextColor,
                      fontWeight: FontWeight.w400),
                ),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return const RegisterPager();
                      }));
                },
              ),
            ]
          ),
        ],
      ),
    );
  }

  Future<void> loginRequest(BuildContext context) async {
    String email = emailController.text; // 获取Email字段的值
    String password = passwordController.text; // 获取Password字段的值

    Map<String, dynamic> data = Map();
    data["username"] = email;
    data["password"] = password;

    HttpResponse res = await login(data);
    //请求完成
    if (res.isOk()) {
      //请求成功
      if (res.data != null) {
        //请求成功有数据
        UserInfo userInfo = UserInfo.fromMap(res.data);
        if(userInfo.token != null){
          AuthManager.login(userInfo.token!);
        }else{
          showCorrectToast("token为空，登陆失败");
          return;
        }
        if(userInfo.userId != null){
          AuthManager.setUserId(userInfo.userId!);
        }else{
          showCorrectToast("userId为空，登陆失败");
          return;
        }
        if(userInfo.username != null){
          AuthManager.setUsername(userInfo.username!);
        }else{
          showCorrectToast("username为空，登陆失败");
          return;
        }
        //刷新页面
        debugPrint("解析用户信息成功 ${userInfo.username}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        debugPrint("登录成功");
        showCorrectToast("登录成功");
      } else {
        debugPrint("请求成功 暂无用户信息");
      }
    } else {
      //请求失败
      showErrorToast(res.statusMessage);
      debugPrint(
          "请求失败 ${res.statusCode}  ${res.statusMessage}");
    }
  }
}
