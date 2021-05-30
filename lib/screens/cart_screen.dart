import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/model/store_services.dart';
import 'package:e_grocery/providers/cart_provider.dart';
import 'package:e_grocery/providers/store_provider.dart';
import 'package:e_grocery/widgets/cart/cart_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final DocumentSnapshot document;
  CartScreen({this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices _store = StoreServices();
  DocumentSnapshot doc;

  @override
  void initState() {
    _store.getShopDetails(widget.document.data()['sellerUid']).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      bottomSheet: Container(
        height: 60,
        color: Colors.blueGrey[900],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹${_cartProvider.subTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(Including Taxes)',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 10),
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text(
                    'CHECKOUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBozIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document.data()['shopName'],
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        '${_cartProvider.cartQty} ${_cartProvider.cartQty > 1 ? 'Items, ' : 'Item, '}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'To Pay : ₹ ${_cartProvider.subTotal.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ];
        },
        body: Container(
          child: Column(
            children: [
              if (doc != null)
                ListTile(
                  leading: Container(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        doc.data()['profile_pic'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(doc.data()['shop_name']),
                  subtitle: Text(
                    doc.data()['address'],
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              CartList(document: widget.document,),
            ],
          ),
        ),
      ),
    );
  }
}
