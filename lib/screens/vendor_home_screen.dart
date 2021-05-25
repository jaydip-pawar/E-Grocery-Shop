import 'package:e_grocery/widgets/categories_widget.dart';
import 'package:e_grocery/widgets/products/featured_products.dart';
import 'package:e_grocery/widgets/vendor_appbar.dart';
import 'package:e_grocery/widgets/vendor_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            VendorBanner(),
            VendorCategories(),
            FeaturedProducts(),
          ],
        )
      ),
    );
  }
}
