import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beat_sequencer/pages/main_bloc.dart';
import 'package:flutter_beat_sequencer/pages/pattern.dart';
import 'package:flutter_beat_sequencer/platform_services.dart';
import 'package:flutter_beat_sequencer/widgets/title.dart';

class MainPage extends StatelessWidget {
  final BeatSequencerPlatformServices platformServices;

  const MainPage(this.platformServices);

  @override
  Widget build(BuildContext context) {
    return $$ >> (context) {
      final bloc = $$$(() => PlaybackBloc(platformServices.playSound));
      final timelineBloc = $$$(() => TimelineBloc(bloc.playAtBeat));

      return scaffold(color: Colors.brown[800])
      & center()
      & singleChildScrollView()
      & singleChildScrollViewH()
          > onColumnMinCenterCenter()
              >> [
                ...
                _itemClr * modulovalueTitle(
                  title: "Flutter Beat Sequencer",
                  repo: "flutter_beat_sequencer",
                  openURL: platformServices.openURL,
                ),
                verticalSpace(12.0),
                $$ >> (context) {
                  final bpm = $(() => timelineBloc.bpm) / 4.0;
                  final playing = $(() => timelineBloc.isPlaying);
                  final metronomeStatus = $(() => bloc.metronomeStatus);
                  return _itemClr > onRowMinCenterCenter() >> [
                    Text("BPM: $bpm"),
                    horizontalSpace(8.0),
                    flatButton(timelineBloc.togglePlayback)
                    & _itemClr
                        > Icon(playing ? Icons.pause : Icons.play_arrow),
                    flatButton(timelineBloc.stop)
                    & _itemClr
                        > Icon(Icons.stop),
                    flatButton(bloc.toggleMetronome)
                        > (metronomeStatus
                           ? _itemClr > const Text("Metronome On")
                           : _itemClr > const Text("Metronome Off")),
                  ];
                },
                _beatIndicator(timelineBloc),
                _sequencerStyle
                    > onColumnMinStartCenter()
                    >> bloc.tracks.map(_track),
              ];
    };
  }
}

Applicator _itemClr = textColor(Colors.white) & iconProperties(
    color: Colors.white);

Applicator _sequencerStyle = padding(horizontal: 16.0)
& card(color: Colors.brown[900])
& padding(horizontal: 18.0, vertical: 18.0);

Widget _beatIndicator(TimelineBloc bloc) {
  return $$ >> (context) {
    final beat = $(() => bloc.atBeat);
    return height(14.0) > onRowMin() >> [
      width(50) > nothing,
      horizontalSpace(8.0),
      width(50) > nothing,
      horizontalSpace(8.0),
      ...List.generate(32, (i) {
        return onTap(() => bloc.setBeat(i - 1))
        & padding(horizontal: 4.0)
            > Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: i == beat ? Colors.white :
                       Colors.white.withOpacity(0.05),
              ),
              width: 28.0,
            );
      }),
    ];
  };
}

Widget _track(TrackBloc bloc) {
  return $$ >> (context) {
    final enabled = $(() => bloc.isEnabled);
    return height(42.0) > onRowMin() >> [

      onTap(bloc.sound.play)
      & width(50)
      & _itemClr
          > Text(bloc.sound.name),
      horizontalSpace(8.0),
      width(50.0) & iconButton(() {
        showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(bloc.sound.name),
                content: singleChildScrollView() > onColumnMinStartCenter() >> [
                  ...allPatterns().map((pattern) {
                    return ListTile(
                      title: Text(pattern.name),
                      onTap: () {
                        bloc.setPattern(pattern);
                        Navigator.of(context).pop();
                      },
                    );
                  }),
                ],
              );
            }
        );
      }) & _itemClr > Icon(Icons.more_horiz),
      horizontalSpace(8.0),
      ...enabled
          .asMap()
          .entries
          .map((a) {
        return TrackStep(
          beat: a.key,
          selected: a.value,
          onPressed: () => bloc.toggle(a.key),
        );
      })
    ];
  };
}

class TrackStep extends StatelessWidget {
  final bool selected;
  final int beat;
  final void Function() onPressed;

  const TrackStep({
    @required this.beat,
    @required this.selected,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return onTap(onPressed)
    & padding(horizontal: 2.0)
        > Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: selected ? Colors.white :
                   (beat % 4 == 0 ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.07)),
            borderRadius: BorderRadius.circular(24.0),
          ),
        );
  }
}