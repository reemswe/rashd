import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Account extends StatefulWidget {
  // final String userId;
  const Account({super.key});
  @override
  AccountState createState() => AccountState();
}

String name_edit = '',
    phone_edit = '',
    DOB_edit = '',
    userName = ''; //For diability
//***************** */

var outDate;
bool Editing = false;
bool Viewing = true;

class AccountState extends State<Account> {
  void genderIndex(String D) {
    outDate = D;
  }

  Future<Map<String, dynamic>> readUserData() => FirebaseFirestore.instance
          .collection('userAccount')
          .doc('xd4GxeUvyyYTDO9iaMo2oaNg7qd2')
          .get()
          .then(
        (DocumentSnapshot doc) {
          return doc.data() as Map<String, dynamic>;
        },
      );

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> users =
        FirebaseFirestore.instance.collection('Users').snapshots();
    var userData;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: double.infinity,
          child: Text('My Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: readUserData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              userData = snapshot.data as Map<String, dynamic>;
              userName = userData['user_name'];
              name_edit = userData['full_name'];
              phone_edit = userData['phone_number'];
              DOB_edit = userData['DOB'];
              // genderIndex(DOB_edit);
              DateTime iniDOB = DateTime.parse(userData['DOB']);
              return SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'مرحبًا ' + userName,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //Form
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                        child: Column(
                          children: [
                            //name field
                            TextFormField(
                              enabled: Editing,
                              controller: TextEditingController()
                                ..text = userData['full_name'],
                              onChanged: (text) => {name_edit = text},
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF06283D)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Name',
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
                                  return "Enter a valid name";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            //DOB field
                            // TextFormField(
                            //   enabled: Editing,
                            //   // controller: TextEditingController()
                            //   //   ..text = outDate,
                            //   readOnly: true,
                            //   onChanged: (text) => {
                            //     outDate = text,
                            //     iniDOB = DateTime.parse(text)
                            //   },
                            //   onTap: () async {
                            //     DateTime? newDate = await showDatePicker(
                            //       context: context,
                            //       initialDate: iniDOB,
                            //       firstDate: DateTime(1922),
                            //       lastDate: DateTime.now(),
                            //     );
                            //     if (newDate != null) {
                            //       setState(() {
                            //         seting_outDate(DateFormat('yyyy-MM-dd')
                            //             .format(newDate));
                            //         outDate = DateFormat('yyyy-MM-dd')
                            //             .format(newDate);
                            //         print(newDate);
                            //         iniDOB = newDate;
                            //         DOB_edit = outDate;
                            //         print(DOB_edit);
                            //       });
                            //     } else {
                            //       print("Date is not selected");
                            //     }
                            //   },
                            //   decoration: InputDecoration(
                            //     enabledBorder: UnderlineInputBorder(
                            //       borderSide:
                            //           BorderSide(color: Color(0xFF06283D)),
                            //     ),
                            //     focusedBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(color: Colors.blue),
                            //     ),
                            //     contentPadding: EdgeInsets.only(bottom: 3),
                            //     labelText: 'Date Of Birth',
                            //     hintText: outDate,
                            //     hintStyle: const TextStyle(
                            //       fontSize: 18,
                            //       color: Colors.black,
                            //     ),
                            //     floatingLabelBehavior:
                            //         FloatingLabelBehavior.always,
                            //   ),
                            // ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(30, 12, 30, 0),
                        child: Column(
                          children: [
                            //phone number field
                            TextFormField(
                              enabled: Editing,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 10,
                              controller: TextEditingController()
                                ..text = userData['phone number'],
                              onChanged: (text) => {phone_edit = text},
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF06283D)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: 'Phone Number',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return "Please enter a phone number";
                                } else if (value.length != 10) {
                                  return "Please enter a valid phone number";
                                }
                              },
                            ),
                          ],
                        )),
                    //Editing buttons :
                    Visibility(
                        visible: Viewing,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
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
                                          const Color.fromARGB(255, 79, 83, 83),
                                      side: const BorderSide(
                                          width: 1, // the thickness
                                          color: Colors
                                              .black // the color of the border
                                          ),
                                      padding: const EdgeInsets.fromLTRB(
                                          90, 18, 90, 18),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  child: const Text('Edit Profile',
                                      style: TextStyle(fontSize: 22)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 15, 15, 17)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                          ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 37,
                                      color: const Color.fromARGB(
                                          255, 194, 98, 98),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text("Are You Sure ?"),
                                            content: const Text(
                                              "Are You Sure You want to delete your Account? , This procces can't be undone",
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(14),
                                                  child: const Text("cancel"),
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
                                                  print(
                                                      "success!, user deleted");
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(14),
                                                  child: const Text("Delete",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              194,
                                                              98,
                                                              98))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ))
                              ],
                            ))),
                    //Save and cancel buttons
                    Visibility(
                        visible: Editing,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Are You Sure ?"),
                                          content: const Text(
                                            "Are You Sure You want to Save changes ?",
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text("cancel",
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
                                                          'Changes have been Saved !')),
                                                );
                                                UpdateDB();
                                                setState(() {
                                                  Editing = false;
                                                  Viewing = true;
                                                });
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text(
                                                  "Save",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    //*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*
                                  },
                                  child: const Text('Save',
                                      style: TextStyle(fontSize: 20)),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .transparent, // background (button) color
                                      foregroundColor:
                                          const Color.fromARGB(255, 79, 83, 83),
                                      side: const BorderSide(
                                          width: 1, // the thickness
                                          color: Colors
                                              .black // the color of the border
                                          ),
                                      padding: const EdgeInsets.fromLTRB(
                                          60, 18, 60, 18),
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
                                        title: const Text("Are You Sure ?"),
                                        content: const Text(
                                          "Are You Sure You want to Cancel changes ?",
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
                                              child: const Text("Yes",
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
                                                "No",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 15, 12, 12))),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .transparent, // background (button) color
                                      foregroundColor:
                                          const Color.fromARGB(255, 79, 83, 83),
                                      side: const BorderSide(
                                          width: 1, // the thickness
                                          color: Colors
                                              .black // the color of the border
                                          ),
                                      padding: const EdgeInsets.fromLTRB(
                                          60, 18, 60, 18),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ],
                            ))),
                  ],
                ),
              ));
            } else {
              return const Text('Loading !');
            }
          }),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 12, 30, 22),
      child: TextField(
        enabled: Editing,
        minLines: 1,
        maxLines: 6,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF06283D)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 22,
              color: Colors.blue,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            )),
      ),
    );
  }
}

Future<void> UpdateDB() async {
  print('will be added to db');
  var Edit_info = FirebaseFirestore.instance
      .collection('userAccount')
      .doc('xd4GxeUvyyYTDO9iaMo2oaNg7qd2');
  Edit_info.update({
    'name': name_edit,
    'phone number': phone_edit,
    //'DOB': DOB_edit,
  });
  print('profile edited');
}
