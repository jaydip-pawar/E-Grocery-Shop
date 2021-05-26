import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/model/store_services.dart';
import 'package:e_grocery/providers/store_provider.dart';
import 'package:e_grocery/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TopPickStore extends StatefulWidget {

  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    StoreServices _storeServices = StoreServices();
    _storeData.getUserLocationData();

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(
        _storeData.userLatitude,
        _storeData.userLongitude,
        location.latitude,
        location.longitude,
      );
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: SizedBox(
                height: 30, width: 30, child: CircularProgressIndicator()));
          List shopDistance = [];
          for (int i = 0; i <= snapshot.data.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
              _storeData.userLatitude,
              _storeData.userLongitude,
              snapshot.data.docs[i]['location'].latitude,
              snapshot.data.docs[i]['location'].longitude,
            );
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if (shopDistance[0] > 10) {
            return Container();
          }
          return Container(
            height: 210,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 30,
                            child: Image.asset("assets/images/like.gif")),
                        Text(
                          "Top Picked Stores For You",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.docs.map((
                          DocumentSnapshot document) {
                        if (double.parse(getDistance(document['location'])) <=
                            10) {
                          return InkWell(
                            onTap: () {
                              _storeData.getSelectedStore(document, getDistance(document['location']));
                              pushNewScreen(
                                context,
                                screen: VendorHomeScreen(),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation
                                    .cupertino,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Card(
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(4),
                                          child: Image.network(
                                            document['profile_pic'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      child: Text(
                                        document['shop_name'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "${getDistance(document['location'])}km",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}