import 'dart:io';

import 'package:e_grocery/model/dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot snapshot;

  void login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                  title: 'Sign in',
                  description:
                      'Sorry, we cant\'t find an account with this email address. Please try again or create a new account.',
                  bText: 'Try again',
                ));
      } else if (e.code == 'wrong-password') {
        return showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                  title: 'Incorrect Password',
                  description: 'Your username or password is incorrect.',
                  bText: 'Try again',
                ));
      }
    }
  }

  void signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                  title: 'Email address already in use',
                  description: 'Please sign in.',
                  bText: 'OK',
                ));
      }
    } catch (e) {
      print(e);
    }
  }

  void signInWithGoogle() async {
    DocumentSnapshot _data;
    User _user;

    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _user = userCredential.user;
      final uid = _user.uid;
      _data = await FirebaseFirestore.instance
          .collection("customer")
          .doc(uid)
          .get();
    } catch (e) {
      print(e);
    }
  }

  void addLocation(double latitude, double longitude, String address, String streetAddress) {
    firestoreInstance.collection("customer").doc(firebaseUser.uid).update({
      "location": GeoPoint(latitude, longitude),
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "street_address": streetAddress,
    }).then((_) {
      print("successfully added location!");
    });
  }

  void addProfileData(String userName, String imageUrl) {
    firestoreInstance.collection("customer").doc(firebaseUser.uid).set({
      "user_name": userName,
      "profile_pic": imageUrl,
    }).then((_) {
      print("successfully added profile data!");
    });
  }

  String uploadProfilePic(PickedFile imageFile, String userName) {
    String _basePath = Path.basename(imageFile.path);
    FirebaseStorage _firebaseStorageRef = FirebaseStorage.instance;
    Reference _reference =
        _firebaseStorageRef.ref().child('Profile/$_basePath');
    UploadTask _uploadTask = _reference.putFile(File(imageFile.path));
    _uploadTask.whenComplete(() async {
      String _downloadLink = await _reference.getDownloadURL();
      addProfileData(userName, _downloadLink);
      print("url Set completed......");
    });
    return "";
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
    await GoogleSignIn().signOut();
  }

  Future<void> savePrefs(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_name", name);
  }

  Future<DocumentSnapshot> getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance.collection('customer').doc(firebaseUser.uid).get();
    this.snapshot = result;
    notifyListeners();

    return result;
  }
}
