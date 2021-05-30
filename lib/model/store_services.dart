import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {

  CollectionReference vendorBanner = FirebaseFirestore.instance.collection('vendorBanner');
  CollectionReference vendors = FirebaseFirestore.instance.collection('shop_owner');

  getTopPickedStore() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shop_name')
        .snapshots();
  }

  getNearByStore() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .orderBy('shop_name')
        .snapshots();
  }

  getNearByStorePagination() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .orderBy('shop_name');
  }

  Future<DocumentSnapshot> getShopDetails(sellerUid) async {
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}
