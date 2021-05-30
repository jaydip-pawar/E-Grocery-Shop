import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/widgets/cart/counter.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot document;
  CartCard({this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      document.data()['productImage'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.data()['productName']),
                      Text(
                        document.data()['weight'],
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (document.data()['comparedPrice'] > 0)
                        Text(
                          document.data()['comparedPrice'].toString(),
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                      Text(
                        document.data()['price'].toStringAsFixed(0),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            // Positioned(child: CounterForCard(document))
          ],
        ),
      ),
    );
  }
}
// 45-> 23.00