import 'dart:ffi' as ffi;
import 'dart:io' show Process;
import 'package:ffi/ffi.dart';

import 'package:flutter_beat_sequencer/platform_services.dart';

// Create a typedef with the FFI type signature of the C function.
// Commonly used types defined by dart:ffi library include Double, Int32, NativeFunction, Pointer, Struct, Uint8, and Void.
typedef play_once_func = ffi.Void Function(ffi.Pointer<Utf8>);

// Create a typedef for the variable that you’ll use when calling the C function.
typedef PlayOnce = void Function(ffi.Pointer<Utf8>);

class MacBeatSequencerServices extends BeatSequencerPlatformServices {
  @override
  void openURL(String str) {
    Process.run("open", [str]);
  }

  // https://itnext.io/how-to-call-a-rust-function-from-dart-using-ffi-f48f3ea3af2c
  @override
  void playSound(String soundID) {
    ffi.DynamicLibrary dylib = ffi.DynamicLibrary.open(
        "/Users/valauskasmodestas/Desktop/my github/Finished Projects/audio/flutter_beat_sequencer/code/assets/libplay_once.dylib");
    // Get a reference to the C function, and put it into a variable. This code uses the typedefs defined in steps 2 and 3, along with the dynamic library variable from step 4.
    final PlayOnce play_once = dylib
        .lookup<ffi.NativeFunction<play_once_func>>('play_once')
        .asFunction();
    // Convert a Dart [String] to a Utf8-encoded null-terminated C string.
    final ffi.Pointer<Utf8> song = Utf8.toUtf8("/Users/valauskasmodestas/Desktop/my github/Finished Projects/audio/flutter_beat_sequencer/code/assets/sounds/$soundID.wav")
        .cast();
    // Call the C function.
    play_once(song);
  }
}