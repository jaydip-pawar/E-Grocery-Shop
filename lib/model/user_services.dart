import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {

  final _fireStore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await _fireStore.collection('customer').doc(id).get();
    return result;
  }

}