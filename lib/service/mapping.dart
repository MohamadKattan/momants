import 'package:flutter/material.dart';
import 'package:momants/pages/HomePage.dart';
import 'package:momants/pages/logeingPage.dart';
import 'package:momants/service/authentication.dart';

class MappingPage extends StatefulWidget {
  // this argment came from abstract class AuthImplementation
  final AuthImplementation auth;
  MappingPage({this.auth});
  @override
  _MappingPageState createState() => _MappingPageState();
}

// THIS TOOLS FOR START control  go to home page or login page
enum AuthStatus { notSignIn, signedIn }

class _MappingPageState extends State<MappingPage> {
// THIS TOOLS FOR START control  go to home page or login page
  AuthStatus authStatus = AuthStatus.notSignIn;
  @override
  void initState() {
    super.initState();
    // for chech AUTO ABOUT authStatus
    widget.auth.getCurrentUser().then((fireBaseUserId) {
      setState(() {
        authStatus =
            fireBaseUserId == null ? AuthStatus.notSignIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut() {
    setState(() {
      authStatus = AuthStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignIn:
        return LogingPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSignedOut: _signOut,
        );
    }
  }
}
