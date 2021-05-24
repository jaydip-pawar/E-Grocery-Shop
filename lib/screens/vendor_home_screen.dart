import 'package:e_grocery/providers/store_provider.dart';
import 'package:e_grocery/widgets/my_appbar.dart';
import 'package:e_grocery/widgets/vendor_appbar.dart';
import 'package:e_grocery/widgets/vendor_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: Column(
          children: [
            VendorBanner(),
          ],
        )
      ),
    );
  }
}
