import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rashd/Dashboard/dashboard.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import '../Registration/register.dart';

class accessSharedDashboard extends StatefulWidget {
  const accessSharedDashboard({Key? key}) : super(key: key);

  @override
  satisfies createState() => satisfies();
}

class satisfies extends State<accessSharedDashboard> {
  final _formKey = GlobalKey<FormState>();
  bool invalidCode = false;
  TextEditingController codeController = TextEditingController();
  String codeErrorMessage = '';
  bool inProgress = false;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 17.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        /*inProgress*/ false
            ? Center(child: CircularProgressIndicator())
            : SizedBox(),
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: inProgress && false ? 0.2 : 1,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(children: [
                Expanded(
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height * 0.22,
                            width: width * 0.75,
                            child: Stack(children: [
                              Positioned(
                                bottom: height * 0,
                                top: height * -0.22,
                                left: width * 0.08,
                                child: Container(
                                  width: width * 0.8,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(colors: [
                                        Colors.lightBlue.shade200,
                                        Colors.blue
                                      ]),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.blue.shade100,
                                            offset: const Offset(4.0, 4.0),
                                            blurRadius: 10.0)
                                      ]),
                                ),
                              ),
                              Positioned(
                                top: height * 0.08,
                                right: width * 0.00,
                                bottom: 0,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          color: Colors.white,
                                          Icons.arrow_back_ios,
                                        ),
                                        onPressed: () {
                                          clearForm();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      const Text(
                                        "لوحة المعلومات\n المشتركة",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.0,
                                            fontWeight:
                                                FontWeight.w800), // Textstyle
                                      ),
                                    ]),
                              ),
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.05),
                            child: Opacity(
                              opacity: 0.8,
                              child: (Image.asset(
                                'assets/images/logo.jpg',
                                height: height * 0.09,
                                width: width * 0.2,
                              )),
                            ),
                          ),
                        ]),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 0,
                            left: width * 0.08,
                            right: width * 0.08,
                            bottom: 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.03),

                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "مرحبًا،\nأدخل الرمز الذي تلقيته للوصول إلى لوحة المعلومات المشتركة",
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(height: height * 0.045),

                              TextFormField(
                                controller: codeController,
                                decoration: const InputDecoration(
                                  labelText: 'رمز لوحة المعلومات',
                                  suffixIcon: Icon(
                                    Icons.key,
                                    color: Color.fromRGBO(53, 152, 219, 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      (value.trim()).isEmpty) {
                                    return 'الرجاء إدخال رمز لوحة المعلومات.';
                                  } else if (invalidCode) {
                                    return codeErrorMessage;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.05),

                              //button
                              Container(
                                  width: width * 0.5,
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
                                        Color(0xFF42A5F5),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        inProgress = true;
                                      });
                                      await isCodeValid();

                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          inProgress = false;
                                        });

                                        // Fluttertoast.showToast(
                                        //     msg: "مرحبا بك في رشد",
                                        //     toastLength: Toast.LENGTH_SHORT,
                                        //     gravity: ToastGravity
                                        //         .BOTTOM, // Also possible "TOP" and "CENTER"
                                        //     backgroundColor: Colors.blue,
                                        //     textColor: Colors.white);

                                        var sharedDashboard =
                                            await FirebaseFirestore.instance
                                                .collectionGroup('sharedCode')
                                                .where('code',
                                                    isEqualTo: int.parse(
                                                        codeController.text))
                                                .where('isExpired',
                                                    isEqualTo: false)
                                                .get();

                                        await FirebaseFirestore.instance
                                            .collectionGroup('sharedCode')
                                            .where('code',
                                                isEqualTo: int.parse(
                                                    codeController.text))
                                            .where('isExpired',
                                                isEqualTo: false)
                                            .get();

                                        FirebaseFirestore.instance
                                            .collection('dashboard')
                                            .doc(sharedDashboard.docs[0]
                                                .data()["dashID"])
                                            .collection('sharedCode')
                                            .doc(sharedDashboard.docs[0].id)
                                            .update({'isExpired': true});

                                        clearForm();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => dashboard(
                                                ID: sharedDashboard.docs[0]
                                                    .data()['dashID'],
                                                isShared: true,
                                              ),
                                            ));
                                      }
                                    },
                                    child: const Text('التالي'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  )),
                              SizedBox(height: height * 0.02),

                              Center(
                                  child: RichText(
                                text: TextSpan(
                                  style: defaultStyle,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'هل ترغب في الانضمام إلى رشد؟ ',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    TextSpan(
                                        text: 'تسجيل جديد',
                                        style: linkStyle,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            clearForm();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const register(),
                                                ));
                                          }),
                                  ],
                                ),
                              )),
                            ]),
                      ),
                    )
                  ]),
                ),
              ])),
        ),
      ]),
    );
  }

  //this function checks if dashboard exists and not expired (not used before)
  //Returns true if code satisfies the above.
  Future<bool> isCodeValid() async {
    QuerySnapshot codeExistQuery = await FirebaseFirestore.instance
        .collectionGroup('sharedCode')
        .where('code',
            isEqualTo: int.parse(codeController
                .text)) //parse the input string value to int and it will work correctly, then change the status of isExpired
        .get();

    if (codeExistQuery.docs.isNotEmpty) {
      print('NOT EMPTY');
      QuerySnapshot codeExpiredQuery = await FirebaseFirestore.instance
          .collectionGroup('sharedCode')
          .where('code', isEqualTo: int.parse(codeController.text))
          .where('isExpired', isEqualTo: false)
          .get();
      if (codeExpiredQuery.docs.isNotEmpty) {
        invalidCode = false;
      } else {
        invalidCode = true;
        codeErrorMessage = 'رمز لوحة المعلومات تم استخدامه بالفعل.';
      }
    } else {
      print('EMPTY');
      invalidCode = true;
      codeErrorMessage = 'رمز لوحة المعلومات غير صالح.';
    }

    return invalidCode;
  }

  void clearForm() {
    codeController.text = "";
    inProgress = false;
    codeErrorMessage = '';
  }
}
