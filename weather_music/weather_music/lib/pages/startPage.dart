import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_music/common/app_colors.dart';
import 'package:weather_music/common/assets.dart';
import 'package:weather_music/network/api/StartApi.dart';
import 'package:weather_music/widgets/common_totast.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  /*星座*/
  String startNa = "Scorpio";
  /*日期*/
  String dateRan = "October 24th to November 22nd";
  /*健康指数*/
  String health = "40%";
  /*幸运色*/
  String luckyColor = "Onyx";
  /*幸运数字*/
  String luckyNumber = "6";
  /*星座运势描述*/
  String starMsg = "";

  @override
  void initState() {
    super.initState();
    getZodiacSign(DateTime.now());
    getStartRequest(context);
  }

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
          const SizedBox(height: 10),
          Text(
            startNa,
            style: const TextStyle(
                fontSize: 15,
                color: AppColors.homeTopTextColor,
                fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              // 居左元素
              Container(
                // 您可以根据需要调整容器的样式和大小
                child:
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
              ),
              // 居中元素
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  // 您可以根据需要调整容器的样式和大小
                  child:
                  Text(
                    dateRan,
                    style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.homeTopTextColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const Text(
                  "Health Index",
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const Text(
                  "Lucky Color",
                  style:  TextStyle(
                      fontSize: 15,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const Text(
                  "Lucky Number",
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  health,
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  luckyColor,
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child:  Text(
                 luckyNumber,
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Image.asset(
                AssetsImages.start1Bg,
                width: 260,
                height: 260,
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(
            height: 130,
            width: 320,
            child: ListView(
              children: [
                Text(
                  starMsg,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Image.asset(
            AssetsImages.startBg,
            width: 300,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }


  Future<void> getStartRequest(BuildContext context) async {
    Map<String, dynamic> data = {};
    // data["username"] = email;
    // data["password"] = password;

    var resStartInfo = await getStartInfo(startNa);

    //请求完成
    if (resStartInfo != null) {
      health = resStartInfo.health ?? "unkonw";
      luckyColor = resStartInfo.luckyColor ?? "unkonw";
      luckyNumber = resStartInfo.luckyNumber ?? "unkonw";
      starMsg = resStartInfo.info ?? "unkonw";
      setState(() {});
    } else {
      //请求失败
      showErrorToast("获取运势失败");
    }
  }
  String getZodiacSign(DateTime date) {
    int month = date.month;
    int day = date.day;

    String signName = '';
    String dateRange = '';

    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      signName = 'aquarius';
      dateRange = 'January 20th to February 18th';
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      signName = 'pisces';
      dateRange = 'February 19th to March 20th';
    } else if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      signName = 'aries';
      dateRange = 'March 21st to April 19th';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      signName = 'taurus';
      dateRange = 'April 20th to May 20th';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      signName = 'gemini';
      dateRange = 'May 21st to June 20th';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      signName = 'cancer';
      dateRange = 'June 21st to July 22nd';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      signName = 'leo';
      dateRange = 'July 23rd to August 22nd';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      signName = 'virgo';
      dateRange = 'August 23rd to September 22nd';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      signName = 'libra';
      dateRange = 'September 23rd to October 22nd';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      signName = 'scorpio';
      dateRange = 'October 23rd to November 21st';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      signName = 'sagittarius';
      dateRange = 'November 22nd to December 21st';
    } else {
      signName = 'capricorn';
      dateRange = 'December 22nd to January 19th';
    }
    startNa = signName;
    dateRan = dateRange;
    setState(() {});
    return '$signName: $dateRange';
  }

}