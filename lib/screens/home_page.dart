import 'package:e_grocery/widgets/near_by_store.dart';
import 'package:e_grocery/widgets/top_pick_store.dart';
import 'package:e_grocery/widgets/image_slider.dart';
import 'package:e_grocery/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MyAppBar()
          ];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: [
            ImageSlider(),
            Container(
              color: Colors.white,
              child: TopPickStore(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: NearByStore(),
            ),
          ],
        ),
      ),
    );
  }
}