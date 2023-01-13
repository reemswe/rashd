import 'dart:core';
import 'dart:math';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uuid/uuid.dart';
import '../HouseAccount/add_house_member.dart';
import '../Dashboard/dashboard.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';

class listOfDevices extends StatefulWidget {
  final ID; //house ID
  const listOfDevices({super.key, required this.ID});

  @override
  State<listOfDevices> createState() => listOfDevicesState();
}

class listOfDevicesState extends State<listOfDevices> {
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> readHouseData(var id) =>
      FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
        (DocumentSnapshot doc) {
          return doc.data() as Map<String, dynamic>;
        },
      );

  Future<void> share(dashboardID) async {
    var uuid = Uuid();
    uuid.v1();
    var value = new Random();
    var codeNumber = value.nextInt(900000) + 100000;

    await FlutterShare.share(
        title: 'Share Dashboard',
        text:
            'لعرض لوحة المعلومات المشتركة ادخل الرمز ${codeNumber} في صفحة عرض لوحة المعلومات المشتركة',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title'); //expired

    await FirebaseFirestore.instance
        .collection('dashboard')
        .doc(dashboardID)
        .collection('sharedCode')
        .add({'dashID': dashboardID, 'code': codeNumber, 'isExpired': false});
  }

  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

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
                actions: [morePopupMenu(height, width)],
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
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: IconButton(
                            iconSize: 33,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => {},//add_device(),
                              //         ));
                              share(houseData['dashboardID']);
                            },
                          )),
                    ]),
                buildDevicesList(height),
              ]),
              bottomNavigationBar: buildBottomNavigation(height),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget morePopupMenu(height, width) {
    return PopupMenuButton(
      itemBuilder: (BuildContext bc) {
        return const [
          PopupMenuItem(
            child: Text("مشاركة لوحة المعلومات "),
            value: 'share',
          ),
          PopupMenuItem(
            child: Text("حذف حساب المنزل",
                style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
            value: 'delete',
          ),
        ];
      },
      onSelected: (value) {
        // if (value == 'share') {
        //   share();
        //   // showModalBottomSheet(
        //   //     isScrollControlled: true,
        //   //     backgroundColor: Colors.transparent,
        //   //     context: context,
        //   //     builder: (context) =>
        //   //         ShareDashboard('ffDQbRQQ8k9RzlGQ57FL', height, width));
        // }
        if (value == 'delete') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text(
                "حذف حساب المنزل",
                textAlign: TextAlign.center,
              ),
              content: const Text(
                "هل أنت متأكد من حذف حساب المنزل ؟",
                textAlign: TextAlign.right,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // pop out
                  },
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    child: const Text("حذف",
                        style:
                            TextStyle(color: Color.fromARGB(255, 164, 10, 10))),
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
                //log in ok button
              ],
            ),
          );
        }
      },
    );
  }

  Widget ShareDashboard(ID, height, width) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
          maxChildSize: 0.45,
          minChildSize: 0.45,
          initialChildSize: 0.45,
          builder: (_, controller) => Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: SingleChildScrollView(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 18, 20, 0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.01),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text(
                                          "مشاركة لوحة المعلومات",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: IconButton(
                                            color: Colors.grey.shade700,
                                            iconSize: 30,
                                            icon: const Icon(Icons.cancel),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )),
                                    ]),
                                SizedBox(height: height * 0.01),
                                const Text(
                                    'الرجاء إدخال رقم هاتف الشخص لمشاركة لوحة المعلومات ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18)),
                                SizedBox(height: height * 0.05),

                                //phone number field
                                TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 10,
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                      hintText: '05XXXXXXXX',
                                      contentPadding:
                                          EdgeInsets.only(bottom: 3),
                                      labelText: 'رقم الهاتف',
                                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "الرجاء إدخال رقم الهاتف";
                                      } else if (value.length != 10) {
                                        return "الرجاء إدخال رقم هاتف صالح";
                                      }
                                    }),
                                SizedBox(height: height * 0.03),

                                //button
                                Center(
                                    child: Container(
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
                                    style: ElevatedButton.styleFrom(
                                      fixedSize:
                                          Size(width * 0.5, height * 0.03),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        // Fluttertoast.showToast(
                                        //     msg: "This is Center Short Toast",
                                        //     toastLength: Toast.LENGTH_SHORT,
                                        //     gravity: ToastGravity.CENTER,
                                        //     timeInSecForIosWeb: 1,
                                        //     backgroundColor: Colors.red,
                                        //     textColor: Colors.white,
                                        //     fontSize: 16.0);
                                        if (await FlutterContacts
                                            .requestPermission()) {
                                          // Get all contacts (lightly fetched)
                                          List<Contact> contacts =
                                              await FlutterContacts
                                                  .getContacts();
                                          print('contacts');

                                          // Get all contacts (fully fetched)
                                          contacts =
                                              await FlutterContacts.getContacts(
                                                  withProperties: true,
                                                  withPhoto: true);
                                          print('contacts');
                                          final contact = await FlutterContacts
                                              .openExternalPick();

                                          Navigator.of(context).pop();
                                        }
                                      }
                                    },
                                    child: const Text('مشاركة'),
                                  ),
                                )),

                                ElevatedButton(
                                  onPressed: () {
                                    // if (name.text.isEmpty) {
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content: Text(
                                    //           '  الرجاء إدخال اسم للمنزل',
                                    //           textAlign: TextAlign.center,
                                    //         ),
                                    //         backgroundColor: Colors.redAccent),
                                    //   );
                                    // } else {
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content: Text(
                                    //           '  تم اضافة المنزل بنجاح',
                                    //           textAlign: TextAlign.center,
                                    //         ),
                                    //         backgroundColor: Colors.green),
                                    //   );
                                    //   // Navigator.push(
                                    //   //     context,
                                    //   //     MaterialPageRoute(
                                    //   //       builder: (context) => const ListOfHouseAccounts(),
                                    //   //     ));
                                    // }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('إنشاء'),
                                ),
                              ]),
                        ))),
              )),
    );
  }

  Widget buildDevicesList(height) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("houseAccount")
          .doc(widget.ID)
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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Text(
                              devices.docs[index]['name'],
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                              ),
                            )),
                        SizedBox(height: height * 0.02),
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
                                  .doc(widget.ID)
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

class global {
  static var index = 0;
}
