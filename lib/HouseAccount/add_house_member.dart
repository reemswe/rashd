// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rashd/Dashboard/dashboard.dart';
// import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
// import 'package:toggle_switch/toggle_switch.dart';
// import '../Devices/listOfDevices.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class add_house_member extends StatefulWidget {
//   final ID;
//   const add_house_member({super.key, required this.ID});
//   @override
//   add_house_memberState createState() => add_house_memberState();
// }

// class add_house_memberState extends State<add_house_member> {
//   int counter = 1;
//   TextEditingController houseName = TextEditingController();
//   List<Widget> addMembers = [];
//   TextEditingController membersPhoneNumber1 = TextEditingController();
//   TextEditingController membersPhoneNumber2 = TextEditingController();
//   TextEditingController membersPhoneNumber3 = TextEditingController();
//   TextEditingController membersPhoneNumber4 = TextEditingController();
//   TextEditingController membersPhoneNumber5 = TextEditingController();
//   TextEditingController membersNames1 = TextEditingController();
//   TextEditingController membersNames2 = TextEditingController();
//   TextEditingController membersNames3 = TextEditingController();
//   TextEditingController membersNames4 = TextEditingController();
//   TextEditingController membersNames5 = TextEditingController();
//   List<TextEditingController> membersPhones = [];
//   List<TextEditingController> membersNames = [];
//   List<bool> duplicates = [true, true, true, true, true];

//   ScrollController list = ScrollController();
//   String existing = '';
//   //toggle swithc
//   String privilege_edit = 'viewer', privilege = '';
//   var privilege_index = 1;
//   String privilege_edit2 = 'viewer', privilege2 = '';
//   var privilege_index2 = 1;
//   //toggle switch

//   List roles = ['viewer', 'viewer', 'viewer', 'viewer', 'viewer'];

//   List indexes = ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'];
//   int num = 0;
//   void addMemberWidget() {
//     setState(() {
//       addMembers.add(members());
//     });
//   }

//   void createList() {
//     setState(() {
//       membersPhones.add(membersPhoneNumber1);
//       membersPhones.add(membersPhoneNumber2);
//       membersPhones.add(membersPhoneNumber3);
//       membersPhones.add(membersPhoneNumber4);
//       membersPhones.add(membersPhoneNumber5);
//       membersNames.add(membersNames1);
//       membersNames.add(membersNames2);
//       membersNames.add(membersNames3);
//       membersNames.add(membersNames4);
//       membersNames.add(membersNames5);
//     });
//   }

//   Widget members() {
//     num++;

//     String place = indexes[num];
//     setState(() {
//       privilege_edit2 = 'viewer';
//       privilege2 = 'viewer';
//       privilege_index2 = 1;
//     });

