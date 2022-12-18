// ignore_for_file: unused_import

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'create_house_account.dart';
// import 'list_of_house_accounts.dart';
// import 'login.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile extends StatefulWidget {
  // final String userId;
  const profile({super.key});
  @override
  profileState createState() => profileState();
}

TextEditingController DOBController = TextEditingController();

CollectionReference userInfo =
    FirebaseFirestore.instance.collection('userAccount');

// ignore: camel_case_types

String name_edit = '',
    //email_edit = '',
    phone_edit = '',
    user_name = '',
    DOB_edit = '';

bool Editing = false, Viewing = true;
String outDate = '';

class profileState extends State<profile> {
  DateTime selectedDate = DateTime.now();
  String bDay = "";
  bool showDate = false;

  // Future<DateTime> _selectDate(BuildContext context) async {
  //   final selected = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     // firstDate: DateTime(2000),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );
  //   if (selected != null && selected != selectedDate) {
  //     setState(() {
  //       selectedDate = selected;
  //       DOBController.text =
  //           DateFormat('yyyy-MM-dd').format(selected).toString();
  //     });
  //   }
  //   return selectedDate;
  // }

  // String getDate() {
  //   if (selectedDate == null) {
  //     return 'select date';
  //   } else {
  //     bDay = DateFormat('yyyy-MM-dd').format(selectedDate);
  //     return DateFormat('yyyy-MM-dd').format(selectedDate);
  //   }
  // }

