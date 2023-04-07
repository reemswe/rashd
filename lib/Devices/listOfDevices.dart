import 'dart:core';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rashd/Devices/addDevice.dart';
import 'package:rashd/Devices/device.dart';
import '../Dashboard/dashboard.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import '../HouseAccount/list_of_houseMembers.dart';
import 'package:firebase_database/firebase_database.dart';

import '../functions.dart';

class listOfDevices extends StatefulWidget {
  final ID; //house ID
  const listOfDevices({super.key, required this.ID});

  @override
  State<listOfDevices> createState() => listOfDevicesState();
}

Future<void> updateDeviceStatus(value, deviceID) async {
  final database = FirebaseDatabase.instance.ref('devicesList/${deviceID}/');

  await database
      .update({'status': value})
      .then(
        (value) => print("va!lue"),
      )
      .onError((error, stackTrace) => print(error));
}

class listOfDevicesState extends State<listOfDevices> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

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
              body: Container(
                transformAlignment: Alignment.topRight,
                child: Stack(children: [
                  Positioned(
                    bottom: height * 0,
                    top: height * -1.4,
                    left: width * 0.01,
                    child: Container(
                      width: width * 1.5,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.lightBlue.shade200, Colors.blue]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.shade100,
                                offset: const Offset(4.0, 4.0),
                                blurRadius: 10.0)
                          ]),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.02),
                        Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.01, 5, width * 0.05, 5),
                            child: Wrap(
                                direction: Axis.vertical,
                                spacing: 1,
                                children: <Widget>[
                                  SizedBox(height: height * 0.02),
                                  Row(children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back_ios),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListOfHouseAccounts(),
                                            ));
                                      },
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            houseData['houseName'],
                                            style: const TextStyle(
                                              letterSpacing: 1.2,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              height: 1,
                                            ),
                                          ),
                                          Text(
                                            (houseData['OwnerID'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? 'مالك المنزل'
                                                : "عضو في المنزل"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              height: 1,
                                            ),
                                          ),
                                        ])
                                  ]),
                                ])),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: IconButton(
                                    iconSize: 33,
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          enableDrag: false,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                            top: Radius.circular(105.0),
                                          )),
                                          builder: (context) =>
                                              AddDevice(ID: widget.ID));
                                    },
                                  )),
                            ]),
                        buildDevicesList(height, width),
                      ]),
                ]),
              ),
              bottomNavigationBar: buildBottomNavigation(
                  height,
                  houseData['OwnerID'] ==
                      FirebaseAuth.instance.currentUser!.uid),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildDevicesList(height, width) {
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
        } else if (snapshot.hasData) {
          var devices = snapshot.data;
          return Expanded(
              child: GridView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            shrinkWrap: true,
            itemCount: devices!.size,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15),
            itemBuilder: (BuildContext context, int index) {
              var color =
                  devices.docs[index]['color'].split('(0x')[1].split(')')[0];
              int value = int.parse(color, radix: 16);
              return GridTile(
                  child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      backgroundColor: Colors.transparent,
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(105.0),
                      )),
                      builder: (context) => Device(
                          deviceID: devices.docs[index].id,
                          houseID: widget.ID));
                },
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Text(
                                    devices.docs[index]['name'],
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                    ),
                                  )),
                              Container(
                                // margin: EdgeInsets.only(left: width * 0.56),
                                width: width * 0.12,
                                // height: height * 0.05,

                                padding: EdgeInsets.only(
                                    top: height * 0.008,
                                    bottom: height * 0.008),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(value)),
                                alignment: Alignment.center,
                                child: Text(''),
                              ),
                            ]),
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
                            textSize: 16.0,
                            width: 100,
                            onChanged: (bool state) async {
                              FirebaseFirestore.instance
                                  .collection("houseAccount")
                                  .doc(widget.ID)
                                  .collection('houseDevices')
                                  .doc(devices.docs[index].id)
                                  .update({'status': state});

                              await updateDeviceStatus(
                                  state ? "ON" : "OFF", devices.docs[index].id);
                            },
                            onTap: () {},
                            onSwipe: () {},
                            onDoubleTap: () {},
                          ),
                        ),
                        // Text(data.consumption),
                      ],
                    )),
              ));
            },
          ));
        } else {
          return Text("No data");
        }
      },
    );
  }

  int index = 1;
  Widget buildBottomNavigation(height, isOwner) {
    var items = isOwner
        ? <BottomNavyBarItem>[
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
          ]
        : <BottomNavyBarItem>[
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
          ];
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
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HouseMembers(houseId: widget.ID)),
            );
          }
        },
        items: items);
  }
}

class global {
  static var index = 0;
}
