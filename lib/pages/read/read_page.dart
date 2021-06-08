import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/db/bookShelf.dart';

import 'package:yuedu/gen/assets.gen.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/model/bookShelfModel.dart';
import 'package:yuedu/pages/read/battery_widget.dart';
import 'package:yuedu/utils/tools.dart';

import 'package:yuedu/widget/pageWidget.dart';

class ReadPage extends StatefulWidget {
  ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

enum TtsState { playing, stopped, paused, continued }

class _ReadPageState extends State<ReadPage> {
  bool showController = false;
  ScrollController _catalogueListController = ScrollController();
  bool ttsOpen = false;
  double ttsShowValue = 0.5;

  /*
  ==========================TTS==========================
   */
  late FlutterTts flutterTts;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;
  String? _newVoiceText;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  initTts() async {
    flutterTts = FlutterTts();

    if (isAndroid) {
      await _getDefaultEngine();
    }
    await flutterTts.setSharedInstance(true);

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        Provider.of<BookDetailModel>(context, listen: false).pageTurning(true);
        Provider.of<BookShelfModel>(context, listen: false).updateBookInfo(
            Provider.of<BookDetailModel>(context, listen: false).openBookInfo);
        _newVoiceText =
            Provider.of<BookDetailModel>(context, listen: false).showStr;
        _speak();
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setLanguage("zh-CN");
    if (Platform.isIOS) {
      await flutterTts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
      ]);
    }
  }

  // Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    await flutterTts.setEngine("com.google.android.tts");
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // Future _pause() async {
  //   var result = await flutterTts.pause();
  //   if (result == 1) setState(() => ttsState = TtsState.paused);
  // }
  /*
  ==========================TTS END==========================
 */

  @override
  void initState() {
    super.initState();
    initTts();
    ttsShowValue = rate;
  }

  Widget _topBar() {
    return Container(
      color: Colors.black87,
      height: ScreenTools.getStatusBarHeight() + ScreenTools.getAppBarHeight(),
      padding: EdgeInsets.only(top: ScreenTools.getStatusBarHeight()),
      child: Container(
        child: Row(
          children: [
            BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: ScreenTools.getSize(30)),
              child: Text(
                Provider.of<BookDetailModel>(context, listen: false)
                    .openBookInfo
                    .title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: ScreenTools.getSize(50), color: Colors.white),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: ScreenTools.getScreenBottomBarHeight() + ScreenTools.getSize(420),
      color: Colors.black87,
      padding: EdgeInsets.only(bottom: ScreenTools.getScreenBottomBarHeight()),
      child: Container(
        child: Column(
          children: [
            _catalogureControllerWidget(),
            Container(
              margin: EdgeInsets.only(top: ScreenTools.getSize(45)),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _bottomBtn(
                      Icon(
                        Icons.view_list,
                        size: ScreenTools.getSize(60),
                        color: Colors.white,
                      ),
                      "目录", () {
                    _scaffoldKey.currentState!.openDrawer();

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _catalogueListController.jumpTo(ScreenTools.getSize(132) *
                          Provider.of<BookDetailModel>(context, listen: false)
                              .nowCatalogueIndex!);
                    });
                  }),
                  _bottomBtn(
                      Icon(
                        Icons.headset,
                        size: ScreenTools.getSize(60),
                        color: Colors.white,
                      ),
                      "听书", () {
                    setState(() {
                      ttsOpen = true;
                    });
                    _newVoiceText =
                        Provider.of<BookDetailModel>(context, listen: false)
                            .showStr;
                    _speak();
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _catalogureControllerWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenTools.getSize(36)),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: ScreenTools.getSize(1), color: Colors.grey))),
      height: ScreenTools.getSize(196),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                if (Provider.of<BookDetailModel>(context, listen: false)
                        .nowCatalogueIndex !=
                    0) {
                  Provider.of<BookDetailModel>(context, listen: false)
                      .jumpToCatalogue(
                          Provider.of<BookDetailModel>(context, listen: false)
                              .nowCatalogueIndex!);
                  Provider.of<BookShelfModel>(context, listen: false)
                      .updateBookInfo(
                          Provider.of<BookDetailModel>(context, listen: false)
                              .openBookInfo);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Text(
                  "上一章",
                  style: TextStyle(
                      fontSize: ScreenTools.getSize(45),
                      color: Provider.of<BookDetailModel>(context, listen: true)
                                  .nowCatalogueIndex ==
                              0
                          ? Colors.grey
                          : Colors.white),
                ),
              )),
          Expanded(
              child: Container(
            child: Slider(
              min: 1,
              max: Provider.of<BookDetailModel>(context, listen: true)
                      .openBookCatalogue
                      .length *
                  1.0,
              divisions: Provider.of<BookDetailModel>(context, listen: true)
                  .openBookCatalogue
                  .length,
              value: Provider.of<BookDetailModel>(context, listen: true)
                  .catalogureSliderValue,
              label: Provider.of<BookDetailModel>(context, listen: true)
                  .catalogureSliderValue
                  .toStringAsFixed(0),
              onChanged: (v) {
                Provider.of<BookDetailModel>(context, listen: false)
                    .updateSliderValue(v);
              },
              onChangeEnd: (v) {
                Provider.of<BookDetailModel>(context, listen: false)
                    .jumpToCatalogue(v.toInt());
                Provider.of<BookShelfModel>(context, listen: false)
                    .updateBookInfo(
                        Provider.of<BookDetailModel>(context, listen: false)
                            .openBookInfo);
              },
            ),
          )),
          GestureDetector(
              onTap: () {
                if (Provider.of<BookDetailModel>(context, listen: false)
                        .nowCatalogueIndex !=
                    Provider.of<BookDetailModel>(context, listen: false)
                            .openBookCatalogue
                            .length -
                        1) {
                  Provider.of<BookDetailModel>(context, listen: false)
                      .jumpToCatalogue(
                          Provider.of<BookDetailModel>(context, listen: false)
                                  .nowCatalogueIndex! +
                              2);
                  Provider.of<BookShelfModel>(context, listen: false)
                      .updateBookInfo(
                          Provider.of<BookDetailModel>(context, listen: false)
                              .openBookInfo);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Text(
                  "下一章",
                  style: TextStyle(
                      fontSize: ScreenTools.getSize(45),
                      color: Provider.of<BookDetailModel>(context, listen: true)
                                  .nowCatalogueIndex ==
                              Provider.of<BookDetailModel>(context,
                                          listen: true)
                                      .openBookCatalogue
                                      .length -
                                  1
                          ? Colors.grey
                          : Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  Widget _bottomBtn(Icon btnIcon, String title, Function func) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        func();
      },
      child: Container(
        height: ScreenTools.getSize(160),
        width: ScreenTools.getSize(160),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: btnIcon,
            ),
            Container(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: ScreenTools.getSize(40), color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _pageControl() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!ttsOpen) {
                Provider.of<BookDetailModel>(context, listen: false)
                    .pageTurning(false);
                Provider.of<BookShelfModel>(context, listen: false)
                    .updateBookInfo(
                        Provider.of<BookDetailModel>(context, listen: false)
                            .openBookInfo);
              }
            },
            child: Container(),
          )),
          Expanded(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                showController = true;
              });
            },
            child: Container(),
          )),
          Expanded(
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (!ttsOpen) {
                      Provider.of<BookDetailModel>(context, listen: false)
                          .pageTurning(true);
                      Provider.of<BookShelfModel>(context, listen: false)
                          .updateBookInfo(Provider.of<BookDetailModel>(context,
                                  listen: false)
                              .openBookInfo);
                    }
                  },
                  child: Container()))
        ],
      ),
    );
  }

  Widget _readControl() {
    return Offstage(
      offstage: !(showController && !ttsOpen),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            _topBar(),
            Expanded(
                child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  showController = false;
                });
              },
            )),
            _bottomBar()
          ],
        ),
      ),
    );
  }

  Widget _ttsControl() {
    return Offstage(
      offstage: !(ttsOpen && showController),
      child: Container(
        child: Column(
          children: [
            Expanded(
                child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  showController = false;
                });
              },
              child: Container(),
            )),
            Container(
              color: Colors.black87,
              padding: EdgeInsets.only(
                  bottom: ScreenTools.getScreenBottomBarHeight()),
              child: Column(
                children: [
                  Container(
                    height: ScreenTools.getSize(139),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenTools.getSize(51)),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "语速",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenTools.getSize(45)),
                          ),
                        ),
                        Container(
                          child: Text(
                            "慢",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenTools.getSize(45)),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenTools.getSize(60)),
                        ),
                        Expanded(
                            child: Slider(
                          min: 0.1,
                          max: isAndroid ? 1.5 : 0.75,
                          divisions: 5,
                          value: ttsShowValue,
                          onChanged: (double value) {
                            setState(() {
                              ttsShowValue = value;
                            });
                          },
                          onChangeEnd: (value) {
                            rate = value;
                            print(rate);
                            _stop();
                            _speak();
                          },
                        )),
                        Container(
                          child: Text(
                            "快",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenTools.getSize(45)),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenTools.getSize(60)),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _stop();
                      setState(() {
                        ttsOpen = false;
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: ScreenTools.getSize(139),
                      alignment: Alignment.center,
                      child: Text(
                        "退出听书",
                        style: TextStyle(
                            fontSize: ScreenTools.getSize(50),
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _catalogueDrawer(),
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Assets.images.readBg.image(fit: BoxFit.fill),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenTools.getSize(28)),
                  alignment: Alignment.centerLeft,
                  height: ScreenTools.getSize(106),
                  width: double.infinity,
                  child: AutoSizeText(
                    Provider.of<BookDetailModel>(context, listen: true)
                                .nowCatalogueIndex ==
                            null
                        ? ""
                        : Provider.of<BookDetailModel>(context, listen: true)
                            .openBookCatalogue[Provider.of<BookDetailModel>(
                                    context,
                                    listen: true)
                                .nowCatalogueIndex!]
                            .title,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: ScreenTools.getSize(47),
                        fontWeight: FontWeight.w200),
                  ),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenTools.getSize(45)),
                      child: PageWidget(),
                    ),
                  ],
                )),
                Container(
                  height: ScreenTools.getSize(99),
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenTools.getSize(45)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BatteryWidget(),
                            Container(
                              margin: EdgeInsets.only(
                                  left: ScreenTools.getSize(40)),
                              child: Text(Provider.of<BookDetailModel>(context,
                                      listen: true)
                                  .dateTimeShow),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Provider.of<BookDetailModel>(context,
                                        listen: true)
                                    .totalPage ==
                                null
                            ? Container()
                            : Text(
                                "${Provider.of<BookDetailModel>(context, listen: true).nowPage}/${Provider.of<BookDetailModel>(context, listen: true).totalPage}页"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          _pageControl(),
          _readControl(),
          _ttsControl()
        ],
      ),
    );
  }

  Widget _catalogueDrawer() {
    return Drawer(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xfffefefe),
          child: SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: ScreenTools.getSize(132)),
              itemExtent: ScreenTools.getSize(132),
              controller: _catalogueListController,
              itemBuilder: (context, index) {
                BookCatalogue bc =
                    Provider.of<BookDetailModel>(context, listen: true)
                        .openBookCatalogue[index];

                return ListTile(
                  onTap: () {
                    Provider.of<BookDetailModel>(context, listen: false)
                        .jumpToCatalogue(index + 1);
                    Provider.of<BookShelfModel>(context, listen: false)
                        .updateBookInfo(
                            Provider.of<BookDetailModel>(context, listen: false)
                                .openBookInfo);
                    Navigator.of(context).pop();
                  },
                  title: AutoSizeText(
                    bc.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenTools.getSize(30),
                        fontWeight:
                            Provider.of<BookDetailModel>(context, listen: false)
                                        .nowCatalogueIndex ==
                                    index
                                ? FontWeight.bold
                                : FontWeight.w200),
                  ),
                  trailing: bc.bookId == null
                      ? null
                      : Container(
                          width: ScreenTools.getSize(60),
                          height: ScreenTools.getSize(60),
                          child: bc.content != ""
                              ? Icon(Icons.cloud_done)
                              : Icon(Icons.cloud_download_outlined)),
                );
              },
              itemCount: Provider.of<BookDetailModel>(context, listen: true)
                  .openBookCatalogue
                  .length,
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }
}
