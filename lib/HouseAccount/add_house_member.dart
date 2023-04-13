import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rashd/Dashboard/dashboard.dart';
import 'package:rashd/functions.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Devices/listOfDevices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'list_of_houseAccounts.dart';

class add_house_member extends StatefulWidget {
  final ID;
  const add_house_member({super.key, required this.ID});
  @override
  add_house_memberState createState() => add_house_memberState();
}

class add_house_memberState extends State<add_house_member> {
  TextEditingController houseName = TextEditingController();
  TextEditingController membersPhoneNumber1 = TextEditingController();
  TextEditingController membersNames1 = TextEditingController();
  ScrollController list = ScrollController();
  String privilege_edit = 'viewer', privilege = '', ErorrMes = 'العضو :';
  var privilege_index = 1;

  final _formKey = GlobalKey<FormState>();
  void clearText() {
    membersPhoneNumber1.clear();
    membersNames1.clear();
    privilege_edit = 'viewer';
    privilege = '';
    privilege_index = 1;
  }

  @override
  void initState() {
    setState(() {
      clearText();
      privilege_index = 1;
      privilege_edit = 'viewer';
      privilege = 'viewer';
    });
    super.initState();
  }

  Future<Map<String, dynamic>> readHouseData(var id) =>
      FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
        (DocumentSnapshot doc) {
          return doc.data() as Map<String, dynamic>;
        },
      );

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    // final _formKey = GlobalKey<FormState>();
    return FutureBuilder<Map<String, dynamic>>(
        future: readHouseData(widget.ID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var houseData = snapshot.data as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: height * 0.085,
                title: Wrap(
                    direction: Axis.vertical,
                    spacing: 1, // to apply margin in the main axis of the wrap
                    children: <Widget>[
                      SizedBox(height: height * 0.01),
                      // Text(
                      //   houseData['houseName'],
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 25,
                      //     height: 1,
                      //   ),
                      // ),
                      // Text(
                      //   houseData['OwnerID'] ==
                      //           FirebaseAuth.instance.currentUser!.uid
                      //       ? 'مالك المنزل'
                      //       : "عضو في المنزل",
                      //   style: TextStyle(
                      //     color: Colors.grey.shade900,
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 16,
                      //     height: 1,
                      //   ),
                      // )
                    ]),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListOfHouseAccounts(),
                        ));
                  },
                ),
                elevation: 1.5,
              ),
              body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: list,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'إضافة أعضاء للمنزل',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: TextFormField(
                            controller: membersNames1,
                            textAlign: TextAlign.right,
                            maxLength: 20,

                            decoration: InputDecoration(
                              hintText: 'الاسم',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'رجاء ادخل اسم العضو ';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.001,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: TextFormField(
                            controller: membersPhoneNumber1,
                            maxLength: 10,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: 'رقم الهاتف',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '  رجاء ادخل رقم هاتف';
                              }
                              if (value.length < 10) {
                                return '  رجاء ادخل رقم هاتف صحيح';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.001,
                        ),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: ToggleSwitch(
                            minWidth: width * 0.8,
                            minHeight: 50.0,
                            borderWidth: 1,
                            borderColor: const [
                              Colors.lightBlue,
                              Colors.lightBlue,
                            ],
                            customTextStyles: const [
                              TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              )
                            ],
                            initialLabelIndex: privilege_index,
                            cornerRadius: 100.0,
                            activeFgColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            inactiveBgColor: Colors.white,
                            inactiveFgColor: Colors.black,
                            totalSwitches: 2,
                            labels: const ['محرر', 'مشاهد'],
                            activeBgColors: const [
                              [Colors.lightBlue],
                              [Colors.lightBlue]
                            ],
                            onToggle: (index) {
                              if (index == 0) {
                                privilege_index = 0;
                                privilege_edit = 'editor';
                                setState(() {
                                  privilege = 'editor';
                                });
                                print('switched to: editor');
                                print(privilege);
                              } else {
                                privilege_index = 1;
                                privilege_edit = 'viewer';
                                setState(() {
                                  privilege = 'viewer';
                                });
                                print('switched to: viewer');
                                print(privilege);
                              }
                            },
                          ),
                        )),
                        const SizedBox(
                          height: 10,
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
                              onPressed: () async {
                                bool flag = true;
                                if (!_formKey.currentState!.validate()) {
                                } else {
                                  if (await exixts(membersPhoneNumber1.text) ==
                                      false) {
                                    flag = false;
                                  }
                                  if (flag) {
                                    setData();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text(
                                              '  تم الاضافة بنجاح',
                                              textAlign: TextAlign.center,
                                            ),
                                            backgroundColor: Colors.green));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                              "العضو غير موجود بالنظام ",
                                              textAlign: TextAlign.center,
                                            ),
                                            backgroundColor: Colors.redAccent));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('إضافة'),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )),
              bottomNavigationBar: buildBottomNavigation(height),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> setData() async {
    CollectionReference houses =
        FirebaseFirestore.instance.collection('houseAccount');

    houses.doc(widget.ID).collection('houseMember').add({
      "memberID": FirebaseAuth.instance.currentUser!.uid,
      'memberPhoneNumber': membersPhoneNumber1.text,
      'nickName': membersNames1.text,
      'privilege': privilege,
    });

    setState(() {
      clearText();
    });
  }

  int index = 2;
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
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboard(
                      houseID: widget.ID,
                    )),
          );
        }
        //need to get userType
        else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListOfDevices(
                      houseID: widget.ID,
                      userType: 'owner',
                    )),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => add_house_member(ID: widget.ID)),
          );
        }
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            icon: const Icon(Icons.bar_chart_rounded),
            title: const Text(
              'لوحة المعلومات',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
        BottomNavyBarItem(
          icon: const Icon(Icons.electrical_services_rounded),
          title: const Text(
            'الأجهزة',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.people_alt_rounded),
          title: const Text(
            'اعضاء المنزل',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

Future<bool> exixts(String number) async {
  bool invalidPhone = false;
  QuerySnapshot query = await FirebaseFirestore.instance
      .collection('userAccount')
      .where('phone_number', isEqualTo: number)
      .get();
  if (query.docs.isNotEmpty) {
    invalidPhone = true;
  } else {
    invalidPhone = false;
  }

  return invalidPhone;
}
