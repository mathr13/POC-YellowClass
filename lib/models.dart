import 'dart:async';

import 'package:flutter/material.dart';

class BlocStatusManagement {
  StreamController volumeStreamController =
      StreamController<double>.broadcast();
  StreamController playbackStreamController =
      StreamController<VideoStatus>.broadcast();
  StreamController alignemntStreamController =
      StreamController<AlignmentGeometry>.broadcast();

  Sink get volumeIncrementerSink => volumeStreamController.sink;
  Sink get playbackIncrementerSink => playbackStreamController.sink;
  Sink get alignmentSink => alignemntStreamController.sink;

  Stream<double> get volumeStream => volumeStreamController.stream;
  Stream<VideoStatus> get playbackStream => playbackStreamController.stream;
  Stream<AlignmentGeometry> get alignmentStream =>
      alignemntStreamController.stream;

  updateVolume(double number) {
    volumeIncrementerSink.add(number);
  }

  updatePlayback(VideoStatus status) {
    playbackIncrementerSink.add(status);
  }

  updateCameraAignmentStatus(AlignmentGeometry alignment) {
    alignmentSink.add(alignment);
  }

  void dispose() {
    volumeStreamController.close();
    playbackStreamController.close();
    alignemntStreamController.close();
  }
}

enum VideoStatus { playing, paused }
