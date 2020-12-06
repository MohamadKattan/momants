
import 'package:flutter/material.dart';

class DialogBox {
  info(BuildContext context, String title, String desc) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text(desc)],
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}
