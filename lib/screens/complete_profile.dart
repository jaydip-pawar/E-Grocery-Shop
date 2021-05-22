import 'dart:io';

import 'package:e_grocery/preferences/utility.dart';
import 'package:e_grocery/providers/authentication_provider.dart';
import 'package:e_grocery/screens/home_page.dart';
import 'package:e_grocery/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  AuthenticationProvider authentication;
  final TextEditingController _userNameController = TextEditingController();
  PickedFile _imageFile;
  String _downloadLink;
  final ImagePicker _picker = ImagePicker();

  showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: ((_) => bottomSheet()),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    authentication = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.grey,
        elevation: 1,
        title: Text("Complete Your Profile"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profilePic(),
            SizedBox(height: 40),
            nameField(),
            SizedBox(height: 25),
            submitButton(),
            SizedBox(height: 25),
            logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                label: Text(
                  "Camera",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                label: Text(
                  "Gallery",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget profilePic() {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () => showBottomSheet(),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                backgroundImage: _imageFile == null
                    ? AssetImage("assets/images/google.png")
                    : FileImage(File(_imageFile.path)),
                backgroundColor: Colors.white,
                radius: 39,
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: 0,
            child: SizedBox(
              height: 35,
              width: 35,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () => showBottomSheet(),
                child: SvgPicture.asset("assets/icons/camera_icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget nameField() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _userNameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(left: 20, top: 18, bottom: 18, right: 20),
          hintText: "Full Name",
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget logoutButton() {
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white70,
          shadowColor: Colors.grey,
        ),
        onPressed: () {
          authentication.signOut();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
        },
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  Widget submitButton() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 50,
      width: double.infinity,
      child: MaterialButton(
        onPressed: () {
          Utility.saveImageToPreferences(Utility.base64String(File(_imageFile.path).readAsBytesSync()));
          authentication.uploadProfilePic(_imageFile, _userNameController.text);
          authentication.savePrefs(_userNameController.text);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
        },
        padding: EdgeInsets.all(0),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffff5f6d),
                Color(0xffff5f6d),
                Color(0xffffc371),
              ],
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints:
                BoxConstraints(maxWidth: double.infinity, minHeight: 50),
            child: Text(
              "Submit",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
