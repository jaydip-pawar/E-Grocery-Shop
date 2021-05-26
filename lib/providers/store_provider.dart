import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/model/store_services.dart';
import 'package:e_grocery/model/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class StoreProvider with ChangeNotifier {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;
  String selectedStore, selectedStoreId;
  DocumentSnapshot storedetails;
  String distance;
  String selectedProductCategory;
  String selectedSubCategory;

  getSelectedStore(storeDetails, distance) {
    this.storedetails = storeDetails;
    this.distance = distance;
    notifyListeners();
  }

  selectedCategory(category) {
    this.selectedProductCategory = category;
    notifyListeners();
  }

  selectedCategorySub(subCategory) {
    this.selectedSubCategory = subCategory;
    notifyListeners();
  }

  Future<void> getUserLocationData() async {
    _userServices.getUserById(user.uid).then((result) {
      if (user != null) {
        this.userLatitude = result.data()['latitude'];
        this.userLongitude = result.data()['longitude'];
        notifyListeners();
      } else {
        print("User not authenticated...");
      }
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

}