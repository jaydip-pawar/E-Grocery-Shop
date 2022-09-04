import 'package:e_grocery/model/cart_services.dart';
import 'package:e_grocery/services/payment/stripe_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ExistingCardsPage extends StatefulWidget {
  ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Prajyot',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '4000056655665556',
      'expiryDate': '04/23',
      'cardHolderName': 'Tushar',
      'cvvCode': '123',
      'showBackView': false,
    },
    {
      'cardNumber': '52008282828282',
      'expiryDate': '04/23',
      'cardHolderName': 'New Card',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  payViaExistingCard(BuildContext context, card) async {
    await EasyLoading.show(status: 'Please wait...');
    CreditCardModel stripeCard = CreditCardModel(
      card['cardNumber'],
      "${card['expiryDate']}",
      "cardHolderName",
      "XXX",
      false,
    );
    // var response = await StripeService.payViaExistingCard(
    //     amount: '2500', currency: 'INR', card: stripeCard);
    // await EasyLoading.dismiss();
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(
    //       content: Text(response.message),
    //       duration: new Duration(milliseconds: 1200),
    //     ))
    //     .closed
    //     .then((_) async {
    //   EasyLoading.show(status: "Please wait...");
    //   var cartServices = CartServices();
    //   cartServices.deleteCart().whenComplete(() {
    //     EasyLoading.showSuccess("Your Order arrive within 2 hours.");
    //     Navigator.pop(context);
    //     Navigator.pop(context);
    //     Navigator.pop(context);
    //     // Navigator.pop(context);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            var card = cards[index];
            return InkWell(
              onTap: () {
                payViaExistingCard(context, card);
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
                onCreditCardWidgetChange: (CreditCardBrand ) {  },
              ),
            );
          },
        ),
      ),
    );
  }
}
