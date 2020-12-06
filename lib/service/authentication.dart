import 'package:firebase_auth/firebase_auth.dart';



abstract class AuthImplementation
{
  Future<String> SignIn(String email,String password);
  Future<String> SignUp(String email,String password);
  Future<String> getCurrentUser();
  Future<void> SignOut();
}

class Auth implements AuthImplementation
{
  User user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  Future<String> SignIn(String email,String password)async
  {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return userCredential.user.uid;
  }
  Future<String> SignUp(String email,String password)async
  {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    return userCredential.user.uid;
  }
  Future<String> getCurrentUser()async
  {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<void> SignOut()async
  {
    _firebaseAuth.signOut();
  }
}