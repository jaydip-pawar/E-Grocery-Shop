import 'package:e_grocery/providers/authentication_provider.dart';
import 'package:e_grocery/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authentication = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            authentication.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
