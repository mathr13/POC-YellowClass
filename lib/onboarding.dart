import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_yellowclass/cameraInterface.dart';
import 'package:poc_yellowclass/constants.dart';
import 'package:poc_yellowclass/signin.dart';
import 'package:poc_yellowclass/uicomponents.dart';
import 'package:poc_yellowclass/videoPlayerPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

class Onboarding extends StatelessWidget {
  final String emailId;

  Onboarding({this.emailId});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            showGeneralDialog(
              barrierDismissible: false,
              barrierLabel: "",
              barrierColor: Colors.black38,
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (ctx, anim1, anim2) => getLogoutPopup(context),
              transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                child: FadeTransition(
                  child: child,
                  opacity: anim1,
                ),
              ),
              context: context,
            );
          },
          child: Icon(Icons.exit_to_app),
        ),
        title: Text(
          "YELLOW CLASS",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Hello " + emailId,
                style: TextStyle(color: Colors.lightGreen, fontSize: 32),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Click on the video to watch",
                  style: TextStyle(color: Colors.green, fontSize: 24),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: getThumbnail(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return Stack(
                  children: [
                    Opacity(
                      opacity: 0.85,
                      child: Image.memory(
                        snapshot.data,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 125),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 50,
                            color: Colors.black,
                          )
                        )
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        double height = MediaQuery.of(context).size.height;
                        double width = MediaQuery.of(context).size.width;
                        cameras = await availableCameras();
                        var abcd = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerPage(
                              screenHeight: width,
                              screenWidth: height,
                            ),
                          )
                        );
                        if (abcd != null)
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                          ]);
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> getThumbnail() async {
    final uint8List = await thumbnail.VideoThumbnail.thumbnailData(
      video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      imageFormat: thumbnail.ImageFormat.PNG,
      quality: 25,
    );
    return uint8List;
  }

  Widget getLogoutPopup(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Opacity(
                  opacity: 0.75,
                  child: Text(
                    SIGNOUTCONFIRMATION,
                    style: genericTextDecoration(colour: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 33,
                      width: 100,
                      decoration: genericButtonDecoration(radius: 12, colour: Colors.white),
                      child: Center(
                        child: Text(
                          NO,
                          style: genericTextDecoration(fontSize: 14, colour: Colors.lightGreen),
                        )
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      if(preferences.get(USER) != null && preferences.get(USER) != "") {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => SignInPage()), (route) => false);
                        preferences.remove(USER);
                      }else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 33,
                      width: 100,
                      decoration: genericButtonDecoration(radius: 12, colour: Colors.white),
                      child: Center(
                        child: Text(
                          YES,
                          style: genericTextDecoration(fontSize: 14, colour: Colors.lightGreen),
                        )
                      ),
                    )
                  ),
                ],
              )
            ],
          ),
          margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
