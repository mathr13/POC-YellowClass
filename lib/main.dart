import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poc_yellowclass/constants.dart';
import 'package:poc_yellowclass/onboarding.dart';
import 'package:poc_yellowclass/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FutureBuilder(
          future: initialise(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if(snapshot.data == "null" || snapshot.data == "")
              return SignInPage();
            else
              return Onboarding(
                emailId: snapshot.data,
              );
          },
        )
      ),
    );
  }
}

Future<String> initialise() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String mailId = preferences.get(USER);
  var firebase = await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: "1:273840511872:ios:ebdc27c108cd63ab923f65",
      apiKey: "AIzaSyCY_D35-Q9-gTeBhSHrKl86WdjyUpjbkJM",
      projectId: "yellow-af317",
      messagingSenderId: "273840511872",
    )
  );
  return mailId.toString();
}
