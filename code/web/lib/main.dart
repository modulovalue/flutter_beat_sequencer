import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_beat_sequencer/pages/main.dart';
import 'package:flutter_beat_sequencer/platform_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Beat Sequencer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(WebBeatSequencerServices()),
    );
  }
}

class WebBeatSequencerServices extends BeatSequencerPlatformServices {
  @override
  void openURL(String str) {
    js.context.callMethod("open", <dynamic>[str]);
  }

  @override
  void playSound(String soundID) {
    js.context[soundID].callMethod("play");
  }
}