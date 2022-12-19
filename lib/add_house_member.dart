import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
  // final String userId;
  const add_house_member({super.key});
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
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' البيت',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // leading: //Icon(Icons.more_vert)
        //     PopupMenuButton(
        //   onSelected: (value) {
        //     if (value == 'share') {
        //       showDialog(
        //         context: context,
        //         builder: (ctx) => AlertDialog(
        //           title: const Text(
        //             "مشاركة لوحة المعلومات",
        //             textAlign: TextAlign.left,
        //           ),
        //           content: const Text(
        //             'رجاء ادخل رقم جوال لمشاركة لوحة المعلومات',
        //             textAlign: TextAlign.left,
        //           ),
        //           actions: <Widget>[
        //             TextFormField(
        //               textAlign: TextAlign.right,
        //               keyboardType: TextInputType.number,
        //               inputFormatters: <TextInputFormatter>[
        //                 LengthLimitingTextInputFormatter(10),
        //                 FilteringTextInputFormatter.digitsOnly
        //               ],
        //               decoration: InputDecoration(
        //                 contentPadding: const EdgeInsets.symmetric(
        //                     vertical: 13.0, horizontal: 15),
        //                 border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(30.0),
        //                 ),
        //                 filled: true,
        //                 hintStyle: TextStyle(color: Colors.grey[800]),
        //                 hintText: " رقم الهاتف",
        //               ),
        //               // The validator receives the text that the user has entered.
        //               validator: (value) {
        //                 if (value == null || value.isEmpty) {
        //                   return '  رجاء ادخل رقم هاتف';
        //                 }
        //                 if (value.length < 10) {
        //                   return '  رجاء ادخل رقم هاتف صحيح';
        //                 }
        //                 return null;
        //               },
        //             ),
        //             TextButton(
        //               onPressed: () {
        //                 Navigator.of(ctx).pop();
        //               },
        //               child: Container(
        //                 padding: const EdgeInsets.all(14),
        //                 child: const Text("الغاء"),
        //               ),
        //             ),
        //             //log in ok button
        //             TextButton(
        //               onPressed: () {
        //                 // pop out
        //               },
        //               child: Container(
        //                 padding: const EdgeInsets.all(14),
        //                 child: const Text("مشاركة",
        //                     style: TextStyle(
        //                         color: Color.fromARGB(255, 35, 129, 6))),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) => const Share()),
        //       // );
        //     }
        //     if (value == 'delete') {
        //       showDialog(
        //         context: context,
        //         builder: (ctx) => AlertDialog(
        //           title: const Text(
        //             "حذف المنزل",
        //             textAlign: TextAlign.left,
        //           ),
        //           content: const Text(
        //             "هل أنت متأكد من حذف حساب المنزل ؟",
        //             textAlign: TextAlign.left,
        //           ),
        //           actions: <Widget>[
        //             TextButton(
        //               onPressed: () {
        //                 Navigator.of(ctx).pop();
        //               },
        //               child: Container(
        //                 padding: const EdgeInsets.all(14),
        //                 child: const Text("الغاء"),
        //               ),
        //             ),
        //             //log in ok button
        //             TextButton(
        //               onPressed: () {
        //                 // pop out
        //               },
        //               child: Container(
        //                 padding: const EdgeInsets.all(14),
        //                 child: const Text("حذف",
        //                     style: TextStyle(
        //                         color: Color.fromARGB(255, 164, 10, 10))),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }
        //     // your logic
        //   },
        //   itemBuilder: (BuildContext bc) {
        //     return const [
        //       PopupMenuItem(
        //         child: Text("مشاركة لوحة المعلومات "),
        //         value: 'share',
        //       ),
        //       PopupMenuItem(
        //         child: Text("حذف حساب المنرل",
        //             style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
        //         value: 'delete',
        //       ),
        //     ];
        //   },
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 35,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'إضافة أعضاء للمنزل',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0)),
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
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0)),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 35, 45, 15),
                  child: ToggleSwitch(
                    minWidth: 150.0,
                    minHeight: 45.0,
                    borderWidth: 1,
                    borderColor: const [
                      Color.fromARGB(255, 149, 149, 149),
                      Color.fromARGB(255, 149, 149, 149)
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
                    cornerRadius: 10.0,
                    activeFgColor: const Color.fromARGB(255, 255, 255, 255),
                    inactiveBgColor: Colors.white,
                    inactiveFgColor: Colors.black,
                    totalSwitches: 2,
                    labels: const ['محرر', 'مشاهد'],
                    activeBgColors: const [
                      [Color.fromARGB(255, 154, 163, 189)],
                      [Color.fromARGB(255, 154, 163, 189)]
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
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(90, 15, 50, 15),
                  child: Text(
                    "أضف عضو آخر",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),
                //submit button
                Container(
                    padding: const EdgeInsets.only(left: 60.0, right: 60.0),
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
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ))),
                        child: const Padding(
                            padding: EdgeInsets.fromLTRB(90, 15, 90, 15),
                            child: Text(
                              'أضف العضو',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )))),
              ],
            ),
          )),
    );
  }

  int index = 0;
  Widget buildBottomNavigation() {
    return BottomNavyBar(
      selectedIndex: global.index,
      onItemSelected: (index) {
        setState(
          () => global.index = index,
        );
        if (global.index == 0) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const devicesList()),
          // );
        } else if (global.index == 1) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const dashboard()),
          // );
        } else if (global.index == 2) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => const ListOfHouseAccounts()),
          // );
        }
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.electrical_services_rounded),
          // icon: IconButton(
          //     icon: const Icon(Icons.person_outline_rounded),
          //     onPressed: () {
          //       setState(
          //         () => this.index = index,
          //       );
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const CreateHouseAccount()),
          //       );
          //     }),
          title: const Text(
            ' اجهزتي',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
        BottomNavyBarItem(
            icon: const Icon(Icons.auto_graph_outlined),
            // icon: IconButton(
            //     icon: const Icon(Icons.holiday_village_rounded),
            //     onPressed: () {

            //       setState(
            //         () => this.index = index,
            //       );
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const ListOfHouseAccounts()),
            //       );
            //     }),
            title: const Text(
              'لوحة المعلومات',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
        BottomNavyBarItem(
            icon: const Icon(Icons.holiday_village_rounded),
            // icon: IconButton(
            //     icon: const Icon(Icons.holiday_village_rounded),
            //     onPressed: () {

            //       setState(
            //         () => this.index = index,
            //       );
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const ListOfHouseAccounts()),
            //       );
            //     }),
            title: const Text(
              'منازلي',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
