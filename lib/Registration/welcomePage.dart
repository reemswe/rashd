import 'package:flutter/material.dart';
import '../Dashboard/accessSharedDashboard.dart';
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(children: [
      Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: height * 0.1),

            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 200,
                  width: 200,
                )),
            SizedBox(height: height * 0.05),

            //button
            Padding(
                padding:
                    EdgeInsets.only(left: 45, right: 45, bottom: 10, top: 20),
                child: Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 1.0],
                        colors: [
                          Colors.blue.shade200,
                          Colors.blue.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                        style: TextStyle(fontSize: 25),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ))),
            SizedBox(height: height * 0.02),

            Padding(
                padding: EdgeInsets.only(left: 45, right: 45, bottom: 10),
                child: Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 1.0],
                        colors: [
                          Colors.blue.shade200,
                          Colors.blue.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => register(),
                            ));
                      },
                      child:
                          Text(' تسجيل جديد', style: TextStyle(fontSize: 25)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ))),
            SizedBox(height: height * 0.02),

            Padding(
                padding: EdgeInsets.only(left: 45, right: 45, bottom: 10),
                child: Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 1.0],
                        colors: [
                          Colors.blue.shade200,
                          Colors.blue.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => accessSharedDashboard(),
                            ));
                      },
                      child: Text('لوحة المنزل المشتركة',
                          style: TextStyle(fontSize: 25)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ))),
          ],
        ),
      ),
      Positioned(
        bottom: height * 0,
        top: height * -0.992,
        left: width * 0.59,
        child: Container(
          width: width * 0.8,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade200, Colors.blue]),
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.shade100,
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 10.0)
              ]),
        ),
      ),
      Positioned(
        bottom: height * 0,
        top: height * -0.992,
        left: width * 0.5,
        child: Opacity(
            opacity: 0.3,
            child: Container(
              width: width * 0.9,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFF81D4FA), Colors.blue]),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.shade100,
                        offset: const Offset(4.0, 4.0),
                        blurRadius: 10.0)
                  ]),
            )),
      ),
      Positioned(
        top: height * 0,
        bottom: height * -1.1,
        left: width * -0.3,
        child: Opacity(
            opacity: 0.3,
            child: Container(
              width: width * 0.9,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue.shade200, Colors.blue]),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.shade100,
                        offset: const Offset(4.0, 4.0),
                        blurRadius: 10.0)
                  ]),
            )),
      ),
    ]));
  }
}
