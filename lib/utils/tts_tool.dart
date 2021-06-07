import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuedu/event/tts_event.dart';

enum TtsState { playing, stopped, paused, continued }

class TTSTool {
  factory TTSTool() => _getInstance();

  static TTSTool get instance => _getInstance();
  static TTSTool? _instance;

  String? engine;
  String? _newVoiceText;
  double _rate = 0.5; //速度
  double get rate => _rate;
  double _volume = 1.0;
  double _pitch = 1.0;
  late FlutterTts flutterTts;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPause => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  TTSTool._internal() {
    _instance = this;
    flutterTts = FlutterTts();
    if (isAndroid) {
      _getDefaultEngine();
    }
    if (isIOS) {
      flutterTts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers
      ]);
    }
    flutterTts.setLanguage("zh-CN");

    flutterTts.setStartHandler(() {
      print("TTS Playing");
      ttsState = TtsState.playing;
    });
    flutterTts.setCompletionHandler(() {
      print("TTS Complete");
      eventBus.fire(TTSServiceEvent({"state": "complete"}));
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("TTS cancel");
      ttsState = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        print("TTS Paused");
        ttsState = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
        print("TTS Continued");
        ttsState = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
      print("TTS error:$msg");
      ttsState = TtsState.stopped;
    });
  }

  void setRate(double value) {
    _rate = value / 10;
  }

  Future speakContent(String voiceText) async {
    await flutterTts.setVolume(0.5);
    await flutterTts.setPitch(0.1);
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(voiceText);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      flutterTts.setEngine(engine);
    }
  }

  static TTSTool _getInstance() {
    if (_instance == null) {
      _instance = new TTSTool._internal();
    }
    return _instance!;
  }
}
