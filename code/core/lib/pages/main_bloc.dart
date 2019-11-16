import 'dart:async';

import 'package:bird/bird.dart';
import 'package:quiver/async.dart';
import 'package:flutter_beat_sequencer/pages/pattern.dart';

abstract class Playable {
  void playAtBeat(TimelineBloc bloc, int beat);
}

// ignore_for_file: close_sinks
class PlaybackBloc extends HookBloc implements Playable {
  final Signal<bool> _metronomeStatus = HookBloc.disposeSink(Signal(false));

  List<TrackBloc> tracks;
  Wave<bool> metronomeStatus;

  final void Function(String) playSound;

  PlaybackBloc(this.playSound) {
    tracks = [
      TrackBloc(32, SoundSelector("808", () => playSound("bass"))),
      TrackBloc(32, SoundSelector("Clap", () => playSound("clap"))),
      TrackBloc(32, SoundSelector("Hat", () => playSound("hat"))),
      TrackBloc(32, SoundSelector("Open Hat", () => playSound("open_hat"))),
      TrackBloc(32, SoundSelector("Kick 1", () => playSound("kick"))),
      TrackBloc(32, SoundSelector("Kick 2", () => playSound("kick2"))),
      TrackBloc(32, SoundSelector("Snare 1", () => playSound("snare_1"))),
      TrackBloc(32, SoundSelector("Snare 2", () => playSound("snare_2"))),
    ];
    tracks.map((a) => a.dispose).forEach(disposeLater);
    metronomeStatus = _metronomeStatus.wave;
  }

  @override
  void playAtBeat(TimelineBloc bloc, int beat) {
    if (_metronomeStatus.value && beat % 4 == 0) {
      if (beat % 16 == 0) {
        playSound("metronome_high");
      } else {
        playSound("metronome_low");
      }
    }
    tracks.forEach((track) => track.playAtBeat(bloc, beat));
  }

  void toggleMetronome() {
    _metronomeStatus.add(!_metronomeStatus.value);
  }
}

class TimelineBloc extends HookBloc {
  final Signal<bool> _isPlaying = HookBloc.disposeSink(Signal(false));
  final Signal<double> _bpm = HookBloc.disposeSink(Signal(160.0 * 4.0));
  final Signal<int> _atBeat = HookBloc.disposeSink(Signal(-1));

  Wave<bool> isPlaying;
  Wave<double> bpm;
  Wave<int> atBeat;

  StreamSubscription<DateTime> _metronome;

  TimelineBloc(void Function(TimelineBloc, int) playAtBeat) {
    final __isPlaying = _isPlaying.wave.distinct().subscribe((play) {
      if (_metronome != null) {
        _metronome.cancel();
        _metronome = null;
      }
      if (play) {
        _increaseAtBeat();
        playAtBeat(this, _atBeat.value);
        final metronome = Metronome.epoch(
          Duration(
            microseconds: 1 ~/ (_bpm.value / Duration.microsecondsPerMinute),
          ),
        );
        _metronome = metronome.listen((data) {
          _increaseAtBeat();
          playAtBeat(this, _atBeat.value);
        });
      }
    });
    disposeLater(__isPlaying.cancel);

    isPlaying = _isPlaying.wave;
    bpm = _bpm.wave;
    atBeat = _atBeat.wave;
  }

  void togglePlayback() {
    _isPlaying.add(!_isPlaying.value);
  }

  void _increaseAtBeat() {
    _atBeat.add(atBeat.value + 1);
    if (_atBeat.value == 32) {
      _atBeat.add(0);
    }
  }

  void stop() {
    _isPlaying.add(false);
    _atBeat.add(-1);
  }

  void setBeat(int i) {
    _atBeat.add(i);
  }
}

class TrackBloc extends HookBloc implements Playable {
  Signal<List<bool>> _isEnabled;
  Wave<List<bool>> isEnabled;

  final SoundSelector sound;

  TrackBloc(int initWith, this.sound) {
    _isEnabled = Signal(List.generate(initWith, (a) => false));
    disposeSinkLater(_isEnabled);
    isEnabled = _isEnabled.wave;
  }

  void toggle(int index) {
    final cur = _isEnabled.value;
    if (cur.length > index) {
      cur[index] = !cur[index];
      _isEnabled.add(cur);
    }
  }

  @override
  void playAtBeat(TimelineBloc bloc, int beat) {
    if (_isEnabled.value.length > beat) {
      final play = _isEnabled.value[beat];
      if (play) {
        sound.play();
      }
    }
  }

  void playPreview() {
    sound.play();
  }

  void setPattern(TrackPattern pattern) {
    _isEnabled.add(_isEnabled.value
        .asMap()
        .keys
        .map(pattern.builder)
        .toList());
  }
}

class SoundSelector {
  final String name;
  final void Function() play;

  const SoundSelector(this.name, this.play);
}