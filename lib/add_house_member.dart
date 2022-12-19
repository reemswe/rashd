import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rashd/dashboard.dart';
import 'package:rashd/list_of_house_accounts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'Devices/listOfDevices.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;

//import 'share_Dash.dart';

class add_house_member extends StatefulWidget {
  final houseID;
  const add_house_member({super.key, required this.houseID});
  @override
  add_house_memberState createState() => add_house_memberState();
}

CollectionReference DisabilityType =
    FirebaseFirestore.instance.collection('UserDisabilityType');

TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
//TextEditingController privilegeController = TextEditingController();

String privilege_edit = 'مشاهد', privilege = '';
var privilege_index = 1;

void clearText() {
  nameController.clear();
  phoneController.clear();
  setState() {
    privilege_index = 1;
    privilege_edit = 'مشاهد';
    privilege = 'مشاهد';
  }
}

Future<Map<String, dynamic>> readHouseData(var id) =>
    FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
      (DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
      },
    );

class add_house_memberState extends State<add_house_member> {
  @override
  initState() {
    // ignore: avoid_print
    print("!! initState Called !!");
    privilege_index = 1;
    privilege_edit = 'مشاهد';
    privilege = 'مشاهد';
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final _formKey = GlobalKey<FormState>();
    return FutureBuilder<Map<String, dynamic>>(
        future: readHouseData(widget.houseID),
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
                      Text(
                        houseData['houseName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          height: 1,
                        ),
                      ),
                      Text(
                        houseData['OwnerID'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? 'مالك المنزل'
                            : "عضو في المنزل",
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1,
                        ),
                      )
                    ]),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                actions: [
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'share') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "مشاركة لوحة المعلومات",
                              textAlign: TextAlign.left,
                            ),
                            content: const Text(
                              'رجاء ادخل رقم جوال لمشاركة لوحة المعلومات',
                              textAlign: TextAlign.left,
                            ),
                            actions: <Widget>[
                              TextFormField(
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 13.0, horizontal: 15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: " رقم الهاتف",
                                ),
                                // The validator receives the text that the user has entered.
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
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("الغاء"),
                                ),
                              ),
                              //log in ok button
                              TextButton(
                                onPressed: () {
                                  // pop out
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("مشاركة",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 35, 129, 6))),
                                ),
                              ),
                            ],
                          ),
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Share()),
                        // );
                      }
                      if (value == 'delete') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "حذف المنزل",
                              textAlign: TextAlign.left,
                            ),
                            content: const Text(
                              "هل أنت متأكد من حذف حساب المنزل ؟",
                              textAlign: TextAlign.left,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("الغاء"),
                                ),
                              ),
                              //log in ok button
                              TextButton(
                                onPressed: () {
                                  // pop out
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("حذف",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 164, 10, 10))),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // your logic
                    },
                    itemBuilder: (BuildContext bc) {
                      return const [
                        PopupMenuItem(
                          value: 'share',
                          child: Text("مشاركة لوحة المعلومات "),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text("حذف حساب المنرل",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 167, 32, 32))),
                        ),
                      ];
                    },
                  ),
                ],
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
                            controller: nameController,
                            textAlign: TextAlign.right,
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
                                return '  رجاء ادخل اسم العضو ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: TextFormField(
                            controller: phoneController,
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
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 35, 0, 15),
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
                                privilege_edit = 'محرر';
                                setState(() {
                                  privilege = 'محرر';
                                });
                                print('switched to: محرر');
                                print(privilege);
                              } else {
                                privilege_index = 1;
                                privilege_edit = 'مشاهد';
                                setState(() {
                                  privilege = 'مشاهد';
                                });
                                print('switched to: مشاهد');
                                print(privilege);
                              }
                            },
                          ),
                        )),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Text(
                            "أضف عضو آخر",
                            style: TextStyle(
                              fontSize: 18,
                              // color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 50,
                        ),
                        //submit button
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
                            // padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    add_member();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تم اضافة عضو للمنزل ',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ))),
                                child: const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                    child: Text(
                                      'أضف العضو',
                                      // style: TextStyle(
                                      //     fontWeight: FontWeight.bold, fontSize: 15),
                                    )))),
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
                      houseID: widget.houseID,
                    )),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => listOfDevices(
                      houseID: widget.houseID,
                    )),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    add_house_member(houseID: widget.houseID)),
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

Future<void> add_member() async {
  CollectionReference members =
      FirebaseFirestore.instance.collection('houseMember');

  if (members != '') {
    print('2');
  }

  String memberId = '';
  DocumentReference docReference = await members.add({
    'name': nameController.text,
    'phone': phoneController.text,
    'privilege': privilege,
    'memberID': '',
    'accountID': 'xxx'
  });
  print('done');
  memberId = docReference.id;
  members.doc(memberId).update({'memberID': memberId});
  print('successful');
  clearText();
}

class global {
  static var index = 0;
}