//     return Container(
//         padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
//         child: Column(children: <Widget>[
//           Text('  عضو المنزل $place ', textAlign: TextAlign.right),
//           Padding(
//               padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//               child: TextFormField(
//                 maxLength: 20,
//                 controller: membersNames[num],
//                 textAlign: TextAlign.right,
//                 decoration: InputDecoration(
//                   hintText: ' الاسم ',
//                   contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide: const BorderSide(color: Colors.grey)),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide: BorderSide(color: Colors.grey.shade400)),
//                   errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide:
//                           const BorderSide(color: Colors.red, width: 2.0)),
//                   focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide:
//                           const BorderSide(color: Colors.red, width: 2.0)),
//                 ),
//                 validator: (value) {
//                   if (membersPhones[num].text != '' && value == '') {
//                     return 'اختر إسمًا للعضو ';
//                   }
//                   return null;
//                 },
//               )),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//               padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//               child: TextFormField(
//                 controller: membersPhones[num],
//                 maxLength: 10,
//                 textAlign: TextAlign.right,
//                 decoration: InputDecoration(
//                   hintText: ' رقم الجوال ',
//                   contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide: const BorderSide(color: Colors.grey)),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide: BorderSide(color: Colors.grey.shade400)),
//                   errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide:
//                           const BorderSide(color: Colors.red, width: 2.0)),
//                   focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(100.0),
//                       borderSide:
//                           const BorderSide(color: Colors.red, width: 2.0)),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value!.isNotEmpty && value.length < 10) {
//                     return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
//                   }
//                   return null;
//                 },
//               )),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//             child: ToggleSwitch(
//               minWidth: 150.0,
//               minHeight: 45.0,
//               borderWidth: 1,
//               borderColor: const [
//                 Color.fromARGB(255, 149, 149, 149),
//                 Color.fromARGB(255, 149, 149, 149)
//               ],
//               customTextStyles: const [
//                 TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//                 TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 )
//               ],
//               initialLabelIndex: privilege_index2,
//               cornerRadius: 10.0,
//               activeFgColor: const Color.fromARGB(255, 255, 255, 255),
//               inactiveBgColor: Colors.white,
//               inactiveFgColor: Colors.black,
//               totalSwitches: 2,
//               labels: const ['محرر', 'مشاهد'],
//               activeBgColors: const [
//                 [Colors.blue],
//                 [Colors.blue],
//               ],
//               onToggle: (index) {
//                 if (index == 0) {
//                   privilege_index2 = 0;
//                   privilege_edit2 = 'editor';
//                   setState(() {
//                     privilege2 = 'editor';
//                     roles[num] = 'editor';
//                   });
//                   print('switched to: editor');
//                   print(privilege2);
//                 } else {
//                   privilege_index2 = 1;
//                   privilege_edit2 = 'viewer';
//                   setState(() {
//                     privilege2 = 'viewer';
//                     roles[num] = 'viewer';
//                   });
//                   print('switched to: viewer');
//                   print(privilege2);
//                 }
//               },
//             ),
//           ),
//         ]));
//   }

//   final _formKey = GlobalKey<FormState>();
//   void clearText() {
//     membersPhoneNumber1.clear();
//     membersPhoneNumber2.clear();
//     membersPhoneNumber3.clear();
//     membersPhoneNumber4.clear();
//     membersPhoneNumber5.clear();
//     counter = 1;
//     existing = '';
//     privilege_edit = 'viewer';
//     privilege = '';
//     privilege_index = 1;
//     privilege_edit2 = 'viewer';
//     privilege2 = '';
//     privilege_index2 = 1;
//     roles = ['viewer', 'viewer', 'viewer', 'viewer', 'viewer'];
//     indexes = ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'];
//     num = 0;
//   }

//   @override
//   void initState() {
//     setState(() {
//       createList();
//       clearText();
//       //toggle switch
//       privilege_index = 1;
//       privilege_edit = 'viewer';
//       privilege = 'viewer';
//       privilege_index2 = 1;
//       privilege_edit2 = 'viewer';
//       privilege2 = 'viewer';
//       //toggle switch
//     });
//     super.initState();
//   }

//   Future<Map<String, dynamic>> readHouseData(var id) =>
//       FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
//         (DocumentSnapshot doc) {
//           return doc.data() as Map<String, dynamic>;
//         },
//       );

