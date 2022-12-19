import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'accessSharedDashboard.dart';
// import 'houseDevicesList.dart';
import 'Registration/login.dart';
import 'Registration/register.dart';

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
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        // padding: const EdgeInsets.all(0),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: height * 0.1),

            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 200,
                  width: 200,
                )),
            // Image.network(
            //     'file:///Users/Leena/Desktop/hackathon/hackathon/assets/images/logo.jpg'),
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => accsessShared(),
                        //     ));
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
    );
  }
}
