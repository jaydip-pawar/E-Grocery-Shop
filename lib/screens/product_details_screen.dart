import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/widgets/products/bottom_sheet_container.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final DocumentSnapshot document;
  ProductDetailsScreen({this.document});

  @override
  Widget build(BuildContext context) {
    var offer = ((document.get('comparedPrice') - document.get('price')) /
            document.get('comparedPrice')) *
        100;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(CupertinoIcons.search), onPressed: () {
          }),
        ],
      ),
      bottomSheet: BottomSheetContainer(document),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.3),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 2, top: 2),
                    child: Text(document.get('brand')),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              document.get('productName'),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              document.get('weight'),
              style: TextStyle(fontSize: 20),
            ),
            Row(
              children: [
                Text(
                  '₹${document.get('price').toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                if (offer > 0)
                  Text(
                    '₹${document.get('comparedPrice')}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (offer > 0)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 3),
                      child: Text(
                        "${offer.toStringAsFixed(0)}% OFF",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.network(
                document.get('productImage'),
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 6,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'About this product',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Divider(color: Colors.grey[400]),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              child: ExpandableText(
                document.get('description'),
                expandText: 'View more',
                collapseText: 'View less',
                maxLines: 2,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Divider(color: Colors.grey[400]),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'Other product info',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Divider(color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKU :  ${document.get('sku')}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Seller :  ${document.get('seller')['shopName']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60,)
          ],
        ),
      ),
    );
  }

  Future<void> saveForLater() {
    CollectionReference _favourite = FirebaseFirestore.instance.collection('favourites');
    User user = FirebaseAuth.instance.currentUser;
    return _favourite.add({
      'product': document.data(),
      'customerId': user.uid,
    });
  }

}