  Future<Map<String, dynamic>> readUserData() => FirebaseFirestore.instance
          .collection('userAccount')
          .doc('xd4GxeUvyyYTDO9iaMo2oaNg7qd2')
          .get()
          .then(
        (DocumentSnapshot doc) {
          // print(doc.data() as Map<String, dynamic>);
          return doc.data() as Map<String, dynamic>;
        },
      );
  initState() {
    name_edit = '';
    //email_edit = '';
    phone_edit = '';
    DOB_edit = '';
    Viewing = true;
    Editing = false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
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
            if (value == 'delete') {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    " تسجيل خروج",
                    textAlign: TextAlign.left,
                  ),
                  content: const Text(
                    "هل أنت متأكد من تسجيل الخروج؟  ؟",
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const loginPage()),
                        // );
                      },
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
                    style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
                value: 'delete',
              ),
            ];
          },
        ),
        actions: [],
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: 
            Column(
              children: [
                // FutureBuilder<Map<String, dynamic>>(
                //     future: readUserData(),
                //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                //       if (snapshot.hasData) {
                //         userData = snapshot.data as Map<String, dynamic>;
                //         name_edit = userData['full_name'];
                //         //email_edit = userData['Email'];
                //         phone_edit = userData['phone_number'];
                //         //DOB_edit = userData['DOB'];
                //         user_name = userData['user_name'];
                //         //genderIndex(DOB_edit);
                //         DateTime iniDOB = DateTime.parse(userData['DOB']);
                //         return SingleChildScrollView(
                //             child: Form(
                //           key: _formKey,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             crossAxisAlignment: CrossAxisAlignment.end,
                //             children: [
                //               const SizedBox(
                //                 height: 25,
                //               ),
                //               Align(
                //                 alignment: Alignment.center,
                //                 child: Text(
                //                   'مرحبًا ' + user_name,
                //                   style: TextStyle(
                //                       fontSize: 30,
                //                       fontWeight: FontWeight.bold),
                //                 ),
                //               ),
                //               //Form(
                //               const SizedBox(
                //                 height: 25,
                //               ),
                //               Padding(
                //                   padding:
                //                       const EdgeInsets.fromLTRB(30, 12, 30, 12),
                //                   child: Column(
                //                     children: [
                //                       //name field
                //                       TextFormField(
                //                         enabled: Editing,
                //                         controller: TextEditingController()
                //                           ..text = userData['full_name'],
                //                         onChanged: (text) => {name_edit = text},
                //                         decoration: const InputDecoration(
                //                           enabledBorder: UnderlineInputBorder(
                //                             borderSide: BorderSide(
                //                                 color: Color(0xFF06283D)),
                //                           ),
                //                           focusedBorder: UnderlineInputBorder(
                //                             borderSide:
                //                                 BorderSide(color: Colors.blue),
                //                           ),
                //                           contentPadding:
                //                               EdgeInsets.only(bottom: 3),
                //                           labelText: 'الاسم الكامل',
                //                           floatingLabelBehavior:
                //                               FloatingLabelBehavior.always,
                //                         ),
                //                         autovalidateMode:
                //                             AutovalidateMode.onUserInteraction,
                //                         validator: (value) {
                //                           if ((value != null &&
                //                                   value.length < 2) ||
                //                               value == null ||
                //                               value.isEmpty ||
                //                               (value.trim()).isEmpty) {
                //                             return "ادخل اسم صحيح";
                //                           } else {
                //                             return null;
                //                           }
                //                         },
                //                       ),
                //                       const SizedBox(
                //                         height: 30,
                //                       ),
                //                       const SizedBox(
                //                         height: 30,
                //                       ),
                //                       //DOB field
                //                     ],
                //                   )),

                //               Padding(
                //                   padding:
                //                       const EdgeInsets.fromLTRB(30, 12, 30, 0),
                //                   child: Column(
                //                     children: [
                //                       //phone number field
                //                       TextFormField(
                //                         enabled: Editing,
                //                         keyboardType: TextInputType.number,
                //                         inputFormatters: <TextInputFormatter>[
                //                           FilteringTextInputFormatter.digitsOnly
                //                         ],
                //                         maxLength: 10,
                //                         controller: TextEditingController()
                //                           ..text = userData['phoneـnumber'],
                //                         onChanged: (text) =>
                //                             {phone_edit = text},
                //                         decoration: const InputDecoration(
                //                           enabledBorder: UnderlineInputBorder(
                //                             borderSide: BorderSide(
                //                                 color: Color(0xFF06283D)),
                //                           ),
                //                           focusedBorder: UnderlineInputBorder(
                //                             borderSide:
                //                                 BorderSide(color: Colors.blue),
                //                           ),
                //                           contentPadding:
                //                               EdgeInsets.only(bottom: 3),
                //                           labelText: 'رقم الهاتف',
                //                           floatingLabelBehavior:
                //                               FloatingLabelBehavior.always,
                //                         ),
                //                         autovalidateMode:
                //                             AutovalidateMode.onUserInteraction,
                //                         validator: (value) {
                //                           if (value == null) {
                //                             return "رجاء ادخل رقم هاتف";
                //                           } else if (value.length != 10) {
                //                             return "رجاء ادخل رقم هاتف صحيح";
                //                           }
                //                         },
                //                       ),
                //                     ],
                //                   )),
                //               //Editing buttons :
                //               Visibility(
                //                   visible: Viewing,
                //                   child: Padding(
                //                       padding: const EdgeInsets.fromLTRB(
                //                           30, 20, 0, 0),
                //                       child: Row(
                //                         children: [
                //                           ElevatedButton(
                //                             onPressed: () {
                //                               setState(() {
                //                                 Editing = true;
                //                                 Viewing = false;
                //                               });
                //                             },
                //                             child: const Text('تحرير الحساب',
                //                                 style: TextStyle(fontSize: 22)),
                //                             style: ElevatedButton.styleFrom(
                //                                 backgroundColor: Colors
                //                                     .transparent, // background (button) color
                //                                 foregroundColor:
                //                                     const Color.fromARGB(
                //                                         255, 79, 83, 83),
                //                                 side: const BorderSide(
                //                                     width: 1, // the thickness
                //                                     color: Colors
                //                                         .black // the color of the border
                //                                     ),
                //                                 padding:
                //                                     const EdgeInsets.fromLTRB(
                //                                         90, 18, 90, 18),
                //                                 shape: RoundedRectangleBorder(
                //                                     borderRadius:
                //                                         BorderRadius.circular(
                //                                             10.0))),
                //                           ),
                //                           const SizedBox(
                //                             width: 10,
                //                           ),
                //                           Container(
                //                               decoration: BoxDecoration(
                //                                 border: Border.all(
                //                                     color: const Color.fromARGB(
                //                                         255, 15, 15, 17)),
                //                                 borderRadius: const BorderRadius
                //                                         .all(
                //                                     Radius.circular(
                //                                         5.0) //                 <--- border radius here
                //                                     ),
                //                               ),
                //                               child: IconButton(
                //                                 icon: const Icon(Icons.delete),
                //                                 iconSize: 37,
                //                                 color: const Color.fromARGB(
                //                                     255, 194, 98, 98),
                //                                 onPressed: () {
                //                                   showDialog(
                //                                     context: context,
                //                                     builder: (ctx) =>
                //                                         AlertDialog(
                //                                       title: const Text(
                //                                           "هل أنت متأكد؟"),
                //                                       content: const Text(
                //                                         "هل أنت متأكد من حذف الحساب؟ هذة العملية لا يمكن التراجع عنها",
                //                                         textAlign:
                //                                             TextAlign.center,
                //                                       ),
                //                                       actions: <Widget>[
                //                                         TextButton(
                //                                           onPressed: () {
                //                                             Navigator.of(ctx)
                //                                                 .pop();
                //                                           },
                //                                           child: Container(
                //                                             padding:
                //                                                 const EdgeInsets
                //                                                     .all(14),
                //                                             child: const Text(
                //                                                 "الغاء"),
                //                                           ),
                //                                         ),
                //                                         TextButton(
                //                                           onPressed: () {
                //                                             //   FirebaseFirestore.instance
                //                                             //       .collection("users")
                //                                             //       .doc(userData['id'])
                //                                             //       .delete()
                //                                             //       .then((_) {
                //                                             //     print(
                //                                             //         "success!, user deleted");
                //                                             //   });

                //                                             Navigator.of(ctx)
                //                                                 .pop();
                //                                           },
                //                                           child: Container(
                //                                             padding:
                //                                                 const EdgeInsets
                //                                                     .all(14),
                //                                             child: const Text(
                //                                                 "حذف",
                //                                                 style: TextStyle(
                //                                                     color: Color
                //                                                         .fromARGB(
                //                                                             255,
                //                                                             194,
                //                                                             98,
                //                                                             98))),
                //                                           ),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   );
                //                                 },
                //                               ))
                //                         ],
                //                       ))),
                //               //Save and cancel buttons
                //               Visibility(
                //                   visible: Editing,
                //                   child: Padding(
                //                       padding: const EdgeInsets.fromLTRB(
                //                           20, 20, 0, 0),
                //                       child: Row(
                //                         children: [
                //                           ElevatedButton(
                //                             onPressed: () {
                //                               if (_formKey.currentState!
                //                                   .validate()) {
                //                                 showDialog(
                //                                   context: context,
                //                                   builder: (ctx) => AlertDialog(
                //                                     title: const Text(
                //                                         "هل أنت متأكد"),
                //                                     content: const Text(
                //                                       "هل أنت متأكد من حفظ المعلومات",
                //                                       textAlign:
                //                                           TextAlign.center,
                //                                     ),
                //                                     actions: <Widget>[
                //                                       TextButton(
                //                                         onPressed: () {
                //                                           Navigator.of(ctx)
                //                                               .pop();
                //                                         },
                //                                         child: Container(
                //                                           padding:
                //                                               const EdgeInsets
                //                                                   .all(14),
                //                                           child: const Text(
                //                                               "الغاء",
                //                                               style: TextStyle(
                //                                                   color: Color
                //                                                       .fromARGB(
                //                                                           255,
                //                                                           194,
                //                                                           98,
                //                                                           98))),
                //                                         ),
                //                                       ),
                //                                       TextButton(
                //                                         onPressed: () {
                //                                           ScaffoldMessenger.of(
                //                                                   context)
                //                                               .showSnackBar(
                //                                             const SnackBar(
                //                                                 content: Text(
                //                                                     ' ! تم حفظ التغييرات ')),
                //                                           );
                //                                           UpdateDB();
                //                                           setState(() {
                //                                             Editing = false;
                //                                             Viewing = true;
                //                                           });
                //                                           Navigator.of(ctx)
                //                                               .pop();
                //                                         },
                //                                         child: Container(
                //                                           padding:
                //                                               const EdgeInsets
                //                                                   .all(14),
                //                                           child: const Text(
                //                                             "حفظ",
                //                                           ),
                //                                         ),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 );
                //                               }
                //                             },
                //                             child: const Text('حفظ',
                //                                 style: TextStyle(fontSize: 20)),
                //                             style: ElevatedButton.styleFrom(
                //                                 backgroundColor: Colors
                //                                     .transparent, // background (button) color
                //                                 foregroundColor:
                //                                     const Color.fromARGB(
                //                                         255, 79, 83, 83),
                //                                 side: const BorderSide(
                //                                     width: 1, // the thickness
                //                                     color: Colors
                //                                         .black // the color of the border
                //                                     ),
                //                                 padding:
                //                                     const EdgeInsets.fromLTRB(
                //                                         60, 18, 60, 18),
                //                                 shape: RoundedRectangleBorder(
                //                                     borderRadius:
                //                                         BorderRadius.circular(
                //                                             10.0))),
                //                           ),
                //                           const SizedBox(
                //                             width: 10,
                //                           ),
                //                           // Cancel changes
                //                           ElevatedButton(
                //                             onPressed: () {
                //                               showDialog(
                //                                 context: context,
                //                                 builder: (ctx) => AlertDialog(
                //                                   title: const Text(
                //                                       "هل أنت متأكد؟"),
                //                                   content: const Text(
                //                                     "هل أنت متأكد من الغاء التغييرات؟",
                //                                     textAlign: TextAlign.center,
                //                                   ),
                //                                   actions: <Widget>[
                //                                     TextButton(
                //                                       onPressed: () {
                //                                         setState(() {
                //                                           //clearBool();
                //                                           Editing = false;
                //                                           Viewing = true;
                //                                         });
                //                                         Navigator.of(ctx).pop();
                //                                       },
                //                                       child: Container(
                //                                         padding:
                //                                             const EdgeInsets
                //                                                 .all(14),
                //                                         child: const Text("نعم",
                //                                             style: TextStyle(
                //                                                 color: Color
                //                                                     .fromARGB(
                //                                                         255,
                //                                                         194,
                //                                                         98,
                //                                                         98))),
                //                                       ),
                //                                     ),
                //                                     TextButton(
                //                                       onPressed: () {
                //                                         Navigator.of(ctx).pop();
                //                                       },
                //                                       child: Container(
                //                                         padding:
                //                                             const EdgeInsets
                //                                                 .all(14),
                //                                         child: const Text(
                //                                           "لا",
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               );
                //                             },
                //                             child: const Text('الغاء',
                //                                 style: TextStyle(
                //                                     fontSize: 20,
                //                                     color: Color.fromARGB(
                //                                         255, 15, 12, 12))),
                //                             style: ElevatedButton.styleFrom(
                //                                 backgroundColor: Colors
                //                                     .transparent, // background (button) color
                //                                 foregroundColor:
                //                                     const Color.fromARGB(
                //                                         255, 79, 83, 83),
                //                                 side: const BorderSide(
                //                                     width: 1, // the thickness
                //                                     color: Colors
                //                                         .black // the color of the border
                //                                     ),
                //                                 padding:
                //                                     const EdgeInsets.fromLTRB(
                //                                         60, 18, 60, 18),
                //                                 shape: RoundedRectangleBorder(
                //                                     borderRadius:
                //                                         BorderRadius.circular(
                //                                             10.0))),
                //                           ),
                //                         ],
                //                       ))),
                //             ],
                //           ),
                //         ));
                //       } else {
                //         return const Text('Good Bye !');
                //       }
                //     }),
                const SizedBox(
                  height: 25,
                ),
                Icon(
                  Icons.person_pin,
                  color: Color.fromARGB(255, 100, 96, 98),
                  size: 140,
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //name
                      const Text(
                        ':الاسم الكامل',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        initialValue: 'هيفاء بن عوين',
                        //controller:
                        //onChanged: (text) => {controller = text},
                        decoration: const InputDecoration(
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
                            return "ادخل اسم صحيح";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      //DOB
                      Text(
                        ':اسم المستخدم',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        initialValue: 'هيفاءـ٣٣',
                        //controller:
                        //onChanged: (text) => {controller = text},
                        decoration: const InputDecoration(
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
                            return "ادخل اسم صحيح";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      //name
                      const Text(
                        ':تاريخ الميلاد',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        readOnly: true,
                        initialValue: '2000/12/23',
                        //controller: DOBController,
                        // onTap: () {
                        //   _selectDate(context);
                        //   showDate = false;
                        //   bDay = getDate();
                        //   // DOBController.text = globals.bDay;
                        // },
                        //onChanged: (text) => {controller = text},
                        decoration: const InputDecoration(
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
                        // validator: (value) {
                        //   if (value == null ||
                        //       value.isEmpty ||
                        //       (value.trim()).isEmpty) {
                        //     return 'الرجاء اختيار تاريخ الميلاد';
                        //   }
                        // },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        ':رقم الهاتف',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        initialValue: '0569204145',
                        //controller:
                        //onChanged: (text) => {controller = text},
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
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
                            return "ادخل اسم صحيح";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),

                //*
                const SizedBox(
                  height: 75,
                ),
                //*
                Visibility(
                  visible: false,
                  child: Container(
                      margin: const EdgeInsets.all(30),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('تمت حفظ التغييرات')),
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
                                'تحرير',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )))),
                )
              ],
            ),
          )),
      // bottomNavigationBar: buildBottomNavigation(),
    );
  }

  int index = 0;
  // Widget buildBottomNavigation() {
  //   return BottomNavyBar(
  //     selectedIndex: global.index,
  //     onItemSelected: (index) {
  //       setState(
  //         () => global.index = index,
  //       );
  //       if (global.index == 0) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const profile()),
  //         );
  //       } else if (global.index == 1) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const ListOfHouseAccounts()),
  //         );
  //       }
  //     },
  //     items: <BottomNavyBarItem>[
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.person_outline_rounded),
  //         // icon: IconButton(
  //         //     icon: const Icon(Icons.person_outline_rounded),
  //         //     onPressed: () {
  //         //       setState(
  //         //         () => this.index = index,
  //         //       );
  //         //       Navigator.push(
  //         //         context,
  //         //         MaterialPageRoute(
  //         //             builder: (context) => const CreateHouseAccount()),
  //         //       );
  //         //     }),
  //         title: const Text(
  //           'الملف الشخصي',
  //           textAlign: TextAlign.center,
  //         ),
  //         activeColor: Colors.lightBlue,
  //       ),
  //       BottomNavyBarItem(
  //           icon: const Icon(Icons.holiday_village_rounded),
  //           // icon: IconButton(
  //           //     icon: const Icon(Icons.holiday_village_rounded),
  //           //     onPressed: () {

  //           //       setState(
  //           //         () => this.index = index,
  //           //       );
  //           //       Navigator.push(
  //           //         context,
  //           //         MaterialPageRoute(
  //           //             builder: (context) => const ListOfHouseAccounts()),
  //           //       );
  //           //     }),
  //           title: const Text(
  //             'منازلي',
  //             textAlign: TextAlign.center,
  //           ),
  //           activeColor: Colors.lightBlue),
  //     ],
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   );
  // }
}
// Future<void> UpdateDB() async {
//   var Edit_info = FirebaseFirestore.instance
//       .collection('userAccount')
//       .doc('xd4GxeUvyyYTDO9iaMo2oaNg7qd2');
//   Edit_info.update({
//     'full_name': name_edit,
//     'phone_number': phone_edit,
//     //'Email': email_edit,
//     //'DOB': DOB_edit,
//   });
//   print('profile edited');
// }
