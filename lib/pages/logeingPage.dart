import 'package:flutter/material.dart';
import 'package:momants/service/authentication.dart';
import 'package:momants/service/dialogBox.dart';

class LogingPage extends StatefulWidget {
//this argment from mapping page came for control in Auth
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  LogingPage({this.auth, this.onSignedIn});
  @override
  _LogingPageState createState() => _LogingPageState();
}

// this tools for switch buttom to register or loging
enum FormType { login, register }

class _LogingPageState extends State<LogingPage> {
  // this opject for dailoho box
  DialogBox dialogBox = DialogBox();
  final _globalKey = GlobalKey<ScaffoldState>();
  //this for textforfail
  final formKey = GlobalKey<FormState>();
  //connect with enum FormType for switch
  FormType _formType = FormType.login;
  String _email = "";
  String _password = '';
// this method for save value whats we will type in textFormFaild
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

//connect with enum FormType for switch
  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

//connect with enum FormType for switch
  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

// this method for Auth with firebaseAuth
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.SignIn(_email.trim(), _password.trim());
          print('login userId=' + userId);
        } else {
          String userId =
              await widget.auth.SignUp(_email.trim(), _password.trim());
          print('Register userId=' + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.info(
            context, 'Error : ', 'some thing went wrong =' + e.toString());
        print('Error' + e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moments'),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createInput() + createButtons(),
              )
            ],
          ),
        ),
      ),
    );
  }

  //this widget for logo app
  Widget logo() {
    return Hero(
      tag: 'Hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110,
        child: Image.asset('images/log1.jpg'),
      ),
    );
  }

// this widget inclod TextFormFaild
  List<Widget> createInput() {
    return [
      SizedBox(
        height: 10.0,
      ),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? "Email is required" : null;
        },
        onSaved: (value) {
          return _email = value.trim();
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? "Password is required" : null;
        },
        onSaved: (value) {
          return _password = value.trim();
        },
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  // this widget for buttom regstir oe login
  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
            child: Text(
              'Login',
              style: TextStyle(fontSize: 20.0),
            ),
            textColor: Colors.white,
            color: Colors.amber,
            onPressed: validateAndSubmit),
        SizedBox(
          height: 10.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: TextStyle(fontSize: 14.0),
            ),
            FlatButton(
                child: Text(
                  'SignUp',
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.amber,
                onPressed: moveToRegister),
          ],
        ),
      ];
    } else {
      return [
        RaisedButton(
            child: Text(
              'Create Account',
              style: TextStyle(fontSize: 20.0),
            ),
            textColor: Colors.white,
            color: Colors.amber,
            onPressed: validateAndSubmit),
        SizedBox(
          height: 10.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already I have an account :',
              style: TextStyle(fontSize: 16.0),
            ),
            FlatButton(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.amber,
                onPressed: moveToLogin),
          ],
        ),
      ];
    }
  }
}
