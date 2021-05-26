import 'package:e_grocery/providers/store_provider.dart';
import 'package:e_grocery/widgets/products/product_filter_widget.dart';
import 'package:e_grocery/widgets/products/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(
                _storeProvider.selectedProductCategory,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black87,
              ),
              expandedHeight: 110,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 88),
                child: Container(
                  height: 56,
                  color: Colors.grey,
                  child: ProductFilterWidget(),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [

            ProductListWidget(),
          ],
        ),
      ),
    );
  }
}
