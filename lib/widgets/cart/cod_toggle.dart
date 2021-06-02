import 'package:e_grocery/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_bar/toggle_bar.dart';

class CodToggleSwitch extends StatelessWidget {
  const CodToggleSwitch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _cart = Provider.of<CartProvider>(context);
    return Container(
      color: Colors.white,
      child: ToggleBar(
        backgroundColor: Colors.grey[300],
          textColor: Colors.grey[600],
          selectedTabColor: Theme.of(context).primaryColor,
          labels: ["Pay online", "Cash on delivery"],
          labelTextStyle: TextStyle(fontSize: 12),
          onSelectionUpdated: (index) {
          _cart.getPaymentMethod(index);
          }
      ),
    );
  }
}
