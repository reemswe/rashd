import 'dart:core';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class listOfDevices extends StatefulWidget {
  const listOfDevices({super.key});

  @override
  State<listOfDevices> createState() => listOfDevicesState();
}

class listOfDevicesState extends State<listOfDevices> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البيت',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // leading: //Icon(Icons.more_vert)
        // PopupMenuButton(
        //   onSelected: (value) {
        //     if (value == 'share') {
        //       showDialog(
        //         context: context,
        //         builder: (ctx) => AlertDialog(
        //           title: const Text(
        //             "مشاركة لوحة المعلومات",
        //             textAlign: TextAlign.center,
        //           ),
        //           content: const Text(
        //             'رجاء ادخل رقم جوال لمشاركة لوحة المعلومات',
        //             textAlign: TextAlign.right,
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
        //             textAlign: TextAlign.center,
        //           ),
        //           content: const Text(
        //             "هل أنت متأكد من حذف حساب المنزل ؟",
        //             textAlign: TextAlign.right,
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.arrow_forward_ios),
        //     onPressed: () {
        //       // clearForm();
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ],

        elevation: 105,
      ),
      body: Column(children: [
        SizedBox(height: height * 0.01),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Text(
                    "قائمة الأجهزة",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: IconButton(
                    iconSize: 33,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => {},//add_device(),
                      //         ));
                    },
                  )),
            ]),
        buildDevicesList(),
      ]),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildDevicesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("houseAccount")
          .doc('ffDQbRQQ8k9RzlGQ57FL')
          .collection('houseDevices')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var devices = snapshot.data;
          return GridView.builder(
            shrinkWrap: true,
            itemCount: devices!.size,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15),
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                  child: InkWell(
                onTap: () {},
                // => showModalBottomSheet(
                //     isScrollControlled: true,
                //     backgroundColor: Colors.transparent,
                //     context: context,
                //     builder: (context) => buildPlace(
                //         data.docs[index]['docId'],
                //         isAdmin,
                //         data.docs[index]['status'])),
                splashColor: Colors.transparent,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                    // height: height * 0.05,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 30,
                              color: Colors.black45,
                              spreadRadius: -10)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          devices.docs[index]['name'],
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: LiteRollingSwitch(
                            value: devices.docs[index]['status'],
                            textOn: 'On',
                            textOff: 'Off',
                            colorOn: Colors.green.shade400,
                            colorOff: Colors.red.shade400,
                            iconOn: Icons.done,
                            iconOff: Icons.remove_circle_outline,
                            textOnColor: Colors.white,
                            textSize: 20.0,
                            width: 130,
                            onChanged: (bool state) {
                              FirebaseFirestore.instance
                                  .collection("houseAccount")
                                  .doc('ffDQbRQQ8k9RzlGQ57FL')
                                  .collection('houseDevices')
                                  .doc(devices.docs[index].id)
                                  .update({'status': state});
                            },
                            onTap: () {},
                            onSwipe: () {},
                            onDoubleTap: () {},
                          ),
                        ),
                      ],
                    )),
              ));
            },
          );
        }
      },
    );
  }

  Widget buildBottomNavigation() {
    return BottomNavyBar(
      selectedIndex: 0,
      onItemSelected: (index) {
        // setState(
        //   () => global.index = index,
        // );
        // if (global.index == 0) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const devicesList()),
        //   );
        // } else if (global.index == 1) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const dashboard()),
        //   );
        // } else if (global.index == 2) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const ListOfHouseAccounts()),
        //   );
        // }
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
        // BottomNavyBarItem(
        //     icon: const Icon(Icons.holiday_village_rounded),
        //     // icon: IconButton(
        //     //     icon: const Icon(Icons.holiday_village_rounded),
        //     //     onPressed: () {

        //     //       setState(
        //     //         () => this.index = index,
        //     //       );
        //     //       Navigator.push(
        //     //         context,
        //     //         MaterialPageRoute(
        //     //             builder: (context) => const ListOfHouseAccounts()),
        //     //       );
        //     //     }),
        //     title: const Text(
        //       'منازلي',
        //       textAlign: TextAlign.center,
        //     ),
        //     activeColor: Colors.lightBlue),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
