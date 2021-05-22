import 'package:flutter/cupertino.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {

  double latitude;
  double longitude;
  Address addresses;
  bool permissionAllowed = false;
  var address, streetAddress;
  GeoCode geoCode = GeoCode();
  bool loading = false;

  Future<void> getCurrentPosition() async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {

      this.latitude = position.latitude;
      this.longitude = position.longitude;

      try {
        final addresses = await geoCode.reverseGeocoding(latitude: this.latitude, longitude: this.longitude);
        this.address = "${addresses.streetAddress}, ${addresses.city}, ${addresses.region}, ${addresses.countryName} ${addresses.postal}";
        this.streetAddress = addresses.streetAddress;
        this.permissionAllowed = true;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    } else {
      print("Permission not allowed");
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    try {
      addresses = await geoCode.reverseGeocoding(latitude: this.latitude, longitude: this.longitude);
      this.address = "${addresses.streetAddress}, ${addresses.city}, ${addresses.region}, ${addresses.countryName} ${addresses.postal}";
      this.streetAddress = addresses.streetAddress;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("latitude", this.latitude);
    prefs.setDouble("longitude", this.longitude);
    prefs.setString("address", this.address);
    prefs.setString("location", "${this.streetAddress}");
  }
}