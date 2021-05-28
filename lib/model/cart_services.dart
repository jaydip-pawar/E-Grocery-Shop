import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) {
    cart.doc(user.uid).set({
      'user': user.uid,
      'sellerUid': document.data()['seller']['sellerUid'],
    });

    return cart.doc(user.uid).collection('products').add({
      'productId': document.data()['productId'],
      'productName': document.data()['productName'],
      'weight': document.data()['weight'],
      'price': document.data()['price'],
      'comparedPrice': document.data()['comparedPrice'],
      'sku': document.data()['sku'],
      'qty': 1,
    });
  }

  Future<void> updateCartQty(docId, qty) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .doc(docId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Product does not exist in cart!");
          }

          transaction.update(documentReference, {'qty': qty});

          return qty;
        })
        .then((value) => print("Cart updated"))
        .catchError((error) => print("Failed to update cart: $error"));
  }

  Future<void> removeFromCart(docID) async {
    cart.doc(user.uid).collection('products').doc(docID).delete();
  }

  Future<void> checkData() async {
    final snapshot = await cart.doc(user.uid).collection('products').get();
    if(snapshot.docs.length == 0) {
      cart.doc(user.uid).delete();
    }
  }

}
