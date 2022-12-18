// ignore_for_file: prefer_const_constructors

import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class profile extends StatefulWidget {
  initState() {
    // ignore: avoid_print
    print("initState Called");
  }

  // final String userId;
  const profile({super.key});
  @override
  profileState createState() => profileState();
}

String name_edit = '', phone_edit = '', DOB = '', DOB_edit = '', userName = '';
TextEditingController DOBController = new TextEditingController();
TextEditingController nameController = new TextEditingController();
TextEditingController U_nameController = new TextEditingController();
TextEditingController phoneController = new TextEditingController();

bool Editing = false;
bool Viewing = true;

class profileState extends State<profile> {
  @override
  initState() {
    super.initState();
    print("entered ++++++++++++ !");
  
    Future<Map<String, dynamic>> readUserData() => FirebaseFirestore.instance
            .collection('userAccount')
            .doc('xd4GxeUvyyYTDO9iaMo2oaNg7qd2')
            .get()
            .then(
          (DocumentSnapshot doc) {
            DOBController.text = (doc.data() as Map<String, dynamic>)['DOB'];
            name_edit = (doc.data() as Map<String, dynamic>)['full_name'];
            U_nameController.text =
                (doc.data() as Map<String, dynamic>)['user_name'];
            phoneController.text =
                (doc.data() as Map<String, dynamic>)['phone_number'];
            return doc.data() as Map<String, dynamic>;
          },
        );
    print(name_edit);
    print(phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    var userData;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            ' حسابي  ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: //Icon(Icons.more_vert)
              PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      " تسجيل خروج",
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      "هل أنت متأكد من تسجيل الخروج ؟",
                      textAlign: TextAlign.right,
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
                        onPressed: () {},
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text("خروج",
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
                  child: Text("  تسجيل الخروج",
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
                  value: 'logout',
                ),
              ];
            },
          ),
          actions: [],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 40,
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      ' ! ' + U_nameController.text + '  مرحبًا  ',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Form
                  const SizedBox(
                    height: 25,
                  ),
                  //name field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Text('الاسم الكامل'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                    child: Column(children: [
                      TextFormField(
                        enabled: Editing,
                        textAlign: TextAlign.right,
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'الاسم',
                          alignLabelWithHint: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF06283D)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if ((value != null && value.length < 2) ||
                              value == null ||
                              value.isEmpty ||
                              (value.trim()).isEmpty) {
                            return "Enter a valid name";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ]),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Text(
                      'تاريخ الميلاد',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  //DOB field
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Column(
                        children: [
                          TextFormField(
                            textAlign: TextAlign.right,
                            enabled: Editing,
                            controller: DOBController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(DOBController.text),
                                firstDate: DateTime(1922),
                                lastDate: DateTime.now(),
                              );
                              if (newDate != null) {
                                setState(() {
                                  DOBController.text =
                                      DateFormat('yyyy-MM-dd').format(newDate);
                                  print(newDate);
                                  print('controller :' + DOBController.text);
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF06283D)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 3),
                              hintText: DOBController.text,
                              hintStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Text('رقم الهاتف'),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Column(
                        children: [
                          //phone number field
                          TextFormField(
                            textAlign: TextAlign.right,
                            enabled: Editing,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 10,
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: 'رقم الهاتف',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF06283D)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
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
                        ],
                      )),

                  const SizedBox(
                    height: 50,
                  ),
                  //Editing buttons :
                  Visibility(
                      visible: Viewing,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Editing = true;
                                    Viewing = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .transparent, // background (button) color
                                    foregroundColor:
                                        Color.fromARGB(255, 3, 3, 3),
                                    side: const BorderSide(
                                        width: 1, // the thickness
                                        color: Colors
                                            .black // the color of the border
                                        ),
                                    padding: const EdgeInsets.fromLTRB(
                                        110, 15, 110, 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                child: const Text('تحرير',
                                    style: TextStyle(fontSize: 22)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                iconSize: 70,
                                color: Color.fromARGB(255, 149, 37, 37),
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
                                        textAlign: TextAlign.end,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("إلغاء"),
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
                                                    color: Color.fromARGB(
                                                        255, 124, 18, 18))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ))),
                  //Save and cancel buttons
                  Visibility(
                      visible: Editing,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                          "هل أنت متأكد ؟",
                                          textAlign: TextAlign.center,
                                        ),
                                        content: const Text(
                                          "هل أنت متأكد من أنك تريد حفظ التغييرات؟",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("إلغاء",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 194, 98, 98))),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        '! تم حفظ التغييرات')),
                                              );
                                              UpdateDB();
                                              setState(() {
                                                Editing = false;
                                                Viewing = true;
                                              });
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                              child: const Text(
                                                "حفظ",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  //*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*
                                },
                                child: const Text('حفظ',
                                    style: TextStyle(fontSize: 20)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(0, 30, 255,
                                        0), // background (button) color
                                    foregroundColor:
                                        Color.fromARGB(255, 0, 0, 0),
                                    side: const BorderSide(
                                        width: 1, // the thickness
                                        color: Colors
                                            .black // the color of the border
                                        ),
                                    padding: const EdgeInsets.fromLTRB(
                                        70, 15, 70, 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              // Cancel changes
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                        "هل أنت متأكد ؟",
                                        textAlign: TextAlign.center,
                                      ),
                                      content: const Text(
                                        "هل أنت متأكد من أنك تريد إلغاء التغييرات؟",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Editing = false;
                                              Viewing = true;
                                            });
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("نعم",
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
                                            child: const Text(
                                              "لا",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('إلغاء',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 15, 12, 12))),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .transparent, // background (button) color
                                    foregroundColor:
                                        Color.fromARGB(255, 0, 0, 0),
                                    side: const BorderSide(
                                        width: 1, // the thickness
                                        color: Colors
                                            .black // the color of the border
                                        ),
                                    padding: const EdgeInsets.fromLTRB(
                                        70, 15, 70, 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            ],
                          ))),
                ],
              ),
            )),
          ],
        ));
  }
}

Future<void> UpdateDB() async {
  print('will be added to db');
  var Edit_info = FirebaseFirestore.instance
      .collection('userAccount')
      .doc('xd4GxeUvyyYTDO9iaMo2oaNg7qd2');
  Edit_info.update({
    'full_name': nameController.text,
    'phone_number': phoneController.text,
    'DOB': DOBController.text,
  });
  print('profile edited');
}
