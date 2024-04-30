import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:weather_music/bean/qqmusic_info.dart';
import 'package:weather_music/bean/weather.dart';
import 'package:weather_music/common/app_colors.dart';
import 'package:weather_music/common/assets.dart';
import 'package:weather_music/network/api/QQMusicApi.dart';
import 'package:weather_music/network/api/UserApi.dart';
import 'package:weather_music/network/api/WeatherApi.dart';
import 'package:weather_music/network/dio_manager.dart';
import 'package:weather_music/pages/login.dart';
import 'package:weather_music/pages/startPage.dart';
import 'package:weather_music/utils/sp_utils.dart';
import 'package:weather_music/widgets/common_totast.dart';

import 'const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String location = "";
  String temp = "";
  String weather = "";
  String icon = "3";
  String musicName = "musicName";
  int currentIndex = 0;
  int dissCurrentIndex = 0;
  List<QQMusicInfo> musicList = [];

  String currentLrc = "暂无音乐歌词";

  AudioPlayer audioPlayer = AudioPlayer();

  bool isPlay = false;

  var lyricModel;

  int playProgress = 111658;

  var lyricUI = UINetease();

  double max_value = 211658;
  bool isTap = false;
  double sliderProgress = 111658;
  bool useEnhancedLrc = false;

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();
   getWeatherRequest(context);

    lyricModel = LyricsModelBuilder.create()
        .bindLyricToMain(currentLrc)
        .bindLyricToExt(currentLrc)
        .getModel();

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (!mounted) return;
      if(event.index == 1){
        isPlay = true;
      }else {
        isPlay = false;
      }
      setState(() {});
    });
  audioPlayer.onPositionChanged.listen((event) {
    if (isTap) return;
    setState(() {
      sliderProgress = event.inMilliseconds.toDouble();
      playProgress = event.inMilliseconds;
    });
  });


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
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text(
                  location,
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 28, 0),
                child: Text(
                  "$temp ℃",
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  weather,
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.homeTopTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              isPlay ?
              Column(children: [
                buildReaderWidget(),
                // ...buildUIControl(),
              ])
               : Image.asset(
               AssetsImages.homeBg,
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),

              Positioned(
                left: 50,
                top: 400-35,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child:
                      GestureDetector(
                        child:ColorFiltered(
                          colorFilter: const ColorFilter.mode(AppColors.homeTopTextColor, BlendMode.srcIn), // 将图标颜色修改为红色
                          child: Image.asset(
                            AssetsImages.startLogo,
                            width: 35,
                            height: 35,
                            fit: BoxFit.contain,
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StartPage()),
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
          _buildForm(),
        ],
      ),
    );
  }

  var lyricPadding = 40.0;

  Stack buildReaderWidget() {
    return Stack(
      children: [
        ...buildReaderBackground(),
        LyricsReader(
          padding: EdgeInsets.symmetric(horizontal: lyricPadding),
          model: lyricModel,
          position: playProgress,
          lyricUi: lyricUI,
          playing: isPlay,
          size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
          emptyBuilder: () => Center(
            child: Text(
              currentLrc,
              style: lyricUI.getPlayingExtTextStyle(),
            ),
          ),
          selectLineBuilder: (progress, confirm) {
            return Row(
              children: [
                IconButton(
                    onPressed: () {
                      LyricsLog.logD("点击事件");
                      confirm.call();
                      setState(() {
                        audioPlayer?.seek(Duration(milliseconds: progress));
                      });
                    },
                    icon: Icon(Icons.play_arrow, color: Colors.green)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.green),
                    height: 1,
                    width: double.infinity,
                  ),
                ),
                Text(
                  progress.toString(),
                  style: TextStyle(color: Colors.green),
                )
              ],
            );
          },
        )
      ],
    );
  }

  List<Widget> buildPlayControl() {
    return [
      Container(
        height: 20,
      ),
      Text(
        "Progress:$sliderProgress",
        style: TextStyle(
          fontSize: 16,
          color: Colors.green,
        ),
      ),
      if (sliderProgress < max_value)
        Slider(
          min: 0,
          max: max_value,
          label: sliderProgress.toString(),
          value: sliderProgress,
          activeColor: Colors.blueGrey,
          inactiveColor: Colors.blue,
          onChanged: (double value) {
            setState(() {
              sliderProgress = value;
            });
          },
          onChangeStart: (double value) {
            isTap = true;
          },
          onChangeEnd: (double value) {
            isTap = false;
            setState(() {
              playProgress = value.toInt();
            });
            audioPlayer?.seek(Duration(milliseconds: value.toInt()));
          },
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                if (audioPlayer == null) {
                  audioPlayer = AudioPlayer()..play(AssetSource("music1.mp3"));
                  setState(() {
                    isPlay = true;
                  });
                  audioPlayer?.onDurationChanged.listen((Duration event) {
                    setState(() {
                      max_value = event.inMilliseconds.toDouble();
                    });
                  });
                  audioPlayer?.onPositionChanged.listen((Duration event) {
                    if (isTap) return;
                    setState(() {
                      sliderProgress = event.inMilliseconds.toDouble();
                      playProgress = event.inMilliseconds;
                    });
                  });

                  audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
                    setState(() {
                      isPlay = state == PlayerState.playing;
                    });
                  });
                } else {
                  audioPlayer?.resume();
                }
              },
              child: Text("Play")),
          Container(
            width: 10,
          ),
          TextButton(
              onPressed: () async {
                audioPlayer?.pause();
              },
              child: Text("Pause")),
          Container(
            width: 10,
          ),
          TextButton(
              onPressed: () async {
                audioPlayer?.stop();
                // audioPlayer = null;
              },
              child: Text("Stop")),
        ],
      ),
    ];
  }

  var mainTextSize = 18.0;
  var extTextSize = 16.0;
  var lineGap = 16.0;
  var inlineGap = 10.0;
  var lyricAlign = LyricAlign.CENTER;
  var highlightDirection = HighlightDirection.LTR;

  List<Widget> buildUIControl() {
    return [
      Container(
        height: 30,
      ),
      Text("UI setting", style: TextStyle(fontWeight: FontWeight.bold)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
              value: lyricUI.enableHighlight(),
              onChanged: (value) {
                setState(() {
                  lyricUI.highlight = (value ?? false);
                  refreshLyric();
                });
              }),
          Text("enable highLight"),
          Checkbox(
              value: useEnhancedLrc,
              onChanged: (value) {
                setState(() {
                  useEnhancedLrc = value!;
                  lyricModel = LyricsModelBuilder.create()
                      .bindLyricToMain(value ? currentLrc : currentLrc)
                      .bindLyricToExt(currentLrc)
                      .getModel();
                });
              }),
          Text("use Enhanced lrc")
        ],
      ),
      buildTitle("highlight direction"),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: HighlightDirection.values
            .map(
              (e) => Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Radio<HighlightDirection>(
                        activeColor: Colors.orangeAccent,
                        value: e,
                        groupValue: highlightDirection,
                        onChanged: (v) {
                          setState(() {
                            highlightDirection = v!;
                            lyricUI.highlightDirection = highlightDirection;
                            refreshLyric();
                          });
                        }),
                    Text(e.toString().split(".")[1])
                  ],
                ),
              )),
        )
            .toList(),
      ),
      buildTitle("lyric padding"),
      Slider(
        min: 0,
        max: 100,
        label: lyricPadding.toString(),
        value: lyricPadding,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.blue,
        onChanged: (double value) {
          setState(() {
            lyricPadding = value;
          });
        },
      ),
      buildTitle("lyric primary text size"),
      Slider(
        min: 15,
        max: 30,
        label: mainTextSize.toString(),
        value: mainTextSize,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.blue,
        onChanged: (double value) {
          setState(() {
            mainTextSize = value;
          });
        },
        onChangeEnd: (double value) {
          setState(() {
            lyricUI.defaultSize = mainTextSize;
            refreshLyric();
          });
        },
      ),
      buildTitle("lyric secondary text size"),
      Slider(
        min: 15,
        max: 30,
        label: extTextSize.toString(),
        value: extTextSize,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.blue,
        onChanged: (double value) {
          setState(() {
            extTextSize = value;
          });
        },
        onChangeEnd: (double value) {
          setState(() {
            lyricUI.defaultExtSize = extTextSize;
            refreshLyric();
          });
        },
      ),
      buildTitle("lyric line spacing"),
      Slider(
        min: 10,
        max: 80,
        label: lineGap.toString(),
        value: lineGap,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.blue,
        onChanged: (double value) {
          setState(() {
            lineGap = value;
          });
        },
        onChangeEnd: (double value) {
          setState(() {
            lyricUI.lineGap = lineGap;
            refreshLyric();
          });
        },
      ),
      buildTitle("primary and secondary lyric spacing"),
      Slider(
        min: 10,
        max: 80,
        label: inlineGap.toString(),
        value: inlineGap,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.blue,
        onChanged: (double value) {
          setState(() {
            inlineGap = value;
          });
        },
        onChangeEnd: (double value) {
          setState(() {
            lyricUI.inlineGap = inlineGap;
            refreshLyric();
          });
        },
      ),
      buildTitle("select line bias"),
      Slider(
        min: 0.3,
        max: 0.8,
        label: bias.toString(),
        value: bias,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.blue,
        onChanged: (double value) {
          setState(() {
            bias = value;
          });
        },
        onChangeEnd: (double value) {
          setState(() {
            lyricUI.bias = bias;
            refreshLyric();
          });
        },
      ),
      buildTitle("lyric align"),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: LyricAlign.values
            .map(
              (e) => Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Radio<LyricAlign>(
                        activeColor: Colors.orangeAccent,
                        value: e,
                        groupValue: lyricAlign,
                        onChanged: (v) {
                          setState(() {
                            lyricAlign = v!;
                            lyricUI.lyricAlign = lyricAlign;
                            refreshLyric();
                          });
                        }),
                    Text(e.toString().split(".")[1])
                  ],
                ),
              )),
        )
            .toList(),
      ),
      buildTitle("select line base"),
      Row(
        children: LyricBaseLine.values
            .map((e) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Radio<LyricBaseLine>(
                    activeColor: Colors.orangeAccent,
                    value: e,
                    groupValue: lyricBiasBaseLine,
                    onChanged: (v) {
                      setState(() {
                        lyricBiasBaseLine = v!;
                        lyricUI.lyricBaseLine = lyricBiasBaseLine;
                        refreshLyric();
                      });
                    }),
                Text(e.toString().split(".")[1])
              ],
            ),
          ),
        ))
            .toList(),
      ),
    ];
  }

  void refreshLyric() {
    lyricUI = UINetease.clone(lyricUI);
  }

  var bias = 0.5;
  var lyricBiasBaseLine = LyricBaseLine.CENTER;

  Text buildTitle(String title) => Text(title,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));

  List<Widget> buildReaderBackground() {
    return [
      Positioned.fill(
        child: Image.asset(
          AssetsImages.lrcBg,
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      )
    ];
  }


  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(width: 100),
              GestureDetector(
                child:
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(AppColors.homeTopTextColor, BlendMode.srcIn),
                    child: Image.asset(
                      AssetsImages.playLogo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                onTap: (){
                  playMusic();
                },
              ),

              const SizedBox(width: 30),
              GestureDetector(
                child:
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(AppColors.homeTopTextColor, BlendMode.srcIn),
                    child: Image.asset(
                      AssetsImages.pauseLogo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                onTap: (){
                  audioPlayer.pause();
                },
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Text(
              musicName,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.homeTopTextColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 80),
              GestureDetector(
                child:
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(AppColors.homeTopTextColor, BlendMode.srcIn), // 将图标颜色修改为红色
                    child: Image.asset(
                      AssetsImages.lastLogo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                onTap: (){
                  currentIndex--;
                  audioPlayer.stop();
                  playMusic();
                },
              ),
              GestureDetector(
                child:
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(AppColors.homeTopTextColor, BlendMode.srcIn), // 将图标颜色修改为红色
                    child: Image.asset(
                      AssetsImages.nextLogo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                onTap: (){
                  currentIndex++;
                  audioPlayer.stop();
                  playMusic();
                },
              ),

              const SizedBox(width: 20),
              GestureDetector(
                child:ColorFiltered(
                  colorFilter: const ColorFilter.mode(AppColors.homeTopTextColor, BlendMode.srcIn), // 将图标颜色修改为红色
                  child: Image.asset(
                    AssetsImages.logoutLogo,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
                onTap: (){
                  logoutRequest(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getWeatherRequest(BuildContext context) async {
    Map<String, dynamic> data = {};
    Weather resWeather = await getWeather(data);

    //请求完成
    if (weather != null) {
      weather = resWeather.wea ?? "unkonw";
      location = resWeather.city ?? "unkonw";
      temp = resWeather.tem ?? "unkonw";
      icon = resWeather.icon ?? "";
      setState(() {});
    } else {
      //请求失败
      showErrorToast("获取天气失败");
    }
    getMusicRequest(context);
  }

  Future<void> getMusicRequest(BuildContext context) async {
    Map<String, dynamic> data = {};
    musicList = await getMusicInfoList(icon,dissCurrentIndex);
    //请求完成
    if (musicList != null) {
      print(musicList.toString());
      // playMusic();
      setState(() {});
    } else {
      //请求失败
      showErrorToast("获取音乐失败");
    }
  }

  Future<void> playMusic() async {
    if(currentIndex < musicList.length){
      QQMusicInfo qqMusicInfo = musicList[currentIndex];
      if(qqMusicInfo != null && qqMusicInfo.mid != null){
        var url = await getMusicUrl(qqMusicInfo.mid);
        var lrc = await getMusicLrc(qqMusicInfo.mid);
        print("当前播放的是lrc：$lrc");
        currentLrc = lrc;
        try{
          lyricModel = LyricsModelBuilder.create()
              .bindLyricToMain(currentLrc)
              .bindLyricToExt(currentLrc)
              .getModel();
        }catch(error) {
          // 发生错误
          print('请求发生错误：$error');
          currentIndex++;
          playMusic();
          return;
        }
        print("当前播放的是url：$url");
        if(url == null || url == ""){
          currentIndex++;
          playMusic();
        }else{
          showCorrectToast("当前播放的是：${qqMusicInfo.musicNam}");
          musicName = qqMusicInfo.musicNam ?? "unknow";
          qqMusicInfo.url = url as String?;
          audioPlayer.play(UrlSource(qqMusicInfo.url ?? ""));
        }
      }else{
        currentIndex++;
        playMusic();
      }
    }else{
      dissCurrentIndex++;
      await getMusicRequest(context);
      playMusic();
    }
  }


  Future<void> logoutRequest(BuildContext context) async {
    HttpResponse res = await logout();
    //请求完成
    if (res.isOk()) {
      //请求成功
      await AuthManager.logout();
      await AuthManager.delUserId();
      await AuthManager.delUsername();
      debugPrint("退出成功");
      showCorrectToast(res.statusMessage);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      //请求失败
      showErrorToast(res.statusMessage);
      debugPrint(
          "请求失败 ${res.statusCode}  ${res.statusMessage}");
    }
  }

}