import 'package:flutter/material.dart';
import 'package:momants/service/authentication.dart';

class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  HomePage({this.auth, this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Moments')),
      body: Text('home page '),
      bottomNavigationBar: Container(
        color: Colors.amber,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.local_car_wash_outlined,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  onPressed: _logOutUser),
              IconButton(
                  icon: Icon(
                    Icons.camera,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  onPressed: null),
            ],
          ),
        ),
      ),
    );
  }
  void _logOutUser()async{
    try {
      await widget.auth.SignOut();
      widget.onSignedOut();
    }catch(e){

    }
  }
}
