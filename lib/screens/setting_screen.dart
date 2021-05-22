import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 5,
          title: Text("E-Grocery Partner"),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Settings())),
            ),
          ],
        ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.134,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.130,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/images/google.png"),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: 0,
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: MaterialButton(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: Color(0xFFF5F6F9),
                          onPressed: () => showBottomSheet(),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
