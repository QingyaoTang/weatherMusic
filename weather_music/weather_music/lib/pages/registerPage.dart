import 'package:flutter/material.dart';
import 'package:weather_music/common/app_colors.dart';
import 'package:weather_music/common/assets.dart';
import 'package:weather_music/common/button.dart';
import 'package:weather_music/network/api/UserApi.dart';
import 'package:weather_music/network/dio_manager.dart';
import 'package:weather_music/pages/homePage.dart';
import 'package:weather_music/widgets/common_totast.dart';

class RegisterPager extends StatefulWidget {
  const RegisterPager({super.key});

  @override
  State<RegisterPager> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPager> {
  // 检查账号是否有效
  bool isUserNameValid = false;
  // 创建文本编辑控制器
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(AppColors.homeTopTextColor, BlendMode.srcIn), // 将图标颜色修改为红色
                  child: Image.asset(
                    AssetsImages.backLogo,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 10),
              const Text(
                  "return",
                  style: TextStyle(
                  fontSize: 24,
                  color: AppColors.homeTopTextColor,
                  fontWeight: FontWeight.w500),),
            ],
          ),
          // logo
          Image.asset(
            AssetsImages.registerBg,
            width: 300,
            height: 150,
            fit: BoxFit.contain,
          ),

          const SizedBox(
            height: 0,
          ),

          // 主标题
          const Text(
            "REGISTER NOW",
            style: TextStyle(
                fontSize: 35, color: AppColors.backgroundTextColor, fontWeight: FontWeight.w500),
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
          const SizedBox(height: 10,),
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
                hintText: "user name",
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
                hintText: "Create password",
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
                // suffixIcon: TextButton(
                //   onPressed: () {},
                //   child: const Text("Forget?",
                //       style: TextStyle(
                //           fontSize: 15,
                //           fontWeight: FontWeight.w500,
                //           color: Color(0xFF0274BC))),
                // )
              ),
            ),
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
              controller: rePasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm password",
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
                // suffixIcon: TextButton(
                //   onPressed: () {},
                //   child: const Text("Forget?",
                //       style: TextStyle(
                //           fontSize: 15,
                //           fontWeight: FontWeight.w500,
                //           color: Color(0xFF0274BC))),
                // )
              ),
            ),
          ),

          const SizedBox(
            height: 30,
          ),
          // Sign In
          ButtonWidget(
            text: "register",
            height: 40,
            radius: 18,
            btnColor: AppColors.loginBtnColor,
            onPressed: () async {
              await registerRequest(context);
            },
          ),

          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }


  Future<void> registerRequest(BuildContext context) async {
    String username = emailController.text; // 获取Email字段的值
    String password = passwordController.text; // 获取Password字段的值
    String rePassword = rePasswordController.text;

    if(username.isEmpty || password.isEmpty || rePassword.isEmpty){
      showErrorToast("用户名或者密码不能为空");
      return;
    }

    if(password != rePassword){
      showErrorToast("两次密码不一致");
      return;
    }

    Map<String, dynamic> data = {};
    data["username"] = username;
    data["password"] = password;

    HttpResponse res = await register(data);
    //请求完成
    if (res.isOk()) {
      //请求成功
      if (res.statusMessage == "注册成功") {
        debugPrint("注册成功");
        showCorrectToast(res.statusMessage);
        Navigator.pop(context);
      } else {
        showErrorToast(res.statusMessage);
        debugPrint("请求成功，注册失败");
      }
    } else {
      //请求失败
      showErrorToast(res.statusMessage);
      debugPrint(
          "请求失败 ${res.statusCode}  ${res.statusMessage}");
    }
  }
}
