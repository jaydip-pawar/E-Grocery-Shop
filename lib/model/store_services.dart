import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  getTopPickedStore() {
    return FirebaseFirestore.instance
        .collection("shop_owner")
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shop_name')
        .snapshots();
  }

  getNearByStore() {
    return FirebaseFirestore.instance
        .collection("shop_owner")
        .where('accVerified', isEqualTo: true)
        .orderBy('shop_name')
        .snapshots();
  }

  getNearByStorePagination() {
    return FirebaseFirestore.instance
        .collection("shop_owner")
        .where('accVerified', isEqualTo: true)
        .orderBy('shop_name');
  }
}
