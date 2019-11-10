
class TrackPattern {
  final String name;
  final bool Function(int) builder;

  const TrackPattern(this.name, this.builder);
}

List<TrackPattern> allPatterns() =>
    [
      TrackPattern("Reset", (i) => false),
      TrackPattern("All", (i) => true),
      TrackPattern("Every 2 beat", (i) => i % 2 == 0),
      TrackPattern("Every 4 beat", (i) => i % 4 == 0),
      TrackPattern("Every 8 beat", (i) => i % 8 == 0),
      TrackPattern("Every 16 beat", (i) => i % 16 == 0),
      TrackPattern("Fast Clap", (i) => i % 4 == 0 && i % 8 != 0),
      TrackPattern("Slow Clap", (i) => i % 8 == 0 && i % 16 != 0),
    ];