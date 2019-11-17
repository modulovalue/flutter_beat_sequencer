import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beat_sequencer/pages/main.dart';
import 'package:flutter_beat_sequencer_mac/platform_services.dart';

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