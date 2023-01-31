import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';

import 'welcomePage.dart';

class profile extends StatefulWidget {
  const profile({super.key});
  @override
  profileState createState() => profileState();
}

String name_edit = '', phone_edit = '', DOB = '', DOB_edit = '', userName = '';
TextEditingController DOBController = new TextEditingController();
TextEditingController nameController = new TextEditingController();
TextEditingController EmailContrller = new TextEditingController();
TextEditingController phoneController = new TextEditingController();

bool Editing = false;
bool Viewing = true;
var isEdited;

class profileState extends State<profile> {
  var _formKey;
  late Map<String, dynamic> userData;

  @override
  initState() {
    super.initState();
    print("++++++++++++ initState! ++++++++++++");
    FirebaseFirestore.instance
        .collection("userAccount")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot value) {
      userData = value.data() as Map<String, dynamic>;

      print("userData: $userData");
      nameController.text = userData["full_name"];
      EmailContrller.text = userData["email"];
      phoneController.text = userData["phone_number"];
      DOBController.text = userData["DOB"];
      print("++++++++++++ Document! ++++++++++++");
    });
    print(nameController.text);
    print(phoneController.text);
    _formKey = GlobalKey<FormState>();
    isEdited = false;
  }

  editing(var value) {
    setState(() {
      isEdited = value;
    });
  }

  Future<Map<String, dynamic>> readUserData() => FirebaseFirestore.instance
          .collection("userAccount")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (DocumentSnapshot value) {
          userData = value.data() as Map<String, dynamic>;
          print(userData);
          return value.data() as Map<String, dynamic>;
        },
      );
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    var userData;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
          future: readUserData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              userData = snapshot.data as Map<String, dynamic>;
              return ListView(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height * 0.13,
                        width: width * 0.75,
                        child: Stack(children: [
                          Positioned(
                            bottom: height * 0,
                            top: height * -0.28,
                            left: width * 0.1,
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
                            top: height * 0.035,
                            right: width * 0.08,
                            bottom: 0,
                            child: const Text(
                              "حسابي",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w800), // Textstyle
                            ),
                          ),
                          // Positioned(
                          //   top: height * 0.01,
                          //   right: width * 0.6,
                          //   bottom: 0,
                          //   child: Opacity(
                          //     opacity: 0.8,
                          //     child: (Image.asset(
                          //       'assets/images/logo.jpg',
                          //       height: height * 0.08,
                          //       width: width * 0.2,
                          //     )),
                          //   ),
                          // ),
                        ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: width * 0.01),
                          child: RotatedBox(
                              quarterTurns: 2,
                              child: IconButton(
                                icon: const Icon(Icons.logout_outlined),
                                iconSize: 35,
                                color: Colors.lightBlue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                        " تسجيل خروج",
                                        // textAlign: TextAlign.center,
                                      ),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              "هل أنت متأكد أنك تريد تسحيل الخروج؟",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ]),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseMessaging.instance
                                                .deleteToken();
                                            Future.delayed(
                                                const Duration(seconds: 1),
                                                () async => await FirebaseAuth
                                                    .instance
                                                    .signOut());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const welcomePage()));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("خروج",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 194, 98, 98))),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("إلغاء"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ))),
                    ]),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person_pin,
                    color: Colors.lightBlue.shade300,
                    size: 130,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.04),

                          //email
                          TextFormField(
                            enabled: false,
                            textAlign: TextAlign.right,
                            controller: EmailContrller,
                            decoration: const InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 3),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                          Visibility(
                              visible: Editing,
                              child: SizedBox(height: height * 0.008)),
                          Visibility(
                              visible: Editing,
                              child: const Text(
                                  "لا يمكن تحرير عنوان البريد الإلكتروني ، لأنه يستخدم للتحقق من المستخدم.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal))),

                          //name field
                          SizedBox(
                              height: Editing ? height * 0.02 : height * 0.04),
                          TextFormField(
                            enabled: Editing,
                            textAlign: TextAlign.right,
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'الاسم الكامل',
                              alignLabelWithHint: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.lightBlue),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 3),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if ((value != null && value.length < 2) ||
                                  value == null ||
                                  value.isEmpty ||
                                  (value.trim()).isEmpty) {
                                return "ادخل اسم صحيح";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              if (nameController.text.trim() !=
                                  userData["full_name"]) {
                                editing(true);
                              } else {
                                editing(false);
                              }
                            },
                          ),

                          //DOB field
                          // SizedBox(height: height * 0.04),
                          // TextFormField(
                          //   enabled: Editing,
                          //   controller: DOBController,
                          //   readOnly: true,
                          //   onTap: () async {
                          //     DateTime? newDate = await showDatePicker(
                          //       context: context,
                          //       initialDate: DateTime.parse(DOBController.text),
                          //       firstDate: DateTime(1922),
                          //       lastDate: DateTime.now(),
                          //     );
                          //     if (newDate != null) {
                          //       setState(() {
                          //         DOBController.text =
                          //             DateFormat('yyyy-MM-dd').format(newDate);
                          //         print(newDate);
                          //         print('controller :' + DOBController.text);
                          //       });
                          //       if (DOBController.text != userData['DOB']) {
                          //         editing(true);
                          //       } else {
                          //         editing(false);
                          //       }
                          //     } else {
                          //       print("Date is not selected");
                          //     }
                          //   },
                          //   decoration: InputDecoration(
                          //     labelText: "تاريخ الميلاد",
                          //     enabledBorder: const UnderlineInputBorder(
                          //       borderSide: BorderSide(
                          //           width: 2, color: Colors.lightBlue),
                          //     ),
                          //     focusedBorder: const UnderlineInputBorder(
                          //       borderSide:
                          //           BorderSide(width: 2, color: Colors.blue),
                          //     ),
                          //     contentPadding: const EdgeInsets.only(bottom: 3),
                          //     hintText: DOBController.text,
                          //     hintStyle: const TextStyle(
                          //       fontSize: 18,
                          //       color: Colors.black,
                          //     ),
                          //     floatingLabelBehavior:
                          //         FloatingLabelBehavior.always,
                          //   ),
                          // ),

                          //phone number field
                          SizedBox(height: height * 0.04),
                          TextFormField(
                            enabled: Editing,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (phoneController.text.trim() !=
                                  userData["phone_number"]) {
                                editing(true);
                              } else {
                                editing(false);
                              }
                            },
                            maxLength: 10,
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: 'رقم الهاتف',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.lightBlue,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 3),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null) {
                                return "الرجاء ادخال رقم هاتف";
                              } else if (value.length != 10) {
                                return "الرجاء ادخال رقم هاتف صحيح";
                              }
                            },
                          ),

                          //Editing buttons :
                          SizedBox(height: height * 0.04),
                          Visibility(
                            visible: Viewing,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: width * 0.01,
                                ),
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
                                        Colors.blue.shade400,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        Editing = true;
                                        Viewing = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                            255, 253, 253, 253),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    child: const Text('تحرير'),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.015,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  iconSize: 55,
                                  color: Colors.red.shade600,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                          "هل أنت متأكد ؟",
                                          textAlign: TextAlign.center,
                                        ),
                                        content: const Text(
                                          "هل أنت متأكد من حدف حسابك ؟ لا يمكنك استرجاع الحساب بعد الحذف",
                                          // textAlign: TextAlign.end,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                              child: const Text(
                                                "إلغاء",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // FirebaseFirestore.instance
                                              //     .collection("users")
                                              //     .doc(userData['id'])
                                              //     .delete()
                                              //     .then((_) {
                                              //   print(
                                              //       "success!, user deleted");
                                              // });
                                              // Navigator.of(ctx).pop();
                                              print("success!, user deleted");
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("حذف",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromARGB(
                                                          255, 124, 18, 18))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                              ],
                              // )
                            )),
                          ), //Save and cancel buttons

                          Visibility(
                              visible: Editing,
                              child: Center(
                                  // padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                  child: Row(
                                children: [
                                  Container(
                                      width: width * 0.4,
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
                                            isEdited
                                                ? Colors.blue.shade200
                                                : Colors.grey,
                                            isEdited
                                                ? Colors.blue.shade400
                                                : Colors.grey,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (isEdited) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                    "حفظ التغييرات؟",
                                                  ),
                                                  content: const Text(
                                                    "هل أنت متأكد أنك تريد حفظ التغييرات؟",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "تم حفظ التغييرات بنجاح",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity: ToastGravity
                                                                .BOTTOM, // Also possible "TOP" and "CENTER"
                                                            backgroundColor:
                                                                Colors.green
                                                                    .shade400,
                                                            textColor:
                                                                Colors.white);

                                                        UpdateDB();
                                                        setState(() {
                                                          Editing = false;
                                                          Viewing = true;
                                                        });
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child: const Text(
                                                          "حفظ",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child: const Text(
                                                            "إلغاء",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        194,
                                                                        98,
                                                                        98))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text('حفظ'),
                                      )),
                                  SizedBox(width: width * 0.04),
                                  // Cancel changes
                                  Container(
                                      width: width * 0.4,
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
                                            Colors.blue.shade400
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (isEdited) {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                    "تجاهل التغييرات؟",
                                                  ),
                                                  content: const Text(
                                                    "هل أنت متأكد أنك تريد تجاهل التغييرات؟",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "userAccount")
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .get()
                                                              .then((value) {
                                                            nameController
                                                                .text = value
                                                                    .data()![
                                                                "full_name"];
                                                            EmailContrller
                                                                    .text =
                                                                value.data()![
                                                                    "email"];
                                                            phoneController
                                                                .text = value
                                                                    .data()![
                                                                "phone_number"];
                                                            DOBController.text =
                                                                value.data()![
                                                                    "DOB"];
                                                            print(
                                                                "++++++++++++ Cancel changes! ++++++++++++");
                                                          });
                                                          Editing = false;
                                                          Viewing = true;
                                                        });
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child: const Text("نعم",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        194,
                                                                        98,
                                                                        98))),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child: const Text("لا",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                Editing = false;
                                                Viewing = true;
                                              });
                                              editing(false);
                                            }
                                          },
                                          child: const Text('إلغاء'))),
                                ],
                              ))),
                        ],
                      )),
                ),
              ]);
            } else {
              return const Text('');
            }
          }),
      bottomNavigationBar: buildBottomNavigation(height),
    );
  }

  int index = 1;
  Widget buildBottomNavigation(height) {
    return BottomNavyBar(
      containerHeight: height * 0.07,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      selectedIndex: index,
      iconSize: 28,
      onItemSelected: (index) {
        setState(
          () => index = index,
        );
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const profile()),
          );
        } else if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListOfHouseAccounts()),
          );
        }
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            icon: const Icon(Icons.holiday_village_rounded),
            title: const Text(
              'منازلي',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
        BottomNavyBarItem(
          icon: const Icon(Icons.person_outline_rounded),
          title: const Text(
            'حسابي',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
      ],
    );
  }
}

Future<void> UpdateDB() async {
  print('will be added to db');
  var Edit_info = FirebaseFirestore.instance
      .collection('userAccount')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  Edit_info.update({
    'full_name': nameController.text,
    'phone_number': phoneController.text,
    'DOB': DOBController.text,
  });
  print('profile edited');
  isEdited = false;
}
