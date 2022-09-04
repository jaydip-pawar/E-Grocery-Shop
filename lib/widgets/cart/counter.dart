import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/model/cart_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;

  CounterForCard(this.document);

  @override
  _CounterForCardState createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User user = FirebaseAuth.instance.currentUser;
  CartServices _cart = CartServices();

  int _qty = 1;
  bool _exists = false;
  String _docId;
  bool _updating = false;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document.get('productId'))
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc['productId'] == widget.document.get('productId')) {
                  setState(() {
                    _exists = true;
                    _qty = doc["qty"];
                    _docId = doc.id;
                  });
                }
              }),
            });

    return _exists
        ? Container(
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.pink,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                    });
                    if (_qty == 1) {
                      _cart.removeFromCart(_docId).then((value) {
                        setState(() {
                          _updating = false;
                          _exists = false;
                        });
                        _cart.checkData();
                      });
                    }
                    if (_qty > 1) {
                      setState(() {
                        _qty--;
                      });
                      var total = _qty * widget.document.get('price');
                      _cart.updateCartQty(_docId, _qty, total).then((value) {
                        setState(() {
                          _updating = false;
                        });
                      });
                    }
                  },
                  child: Container(
                    child: Icon(
                      _qty == 1 ? Icons.delete_outline : Icons.remove,
                      color: Colors.pink,
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: 30,
                  color: Colors.pink,
                  child: Center(
                    child: FittedBox(
                      child: _updating
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _qty.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                      _qty++;
                    });
                    var total = _qty * widget.document.get('price');
                    _cart.updateCartQty(_docId, _qty, total).then((value) {
                      setState(() {
                        _updating = false;
                      });
                    });
                  },
                  child: Container(
                    child: Icon(
                      Icons.add,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              EasyLoading.show(status: 'Adding to Cart');
              _cart.checkSeller().then((shopName) {
                if (shopName == widget.document.get('seller')['shopName']) {
                  setState(() {
                    _exists = true;
                  });
                  _cart.addToCart(widget.document).then((value) {
                    EasyLoading.showSuccess('Added to Cart');
                  });
                  return;
                } else {
                  EasyLoading.dismiss();
                  // showDialog(shopName);
                }
                if (shopName == null) {
                  setState(() {
                    _exists = true;
                  });
                  _cart.addToCart(widget.document).then((value) {
                    EasyLoading.showSuccess('Added to Cart');
                  });
                  return;
                }
                if (shopName != widget.document.get('seller')['shopName']) {
                  EasyLoading.dismiss();
                  showDialog(shopName);
                }
              });
            },
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          );
  }

  showDialog(shopName) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Replace Cart Item?'),
          content: Text(
              'Your cart contains items from $shopName. Do you want to discard the selection and add items from ${widget.document.get('seller')['shopName']}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _cart.deleteCart().then((value) {
                  _cart.addToCart(widget.document).then((value) {
                    setState(() {
                      _exists = true;
                    });
                  });
                });
              },
              child: Text(
                'Yes',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }
}
