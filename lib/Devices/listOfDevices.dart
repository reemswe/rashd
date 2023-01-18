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

  var dashID;

  Future<Map<String, dynamic>> readHouseData(var id) =>
      FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
        (DocumentSnapshot doc) {
          return doc.data() as Map<String, dynamic>;
        },
      );

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
            dashID = houseData['dashboardID'];
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
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
                      ID: dashID,
                    )),
          );
        } else if (index == 1) {
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
