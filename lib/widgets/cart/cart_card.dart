import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/widgets/cart/counter.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot document;
  CartCard({this.document});

  @override
  Widget build(BuildContext context) {
    double saving = document.get('comparedPrice') - document.get('price');
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300])),
        color: Colors.white,
      ),
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
                      document.get('productImage'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.get('productName')),
                      Text(
                        document.get('weight'),
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (document.get('comparedPrice') > 0)
                        Text(
                          document.get('comparedPrice').toString(),
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                      Text(
                        document.get('price').toStringAsFixed(0),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: CounterForCard(document),
            ),
            if(saving > 0)
            Positioned(
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '₹ ${saving.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'SAVED',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
