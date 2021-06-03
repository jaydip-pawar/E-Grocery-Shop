import 'package:e_grocery/screens/payment/stripe/existing-cards.dart';
import 'package:e_grocery/services/payment/stripe_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class StripeHome extends StatefulWidget {
  StripeHome({Key key}) : super(key: key);

  @override
  StripeHomeState createState() => StripeHomeState();
}

class StripeHomeState extends State<StripeHome> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 1:
        payViaNewCard(context);
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ExistingCardsPage()));
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    await EasyLoading.show(status: 'Please wait...');
    var response =
        await StripeService.payWithNewCard(amount: '15000', currency: 'INR');
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/e-grocery-48b88.appspot.com/o/Razorpay%20Logo.png?alt=media&token=fc3454bf-7e51-4a30-9a42-c1ad957bc18e',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Material(
            elevation: 4,
            child: SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/e-grocery-48b88.appspot.com/o/PayPal%20Logo.png?alt=media&token=92305649-1603-46c6-bafd-d45ceeb06a5b',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Material(
            elevation: 4,
            child: SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/e-grocery-48b88.appspot.com/o/Stripe%20logo.png?alt=media&token=0619fd9c-7d2a-4dfe-ab14-f4d15ba99900',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Icon icon;
                  Text text;

                  switch (index) {
                    case 0:
                      icon = Icon(Icons.add_circle, color: theme.primaryColor);
                      text = Text('Add Cards');
                      break;
                    case 1:
                      icon = Icon(Icons.payment_outlined, color: theme.primaryColor);
                      text = Text('Pay via new card');
                      break;
                    case 2:
                      icon = Icon(Icons.credit_card, color: theme.primaryColor);
                      text = Text('Pay via existing card');
                      break;
                  }

                  return InkWell(
                    onTap: () {
                      onItemPress(context, index);
                    },
                    child: ListTile(
                      title: text,
                      leading: icon,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      color: theme.primaryColor,
                    ),
                itemCount: 3),
          ),
        ],
      ),
    );
  }
}
