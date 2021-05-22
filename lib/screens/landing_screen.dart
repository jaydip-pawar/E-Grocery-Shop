import 'package:e_grocery/model/user_services.dart';
import 'package:e_grocery/providers/location_provider.dart';
import 'package:e_grocery/screens/home_page.dart';
import 'package:e_grocery/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  User user = FirebaseAuth.instance.currentUser;
  String _location;
  String _address;
  bool _loading = true;

  @override
  void initState() {
    UserServices _userServices = UserServices();
    _userServices.getUserById(user.uid).then((result) async {
      if (result != null) {
        if (result.data()['latitude'] != null) {
          getPrefs(result);
        } else {
          _locationProvider.getCurrentPosition();
          if (_locationProvider.permissionAllowed == true) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MapScreen()));
          } else {
            print("Permission not allowed");
          }
        }
      }
    });
    super.initState();
  }

  getPrefs(dbResult) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String location = preferences.getString('location');
    if (location == null) {
      preferences.setString('address', dbResult.data()['address']);
      preferences.setString('location', dbResult.data()['street_address']);
      if(mounted) {
        setState(() {
          _location = dbResult.data()['street_address'];
          _address = dbResult.data()['address'];
          _loading = false;
        });
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_location == null ? "" : _location),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _address == null ? "Delivery Address not set" : _address,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _address == null
                    ? "Please update your Delivery Location to find nearest stores for you"
                    : _address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            CircularProgressIndicator(),
            Container(
              width: 600,
              child: Image.asset(
                "assets/images/city.png",
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            Visibility(
              visible: _location != null ? true : false,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text("Confirm Your Location"),
              ),
            ),
            TextButton(
              onPressed: () {
                _locationProvider.getCurrentPosition();
                if (_locationProvider.addresses != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MapScreen()));
                } else {
                  print("Permission not allowed");
                }
              },
              child: Text(_location != null ? "Update Location" : "Set Your Location", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