//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     final double width = MediaQuery.of(context).size.width;
//     createList();
//     // final _formKey = GlobalKey<FormState>();
//     return FutureBuilder<Map<String, dynamic>>(
//         future: readHouseData(widget.ID),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             var houseData = snapshot.data as Map<String, dynamic>;
//             return Scaffold(
//               appBar: AppBar(
//                 toolbarHeight: height * 0.085,
//                 title: Wrap(
//                     direction: Axis.vertical,
//                     spacing: 1, // to apply margin in the main axis of the wrap
//                     children: <Widget>[
//                       SizedBox(height: height * 0.01),
//                       // Text(
//                       //   houseData['houseName'],
//                       //   style: TextStyle(
//                       //     color: Colors.black,
//                       //     fontWeight: FontWeight.bold,
//                       //     fontSize: 25,
//                       //     height: 1,
//                       //   ),
//                       // ),
//                       // Text(
//                       //   houseData['OwnerID'] ==
//                       //           FirebaseAuth.instance.currentUser!.uid
//                       //       ? 'مالك المنزل'
//                       //       : "عضو في المنزل",
//                       //   style: TextStyle(
//                       //     color: Colors.grey.shade900,
//                       //     fontWeight: FontWeight.w400,
//                       //     fontSize: 16,
//                       //     height: 1,
//                       //   ),
//                       // )
//                     ]),
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 leading: IconButton(
//                   icon: const Icon(Icons.arrow_back_ios),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ListOfHouseAccounts(),
//                         ));
//                   },
//                 ),
//                 elevation: 1.5,
//               ),
//               body: Form(
//                   key: _formKey,
//                   child: SingleChildScrollView(
//                     controller: list,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           height: 35,
//                         ),
//                         const Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             'إضافة أعضاء للمنزل',
//                             style: TextStyle(
//                                 fontSize: 25, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 60,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//                           child: TextFormField(
//                             controller: membersNames[0],
//                             textAlign: TextAlign.right,
//                             maxLength: 20,

//                             decoration: InputDecoration(
//                               hintText: 'الاسم',
//                               contentPadding:
//                                   const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide:
//                                       const BorderSide(color: Colors.grey)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade400)),
//                               errorBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide: const BorderSide(
//                                       color: Colors.red, width: 2.0)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide: const BorderSide(
//                                       color: Colors.red, width: 2.0)),
//                             ),
//                             // The validator receives the text that the user has entered.
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'رجاء ادخل اسم العضو ';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: height * 0.001,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//                           child: TextFormField(
//                             controller: membersPhones[0],
//                             maxLength: 10,
//                             textAlign: TextAlign.right,
//                             keyboardType: TextInputType.number,
//                             inputFormatters: <TextInputFormatter>[
//                               LengthLimitingTextInputFormatter(10),
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             decoration: InputDecoration(
//                               hintText: 'رقم الهاتف',
//                               contentPadding:
//                                   const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide:
//                                       const BorderSide(color: Colors.grey)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade400)),
//                               errorBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide: const BorderSide(
//                                       color: Colors.red, width: 2.0)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(100.0),
//                                   borderSide: const BorderSide(
//                                       color: Colors.red, width: 2.0)),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return '  رجاء ادخل رقم هاتف';
//                               }
//                               if (value.length < 10) {
//                                 return '  رجاء ادخل رقم هاتف صحيح';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: height * 0.001,
//                         ),
//                         Center(
//                             child: Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
//                           child: ToggleSwitch(
//                             minWidth: width * 0.8,
//                             minHeight: 50.0,
//                             borderWidth: 1,
//                             borderColor: const [
//                               Colors.lightBlue,
//                               Colors.lightBlue,
//                             ],
//                             customTextStyles: const [
//                               TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                               ),
//                               TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                               )
//                             ],
//                             initialLabelIndex: privilege_index,
//                             cornerRadius: 100.0,
//                             activeFgColor:
//                                 const Color.fromARGB(255, 255, 255, 255),
//                             inactiveBgColor: Colors.white,
//                             inactiveFgColor: Colors.black,
//                             totalSwitches: 2,
//                             labels: const ['محرر', 'مشاهد'],
//                             activeBgColors: const [
//                               [Colors.lightBlue],
//                               [Colors.lightBlue]
//                             ],
//                             onToggle: (index) {
//                               if (index == 0) {
//                                 privilege_index = 0;
//                                 privilege_edit = 'editor';
//                                 setState(() {
//                                   privilege = 'editor';
//                                   roles[0] = 'editor';
//                                 });
//                                 print('switched to: editor');
//                                 print(privilege);
//                               } else {
//                                 privilege_index = 1;
//                                 privilege_edit = 'viewer';
//                                 setState(() {
//                                   privilege = 'viewer';
//                                   roles[0] = 'viewer';
//                                 });
//                                 print('switched to: viewer');
//                                 print(privilege);
//                               }
//                             },
//                           ),
//                         )),
//                         ListView.builder(
//                             physics: const NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: addMembers.length,
//                             itemBuilder: (context, index) {
//                               return addMembers[index];
//                             }),
//                         Visibility(
//                           visible: counter < 5,
//                           child: TextButton(
//                             style: const ButtonStyle(
//                               alignment: Alignment.centerRight,
//                             ),
//                             onPressed: () {
//                               createList();
//                               addMemberWidget();
//                               counter++;
//                             },
//                             child: const Text(
//                               ' إضافة عضو آخر',
//                               textAlign: TextAlign.right,
//                               style: TextStyle(
//                                   color: Colors.blue,
//                                   decoration: TextDecoration.underline),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                             width: width * 0.5,
//                             decoration: BoxDecoration(
//                               boxShadow: const [
//                                 BoxShadow(
//                                     color: Colors.black26,
//                                     offset: Offset(0, 4),
//                                     blurRadius: 5.0)
//                               ],
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 stops: [0.1, 1.0],
//                                 colors: [
//                                   Colors.blue.shade200,
//                                   Colors.blue.shade400,
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 int singular = 0;
//                                 existing = '';
//                                 if (!_formKey.currentState!.validate()) {
//                                 } else {
//                                   print(houseName.text);
//                                   bool flag = true;
//                                   for (int i = 0; i <= num; i++) {
//                                     if (membersPhones[i].text.isNotEmpty &&
//                                         await exixts(membersPhones[i].text)) {
//                                       duplicates[i] = true;
//                                       print('true-->' + membersPhones[i].text);
//                                     } else {
//                                       duplicates[i] = false;
//                                       print('false-->' + membersPhones[i].text);
//                                     }
//                                   }
//                                   for (int i = 0; i <= num; i++) {
//                                     if (!duplicates[i] &&
//                                         membersPhones[i].text.isNotEmpty) {
//                                       String place = indexes[i];
//                                       existing += 'العضو $place ,  ';
//                                       singular++;
//                                     }
//                                   }
//                                   if (singular == 0) {
//                                     setData();
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(const SnackBar(
//                                             content: Text(
//                                               '  تم الاضافة بنجاح',
//                                               textAlign: TextAlign.center,
//                                             ),
//                                             backgroundColor: Colors.green));
//                                   } else {
//                                     if (singular > 1) {
//                                       existing += ' غير موجودين بالنظام';
//                                     } else {
//                                       existing += ' غير موجود بالنظام';
//                                     }
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(SnackBar(
//                                             content: Text(
//                                               existing,
//                                               textAlign: TextAlign.center,
//                                             ),
//                                             backgroundColor: Colors.redAccent));
//                                   }
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               child: const Text('إضافة'),
//                             )),
//                         SizedBox(
//                           height: 15,
//                         ),
//                       ],
//                     ),
//                   )),
//               bottomNavigationBar: buildBottomNavigation(height),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         });
//   }

//   Future<void> setData() async {
//     CollectionReference houses =
//         FirebaseFirestore.instance.collection('houseAccount');
//     for (int i = 0; i <= num; i++) {
//       if (membersPhones[i].text != '') {
//         print('phone: ' + membersPhones[i].text);
//         print('privilege: ' + roles[i]);
//         houses.doc(widget.ID).collection('houseMember').add({
//           'memberID': membersPhones[i].text,
//           'privilege': roles[i],
//           'nickName': membersNames[i].text
//         });
//       }
//     }
//     setState(() {
//       clearText();
//     });
//   }

//   int index = 2;
//   Widget buildBottomNavigation(height) {
//     return BottomNavyBar(
//       containerHeight: height * 0.07,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       selectedIndex: index,
//       iconSize: 28,
//       onItemSelected: (index) {
//         setState(
//           () => index = index,
//         );
//         if (index == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => dashboard(
//                       ID: widget.ID,
//                     )),
//           );
//         } else if (index == 1) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => listOfDevices(
//                       ID: widget.ID,
//                     )),
//           );
//         } else if (index == 2) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => add_house_member(ID: widget.ID)),
//           );
//         }
//       },
//       items: <BottomNavyBarItem>[
//         BottomNavyBarItem(
//             icon: const Icon(Icons.bar_chart_rounded),
//             title: const Text(
//               'لوحة المعلومات',
//               textAlign: TextAlign.center,
//             ),
//             activeColor: Colors.lightBlue),
//         BottomNavyBarItem(
//           icon: const Icon(Icons.electrical_services_rounded),
//           title: const Text(
//             'الأجهزة',
//             textAlign: TextAlign.center,
//           ),
//           activeColor: Colors.lightBlue,
//         ),
//         BottomNavyBarItem(
//           icon: const Icon(Icons.people_alt_rounded),
//           title: const Text(
//             'اعضاء المنزل',
//             style: TextStyle(fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
// }

// Future<bool> exixts(String number) async {
//   bool invalidPhone = false;
//   QuerySnapshot query = await FirebaseFirestore.instance
//       .collection('userAccount')
//       .where('phone_number', isEqualTo: number)
//       .get();
//   if (query.docs.isNotEmpty) {
//     invalidPhone = true;
//   } else {
//     invalidPhone = false;
//   }

//   return invalidPhone;
// }

// class global {
//   static var index = 0;
// }







import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rashd/Dashboard/dashboard.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Devices/listOfDevices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class add_house_member extends StatefulWidget {
  final ID;
  const add_house_member({super.key, required this.ID});
  @override
  add_house_memberState createState() => add_house_memberState();
}

class add_house_memberState extends State<add_house_member> {
  int counter = 1;
  TextEditingController houseName = TextEditingController();
  TextEditingController membersPhoneNumber1 = TextEditingController();
  TextEditingController membersPhoneNumber2 = TextEditingController();
  TextEditingController membersPhoneNumber3 = TextEditingController();
  TextEditingController membersNames1 = TextEditingController();
  TextEditingController membersNames2 = TextEditingController();
  TextEditingController membersNames3 = TextEditingController();
  bool Member2 = false, Member3 = false;

  List<TextEditingController> membersPhones = [];
  List<TextEditingController> membersNames = [];
  List<bool> duplicates = [true, true, true, true, true];

  ScrollController list = ScrollController();
  String existing = '';
  String privilege_edit = 'viewer', privilege = '';
  var privilege_index = 1;
  String privilege_edit2 = 'viewer', privilege2 = '';
  var privilege_index2 = 1;
  String privilege_edit3 = 'viewer', privilege3 = '';
  var privilege_index3 = 1;

  //toggle switch
  List indexes = ['الأول', 'الثاني', 'الثالث'];
  int num = 0;

  Widget members() {
    num++;
    String place = indexes[num];
    setState(() {
      privilege_edit2 = 'viewer';
      privilege2 = 'viewer';
      privilege_index2 = 1;
    });

    return Container(
        padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
        child: Column(children: <Widget>[
          Text('  عضو المنزل $place ', textAlign: TextAlign.right),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: TextFormField(
                maxLength: 20,
                controller: membersNames1,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: ' الاسم ',
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
                  if (membersPhoneNumber1.text != '' && value == '') {
                    return 'اختر إسمًا للعضو ';
                  }
                  return null;
                },
              )),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: TextFormField(
                controller: membersPhoneNumber1,
                maxLength: 10,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: ' رقم الجوال ',
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty && value.length < 10) {
                    return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
                  }
                  return null;
                },
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                [Colors.blue],
                [Colors.blue],
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
                  print(privilege2);
                }
              },
            ),
          ),
        ]));
  }

  final _formKey = GlobalKey<FormState>();
  void clearText() {
    Member2 = false;
    Member3 = false;
    membersPhoneNumber1.clear();
    membersPhoneNumber2.clear();
    membersPhoneNumber3.clear();
    counter = 1;
    existing = '';
    privilege_edit = 'viewer';
    privilege = '';
    privilege_index = 1;
    privilege_edit2 = 'viewer';
    privilege2 = '';
    privilege_index2 = 1;
    privilege_index3 = 1;
    privilege_edit3 = 'viewer';
    privilege3 = 'viewer';
    num = 0;
  }

  @override
  void initState() {
    setState(() {
      clearText();
      privilege_index = 1;
      privilege_edit = 'viewer';
      privilege = 'viewer';
      privilege_index2 = 1;
      privilege_edit2 = 'viewer';
      privilege2 = 'viewer';
      privilege_index3 = 1;
      privilege_edit3 = 'viewer';
      privilege3 = 'viewer';
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
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ListOfHouseAccounts(),
                    //     ));
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
                        Visibility(
                            visible: Member2,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  child: TextFormField(
                                    controller: membersNames2,
                                    textAlign: TextAlign.right,
                                    maxLength: 20,

                                    decoration: InputDecoration(
                                      hintText: 'الاسم',
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  child: TextFormField(
                                    controller: membersPhoneNumber2,
                                    maxLength: 10,
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'رقم الهاتف',
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 15),
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
                                    initialLabelIndex: privilege_index2,
                                    cornerRadius: 100.0,
                                    activeFgColor: const Color.fromARGB(
                                        255, 255, 255, 255),
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
                                        privilege_index2 = 0;
                                        privilege_edit2 = 'editor';
                                        setState(() {
                                          privilege2 = 'editor';
                                        });
                                        print('switched to: editor');
                                        print(privilege2);
                                      } else {
                                        privilege_index2 = 1;
                                        privilege_edit2 = 'viewer';
                                        setState(() {
                                          privilege2 = 'viewer';
                                        });
                                        print('switched to: viewer');
                                        print(privilege2);
                                      }
                                    },
                                  ),
                                )),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Member3 = false;
                                        membersNames2.text = '';
                                        membersNames2.text = '';
                                        privilege_edit2 = 'viewer';
                                        privilege2 = '';
                                        privilege_index2 = 1;
                                      });
                                    },
                                    icon: Icon(Icons.delete)),
                              ],
                            )),
                        Visibility(
                            visible: Member3,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  child: TextFormField(
                                    controller: membersNames3,
                                    textAlign: TextAlign.right,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      hintText: 'الاسم',
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0)),
                                    ),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  child: TextFormField(
                                    controller: membersPhoneNumber3,
                                    maxLength: 10,
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'رقم الهاتف',
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 15),
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
                                    initialLabelIndex: privilege_index3,
                                    cornerRadius: 100.0,
                                    activeFgColor: const Color.fromARGB(
                                        255, 255, 255, 255),
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
                                        privilege_index3 = 0;
                                        privilege_edit3 = 'editor';
                                        setState(() {
                                          privilege3 = 'editor';
                                        });
                                        print('switched to: editor');
                                        print(privilege3);
                                      } else {
                                        privilege_index3 = 1;
                                        privilege_edit3 = 'viewer';
                                        setState(() {
                                          privilege3 = 'viewer';
                                        });
                                        print('switched to: viewer');
                                        print(privilege3);
                                      }
                                    },
                                  ),
                                )),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Member3 = false;
                                        membersNames3.text = '';
                                        membersNames3.text = '';
                                        privilege_edit3 = 'viewer';
                                        privilege3 = '';
                                        privilege_index3 = 1;
                                      });
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            )),
                        Visibility(
                          visible: counter < 3,
                          child: TextButton(
                            style: const ButtonStyle(
                              alignment: Alignment.centerRight,
                            ),
                            onPressed: () {
                              if (Member2 == false) {
                                setState(() {
                                  Member2 = true;
                                });
                              } else if (Member3 == false) {
                                setState(() {
                                  Member3 = true;
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                          ' لقد وصلت للحد الأقصى لعدد الافراد المضافين في المرة الواحدة',
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.green));
                              }
                            },
                            child: const Text(
                              ' إضافة عضو آخر',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
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
                                existing = '';
                                bool flag = true;
                                if (!_formKey.currentState!.validate()) {
                                } else {
                                  String ErorrMes = 'العضو :';
                                  if (await exixts(membersPhoneNumber1.text)) {
                                    flag = false;
                                    ErorrMes = ' الأول،';
                                  }
                                  if (Member2 &&
                                      await exixts(membersPhoneNumber2.text)) {
                                    flag = false;
                                    ErorrMes = ' الثاني،';
                                  }
                                  if (Member3 &&
                                      await exixts(membersPhoneNumber3.text)) {
                                    flag = false;
                                    ErorrMes = ' الثالث،';
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
                                    existing += ' غير موجود بالنظام';
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                              existing,
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
      'memberID': membersPhoneNumber1.text,
      'privilege': privilege,
      'nickName': membersNames1.text
    });

    if (Member2) {
      houses.doc(widget.ID).collection('houseMember').add({
        'memberID': membersPhoneNumber2.text,
        'privilege': privilege2,
        'nickName': membersNames2.text
      });
    }
    if (Member3) {
      houses.doc(widget.ID).collection('houseMember').add({
        'memberID': membersPhoneNumber3.text,
        'privilege': privilege3,
        'nickName': membersNames3.text
      });
    }
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
                      ID: widget.ID,
                    )),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => listOfDevices(
                      ID: widget.ID,
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

class global {
  static var index = 0;
}
