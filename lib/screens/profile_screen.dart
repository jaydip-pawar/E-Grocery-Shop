import 'package:e_grocery/providers/authentication_provider.dart';
import 'package:e_grocery/providers/location_provider.dart';
import 'package:e_grocery/screens/home_screen.dart';
import 'package:e_grocery/screens/login_screen.dart';
import 'package:e_grocery/screens/map_screen.dart';
import 'package:e_grocery/screens/profile_update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authentication = Provider.of<AuthenticationProvider>(context);
    final location = Provider.of<LocationProvider>(context);
    User user = FirebaseAuth.instance.currentUser;
    authentication.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        centerTitle: true,
        title: Text('Grocery Store'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "MY ACCOUNT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                "J",
                                style: TextStyle(
                                    fontSize: 50, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    authentication.snapshot == null
                                        ? "Set name first"
                                        : authentication.snapshot
                                                        .data()['firstName'] ==
                                                    null &&
                                                authentication.snapshot
                                                        .data()['lastName'] ==
                                                    null
                                            ? "Set name first"
                                            : '${authentication.snapshot.data()['firstName']} ${authentication.snapshot.data()['lastName']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    authentication.snapshot == null
                                        ? "Set email first"
                                        : authentication.snapshot
                                                    .data()['email'] ==
                                                null
                                            ? "Set email first"
                                            : authentication.snapshot
                                                .data()['email'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    authentication.snapshot == null
                                        ? "Set number first"
                                        : authentication.snapshot
                                                    .data()['mobile'] ==
                                                null
                                            ? "Set number first"
                                            : authentication.snapshot
                                                .data()['mobile'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (authentication.snapshot != null)
                          ListTile(
                            tileColor: Colors.white,
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                            ),
                            title: Text(authentication.snapshot
                                .data()['street_address']),
                            subtitle: Text(
                              authentication.snapshot.data()['address'],
                              maxLines: 1,
                            ),
                            trailing: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.redAccent),
                              ),
                              child: Text(
                                "Change",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onPressed: () {
                                location.getCurrentPosition().then((value) {
                                  EasyLoading.show(status: 'Please wait...');
                                  if (value != null) {
                                    EasyLoading.dismiss();
                                    pushNewScreen(
                                      context,
                                      screen: MapScreen(),
                                      withNavBar: false,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  } else {
                                    EasyLoading.dismiss();
                                    print("Permission not allowed");
                                  }
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: UpdateProfile(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('My Orders'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.comment_outlined),
              title: Text('My Ratings & Reviews'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Notifications'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
              horizontalTitleGap: 2,
              onTap: () {
                authentication.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
