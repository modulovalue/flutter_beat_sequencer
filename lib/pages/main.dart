import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beat_sequencer/pages/main_bloc.dart';
import 'package:modulovalue_project_widgets/all.dart';
import 'package:flutter_beat_sequencer/pages/pattern.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return $$ >> (context) {
      final bloc = $$$(() => PlaybackBloc());
      final timelineBloc = $$$(() => TimelineBloc(bloc.playAtBeat));

      return scaffold()
      & center()
      & padding(all: 12.0)
      & singleChildScrollViewH()
          > onColumnMinCenterCenter()
              >> [
                ...modulovalueTitle("Flutter Beat Sequencer", "flutter_beat_sequencer"),
                verticalSpace(12.0),
                $$ >> (context) {
                  final bpm = $(() => timelineBloc.bpm) / 4.0;
                  final playing = $(() => timelineBloc.isPlaying);
                  final metronomeStatus = $(() => bloc.metronomeStatus);
                  return onRowMinCenterCenter() >> [
                    Text("BPM: $bpm"),
                    horizontalSpace(8.0),
                    flatButton(timelineBloc.togglePlayback)
                        > Icon(playing ? Icons.pause : Icons.play_arrow),
                    flatButton(timelineBloc.stop)
                        > Icon(Icons.stop),
                    flatButton(bloc.toggleMetronome)
                        > (metronomeStatus
                           ? Text("Metronome On")
                           : Text("Metronome Off")),
                  ];
                },
                _beatIndicator(timelineBloc),
                onColumnMinStartCenter() >> bloc.tracks.map((line) {
                  return _track(line);
                }),
              ];
    };
  }
}

Widget _beatIndicator(TimelineBloc bloc) {
  return $$ >> (context) {
    final beat = $(() => bloc.atBeat);
    return height(8.0) > onRowMin() >> [
      width(80) > nothing,
      horizontalSpace(8.0),
      width(50) > nothing,
      horizontalSpace(8.0),
      ...List.generate(32, (i) {
        return onTap(() => bloc.setBeat(i)) & padding(
            horizontal: 2.0) > Container(
          width: 32.0,
          color: (i) == beat ? Colors.green : Colors.grey[300],
        );
      }),
    ];
  };
}

Widget _track(TrackBloc bloc) {
  return $$ >> (context) {
    final enabled = $(() => bloc.isEnabled);
    return height(42.0) > onRowMin() >> [
      width(80)
          > RaisedButton(
        color: Colors.white,
        child: Text(bloc.sound.name),
        onPressed: null,
      ),
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
      }) > Icon(Icons.more_horiz),
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
            color: selected ? Colors.grey[900] :
                   ((beat % 4 == 0 ? Colors.grey[300]
                     : Colors.grey[200])),
            borderRadius: BorderRadius.circular(24.0),
          ),
        );
  }
}