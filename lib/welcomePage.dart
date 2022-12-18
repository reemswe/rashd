import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'accessSharedDashboard.dart';
import 'houseDevicesList.dart';
import 'login.dart';
import 'register.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({super.key});

  @override
  State<welcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        // padding: const EdgeInsets.all(0),
        child: ListView(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 200,
                  width: 200,
                )),
            // Image.network(
            //     'file:///Users/Leena/Desktop/hackathon/hackathon/assets/images/logo.jpg'),
            //button
            Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                child: Container(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => login(),
                        ));
                  },
                  child: Text(
                    ' تسجيل الدخول',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ))),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Container(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => register(),
                        ));
                  },
                  child: Text(' تسجيل جديد', style: TextStyle(fontSize: 17)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ))),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Container(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => accsessShared(),
                        ));
                  },
                  child: Text('لوحة المنزل المشتركة',
                      style: TextStyle(fontSize: 17)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ))),
            // Padding(
            //     padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            //     child: Container(
            //         child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => devicesList(),
            //             ));
            //       },
            //       child: Text('قائمة الاجهزة', style: TextStyle(fontSize: 17)),
            //       style: ElevatedButton.styleFrom(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //       ),
            //     ))),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
