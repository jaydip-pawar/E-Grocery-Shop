import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/screens/complete_profile.dart';
import 'package:e_grocery/screens/home_page.dart';
import 'package:e_grocery/screens/login_screen.dart';
import 'package:e_grocery/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({Key key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {

  FirebaseAuth _auth;
  User _user;
  String _uid;

  getValues() async {
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    if (_user != null)
      setState(() {
        _uid = _user.uid;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getValues();
  }

  @override
  Widget build(BuildContext context) {
    getValues();
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (userSnapshot.hasData) {
          _uid = FirebaseAuth.instance.currentUser.uid;
          return FutureBuilder(
            future: Future.wait([FirebaseFirestore.instance.collection("customer").doc(_uid).get()]),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot doc = snapshot.data[0];
                if (doc.exists) {
                  if(doc.data().length > 1) {
                    if (doc["profile_pic"] != null && doc["user_name"] != null) {
                      return MainScreen();
                    }
                  }
                }
                return CompleteProfile();
              }
              return Center(child: CircularProgressIndicator(),);
            },
          );
        }
        return LoginPage();
      },
    );
  }
}
