import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_yellowclass/cameraInterface.dart';
import 'package:poc_yellowclass/models.dart';
import 'package:video_player/video_player.dart';

int buildCounter = 0;

class VideoPlayerPage extends StatelessWidget {
  final BlocStatusManagement statusbloc = BlocStatusManagement();
  // final videoPlayerController = VideoPlayerController.asset("assets/jump.mov");
  final videoPlayerController = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
  final double screenHeight;
  final double screenWidth;
  VideoStatus videoPlayStatus = VideoStatus.playing;

  VideoPlayerPage({this.screenHeight, this.screenWidth});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
    ]);
    if (buildCounter == 0) videoPlayerController.setVolume(0);
    buildCounter++;
    return Scaffold(
      body: Chewie(
        controller: ChewieController(
          videoPlayerController: videoPlayerController,
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ],
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: true,
          showControls: true,
          overlay: StreamBuilder<AlignmentGeometry>(
            stream: statusbloc.alignmentStream,
            initialData: Alignment.bottomRight,
            builder: (context, snapshot) {
              return Container(
                height: screenHeight,
                alignment: snapshot.data,
                child: SafeArea(
                  child: LongPressDraggable(
                    childWhenDragging: SizedBox(),
                    feedback: RotatedBox(
                      quarterTurns: 4,
                      child: CameraScreen(),
                    ),
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: CameraScreen(),
                    ),
                    onDragEnd: (details) {
                      AlignmentGeometry alignment = getAlignmentFromOffset(details.offset.dx, details.offset.dy);
                      statusbloc.updateCameraAignmentStatus(alignment);
                    },
                  ),
                ),
              );
            }
          ),
          fullScreenByDefault: true,
          customControls: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    videoPlayerController.pause();
                  },
                  child: Container(
                    color: Colors.white,
                    height: 40,
                    width: 40,
                    child: Icon(Icons.close),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (videoPlayStatus == VideoStatus.paused) {
                          videoPlayerController.play();
                          videoPlayStatus = VideoStatus.playing;
                        } else {
                          videoPlayerController.pause();
                          videoPlayStatus = VideoStatus.paused;
                        }
                        statusbloc.updatePlayback(videoPlayStatus);
                      },
                      child: Container(
                        color: Colors.white,
                        height: 40,
                        width: 40,
                        child: StreamBuilder<VideoStatus>(
                          stream: statusbloc.playbackStream,
                          initialData: VideoStatus.playing,
                          builder: (context, snapshot) {
                            return getPlayAndPauseButton(snapshot.data);
                          }
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: StreamBuilder<double>(
                        stream: statusbloc.volumeStream,
                        initialData: 0,
                        builder: (context, snapshot) {
                          return CupertinoSlider(
                            value: snapshot.data,
                            max: 10,
                            min: 0,
                            onChangeEnd: (value) {
                              double newVolume = double.parse(value.toStringAsFixed(2));
                              statusbloc.updateVolume(newVolume);
                              videoPlayerController.setVolume(newVolume / 10);
                            },
                            onChanged: (double value) {},
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          errorBuilder: (context, errorMessage) => Center(child: Text(errorMessage)),
        ),
      ),
    );
  }

  Widget getPlayAndPauseButton(VideoStatus videoStatus) {
    Icon icon;
    if (videoStatus == VideoStatus.paused)
      icon = Icon(Icons.play_circle_outline);
    else if (videoStatus == VideoStatus.playing) icon = Icon(Icons.pause);
    return Container(
      color: Colors.white,
      height: 40,
      width: 40,
      child: icon,
    );
  }

  AlignmentGeometry getAlignmentFromOffset(double xcoord, double ycoord) {
    if ((xcoord <= screenWidth / 3) && (ycoord <= screenHeight / 2))
      return Alignment.topLeft;
    else if ((xcoord <= screenWidth / 3) && (ycoord > screenHeight / 2))
      return Alignment.bottomLeft;
    else if ((xcoord > screenWidth * 2 / 3) && (ycoord <= screenHeight / 2))
      return Alignment.topRight;
    else if ((xcoord > screenWidth * 2 / 3) && (ycoord > screenHeight / 2))
      return Alignment.bottomRight;
    return Alignment.bottomRight;
  }
}
