import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_grocery/model/store_services.dart';
import 'package:e_grocery/model/user_services.dart';
import 'package:e_grocery/providers/cart_provider.dart';
import 'package:e_grocery/providers/location_provider.dart';
import 'package:e_grocery/screens/map_screen.dart';
import 'package:e_grocery/screens/profile_screen.dart';
import 'package:e_grocery/widgets/cart/cart_list.dart';
import 'package:e_grocery/widgets/cart/cod_toggle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final DocumentSnapshot document;
  CartScreen({this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices _store = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot doc;
  var textStyle = TextStyle(color: Colors.grey);
  int discount = 50;
  int deliveryFee = 50;
  String _location = "";
  String _address = "";
  bool _loading = false;
  bool _checkingUser = false;

  @override
  void initState() {
    getPrefs();
    _store.getShopDetails(widget.document.data()['sellerUid']).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString("location");
    print(location);
    String address = prefs.getString("address");
    print(address);
    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    var _cartProvider = Provider.of<CartProvider>(context);
    var _payable = _cartProvider.subTotal + deliveryFee - discount;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      bottomSheet: Container(
        height: 140,
        color: Colors.blueGrey[900],
        child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Deliver to this address: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              _loading = true;
                            });
                            locationData.getCurrentPosition().then((value) {
                              setState(() {
                                _loading = false;
                              });
                              if (value != null)
                                pushNewScreen(
                                  context,
                                  screen: MapScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              else {
                                setState(() {
                                  _loading = false;
                                });
                                print("Permission not allowed");
                              }
                            });
                          },
                          child: _loading ? CircularProgressIndicator() : Text(
                            'Change',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    Text(
                      '$_location, $_address',
                      maxLines: 3,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Center(
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
                              color: Theme.of(context).primaryColor,
                              fontSize: 10),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      child: _checkingUser ? CircularProgressIndicator() : Text(
                        'CHECKOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _checkingUser = true;
                        });
                        _userServices.getUserById(user.uid).then((value) {
                          if(value.data()['userName']  == null) {
                            setState(() {
                              _checkingUser = false;
                            });
                            pushNewScreen(
                              context,
                              screen: ProfileScreen(),
                              pageTransitionAnimation: PageTransitionAnimation
                                  .cupertino,
                            );
                          } else {
                            setState(() {
                              _checkingUser = false;
                            });
                            if(_cartProvider.cod == true) {
                              print("Cash on delivery");
                            } else {
                              print("Will pay online");
                            }
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
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
        body: _cartProvider.cartQty > 0
            ? SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 80),
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      if (doc != null)
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
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
                              CodToggleSwitch(),
                              Divider(color: Colors.grey[300]),
                            ],
                          ),
                        ),
                      CartList(
                        document: widget.document,
                      ),

                      //coupon
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, right: 10, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 15, bottom: 10),
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      hintText: 'Enter Voucher Code',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey),
                                ),
                                onPressed: () {},
                                child: Text('Apply'),
                              )
                            ],
                          ),
                        ),
                      ),

                      //bill details card
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, top: 4, bottom: 80),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bill Details',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Basket value',
                                        style: textStyle,
                                      )),
                                      Text(
                                        '₹ ${_cartProvider.subTotal.toStringAsFixed(0)}',
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Discount',
                                        style: textStyle,
                                      )),
                                      Text(
                                        '₹ $discount',
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Delivery fee',
                                        style: textStyle,
                                      )),
                                      Text(
                                        '₹ $deliveryFee',
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Total amount payable',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Text(
                                        '₹ ${_payable.toStringAsFixed(0)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Total Saving',
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          )),
                                          Text(
                                            '₹ ${_cartProvider.saving.toStringAsFixed(0)}',
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Text('Cart Empty, Continue shopping'),
              ),
      ),
    );
  }
}
