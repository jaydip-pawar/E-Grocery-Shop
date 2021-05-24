import 'package:e_grocery/providers/store_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorAppBar extends StatelessWidget {
  const VendorAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);

    return SliverAppBar(
      floating: true,
      snap: true,
      expandedHeight: 280,
      flexibleSpace: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 86),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_store.storedetails['profile_pic']),
                    )),
                child: Container(
                  color: Colors.grey.withOpacity(.7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Text(
                          _store.storedetails['dialog'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          _store.storedetails['address'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _store.storedetails['email'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Distance : km",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.search),
        ),
      ],
      title: Text(
        _store.storedetails['shop_name'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
