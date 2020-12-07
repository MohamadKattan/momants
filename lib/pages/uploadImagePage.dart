import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  // this is file image after pick
  File sampleImage;
  // for textformfiald
  final formkey = GlobalKey<FormState>();
  // for on saved textformfiald
  String _myValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text('Select an Image') : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

//this widget for show Image in page + TextFormDaild
  Widget enableUpload() {
    return Container(
      child: Form(
          key: formkey,
          child: ListView(
            children: [
              Image.file(
                sampleImage,
                height: 330.0,
                width: 660.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Decoration'),
                validator: (value) {
                  return value.isEmpty ? 'Decoration is required' : null;
                },
                onSaved: (value) {
                  return _myValue = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: validateAndSave,
                  elevation: 10.0,
                  textColor: Colors.white,
                  color: Colors.amber,
                  child: Text(
                    'New Post',
                  ),
                ),
              ),
            ],
          )),
    );
  }

//tjis method for pick Image from camera or gallery
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

//  this method for save Image in firebase
  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
