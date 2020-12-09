import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:momants/modle/posts.dart';
import 'package:momants/pages/uploadImagePage.dart';
import 'package:momants/service/authentication.dart';

class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  HomePage({this.auth, this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postsList = [];
  @override
  void initState() {
    super.initState();
    //this method for auto pickup data and show  in home page
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child('posts');
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      postsList.clear();
      for (var individualKey in KEYS) {
        Posts posts = Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['Descr'],
          DATA[individualKey]['time'],
          DATA[individualKey]['date'],
        );
        postsList.add(posts);
      }
      setState(() {
        print('Length :$postsList.length');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Moments',style: TextStyle(color: Colors.white),)),
      body: Container(
          child: postsList.length == 0
              ? noFoundImage()
              : ListView.builder(itemCount: postsList.length,
              itemBuilder: (_,index){
                return postUI(
                    postsList[index].image,
                    postsList[index]. Descr,
                    postsList[index]. time,
                    postsList[index]. date);
              })),
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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UploadImagePage();
                    }));
                  }),
            ],
          ),
        ),
      ),
    );
  }

// this method for signout from app
  void _logOutUser() async {
    try {
      await widget.auth.SignOut();
      widget.onSignedOut();
    } catch (e) {}
  }
// No found post yet
  noFoundImage() {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).accentColor.withOpacity(0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_photo_alternate,
              color: Colors.grey,
              size: 200.0,
            ),
            Text('No post yet'),
          ],
        ));
  }

  // this widget for UI  view posts in page app
  Widget postUI(String  time, date,Descr,image) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image(
              image: NetworkImage(image),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              Descr,
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
