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

TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
//TextEditingController privilegeController = TextEditingController();

String privilege_edit = 'مشاهد', privilege = '';
var privilege_index = 0;

class add_house_memberState extends State<add_house_member> {
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
          leading: //Icon(Icons.more_vert)
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
                                  color: Color.fromARGB(255, 35, 129, 6))),
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
                                  color: Color.fromARGB(255, 164, 10, 10))),
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
                  child: Text("مشاركة لوحة المعلومات "),
                  value: 'share',
                ),
                PopupMenuItem(
                  child: Text("حذف حساب المنرل",
                      style:
                          TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
                  value: 'delete',
                ),
              ];
            },
          ),
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
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(
                    height: 60,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'الاسم',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                            borderSide: const BorderSide(color: Colors.grey)),
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
                            borderSide: const BorderSide(color: Colors.grey)),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(180, 15, 180, 15),
                    child: ToggleSwitch(
                      minWidth: 180.0,
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
                        [Color.fromARGB(255, 160, 189, 166)],
                        [Color.fromARGB(255, 160, 189, 166)]
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
                  const SizedBox(
                    height: 60,
                  ),
                  //submit button
                  Container(
                      padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('تم اضافة عضو للمنزل ')),
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
                              padding: EdgeInsets.fromLTRB(90, 15, 90, 15),
                              child: Text(
                                'أضف الجهاز',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )))),
                ],
              ),
            )));
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
    'phone': nameController.text,
    'privilege': privilege,
    'memberId': '',
  });
  print('done');
  memberId = docReference.id;
  members.doc(memberId).update({'houseID': memberId});
  print('successful');
}
