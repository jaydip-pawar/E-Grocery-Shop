import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/model/product_services.dart';
import 'package:e_grocery/providers/store_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {
  const VendorCategories({Key key}) : super(key: key);

  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {

  ProductServices _services = ProductServices();

  List _catList = [];
  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
    .collection('products').where('seller.sellerUid', isEqualTo: _store.storedetails['uid'])
    .get()
    .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _catList.add(doc['category']['mainCategory']);
        });
      })
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          return Center(child: Text('Something went wrong..'));
        }
        if(_catList.length == 0) {
          return Center(child: CircularProgressIndicator());
        }
        if(!snapshot.hasData) {
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/background.png')
                      )
                    ),
                    child: Center(
                      child: Text("Shop by Category", style: TextStyle(
                        shadows: <Shadow> [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black
                          )
                        ],
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                      ),),
                    ),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return _catList.contains(document.data()['name']) ?
                      Container(
                        width: 120,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: .5
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.network(document.data()['image']),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Text(document.data()['name'], textAlign: TextAlign.center,),
                              )
                            ],
                          ),
                        ),
                      ) : Text('');
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
