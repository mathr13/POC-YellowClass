import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_yellowclass/constants.dart';
import 'package:poc_yellowclass/externalAlerts.dart';
import 'package:poc_yellowclass/onboarding.dart';
import 'package:poc_yellowclass/uicomponents.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("YELLOW CLASS"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              autheticate(context);
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.green
              ),
              child: Center(
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(width: 2, color: parseColor("535465")),
              ),
              child: TextField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                  hintText: "Username",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20)
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(width: 2, color: parseColor("535465")),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  contentPadding: EdgeInsets.symmetric(horizontal: 20)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void autheticate(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(parseColor(TEXTCOLOUR)),
        ),
      )
    );
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )).user;
      Navigator.pop(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(USER, user.email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Onboarding(
            emailId: user.email,
          )
        ),
      );
      _emailController.clear();
      _passwordController.clear();
    } catch (error) {
      Navigator.pop(context);
      if (error.code.toString() == "invalid-email")
        EdgeAlert.show(
          context,
          gravity: EdgeAlert.TOP,
          description: INVALIDMAILADDRESS,
          backgroundColor: parseColor(DELETECOLOUR)
        );
      else if (error.code.toString() == "user-not-found")
        EdgeAlert.show(
          context,
          gravity: EdgeAlert.TOP,
          description: "No Such User Exist",
          backgroundColor: parseColor(DELETECOLOUR)
        );
      else if (error.code.toString() == "wrong-password")
        EdgeAlert.show(
          context,
          gravity: EdgeAlert.TOP,
          description: INVALIDPASSWORDADDRESS,
          backgroundColor: parseColor(DELETECOLOUR)
        );
      else
        EdgeAlert.show(
          context,
          gravity: EdgeAlert.TOP,
          description: SOMETHINGWENTWRONG,
          backgroundColor: parseColor(DELETECOLOUR)
        );
    }
  }
}
