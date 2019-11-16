import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beat_sequencer/pages/main.dart';
import 'package:flutter_beat_sequencer/platform_services.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mac Beat Sequencer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(MacBeatSequencerServices()),
    );
  }
}

class MacBeatSequencerServices extends BeatSequencerPlatformServices {
  @override
  void openURL(String str) {
    Process.run("open", [str]);
  }

  @override
  void playSound(String soundID) {
    /// TODO
  }
}