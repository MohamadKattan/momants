import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momants/pages/HomePage.dart';

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
  //this for url StorageFirebase
  String url;

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
                padding: EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: UploadStatusImage,
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

//this method for upload Image to storage
  void UploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child('postImage');

      // this time key it will be random key = post ID
      var timeKey = DateTime.now();
      final StorageUploadTask task =
          postImageRef.child(timeKey.toString() + '.jpg').putFile(sampleImage);
      var imageUrl = await (await task.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      print('imageUr=' + url);
      goToHomePage();
      saveToDatbase(url);
    }
  }

//this method for save data in database
  void saveToDatbase(String url) {
    // this time key it will be random key = post ID
    var dbtimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d,yyyy');
    var formatTime = DateFormat('EEEE, hh:mm');
    //this for put time+date with random key for every id post
    String date = formatDate.format(dbtimeKey);
    String time = formatTime.format(dbtimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {'image': url, 'Descr': _myValue, 'time': time, 'date': date};
    ref.child('posts').push().set(data);
  }

// this method for puch to home page
  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }
}
