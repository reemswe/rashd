import 'dart:core';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rashd/Devices/addDevice.dart';
import 'package:rashd/Devices/device.dart';
import '../Dashboard/dashboard.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import '../HouseAccount/list_of_houseMembers.dart';
import '../functions.dart';

class ListOfDevices extends StatefulWidget {
  final houseID, userType;
  const ListOfDevices(
      {super.key, required this.houseID, required this.userType});

  @override
  State<ListOfDevices> createState() => ListOfDevicesState();
}

class ListOfDevicesState extends State<ListOfDevices> {
  @override
  void initState() {
    print(widget.userType);
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<Map<String, dynamic>>(
        future: readHouseData(widget.houseID, false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var houseData = snapshot.data as Map<String, dynamic>;
            return Scaffold(
              body: Container(
                transformAlignment: Alignment.topRight,
                child: Stack(children: [
                  Positioned(
                    bottom: height * 0,
                    top: height * -1.39,
                    left: width * 0.0001,
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
                                                   ListOfHouseAccounts(),
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
                                            widget.userType == 'owner'
                                                ? 'مالك المنزل'
                                                : (widget.userType == 'viewer'
                                                    ? 'عضو مشاهد في المنزل'
                                                    : "عضو محرر في المنزل"),
                                            style: const TextStyle(
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
                                  padding: EdgeInsets.fromLTRB(0, 15, 20, 0),
                                  child: Text(
                                    "قائمة الأجهزة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                    ),
                                  )),
                              Visibility(
                                  visible: widget.userType == 'owner' ||
                                      widget.userType == 'editor',
                                  child: Padding(
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                top: Radius.circular(105.0),
                                              )),
                                              builder: (context) => AddDevice(
                                                  ID: widget.houseID));
                                        },
                                      ))),
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
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildDevicesList(height, width) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("houseAccount")
          .doc(widget.houseID)
          .collection('houseDevices')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data!.size > 0) {
            var devices = snapshot.data;
            return Expanded(
                child: GridView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              itemCount: devices!.size,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 18),
              itemBuilder: (BuildContext context, int index) {
                var color =
                    devices.docs[index]['color'].split('(0x')[1].split(')')[0];
                int value = int.parse(color, radix: 16);
                return FutureBuilder<Map<String, dynamic>>(
                    future: getDeviceRealtimeData(
                        widget.houseID, devices.docs[index].id),
                    builder: (BuildContext context, AsyncSnapshot snapshot2) {
                      if (snapshot2.connectionState == ConnectionState.done &&
                          snapshot2.hasData) {
                        var deviceData = snapshot2.data as Map<String, dynamic>;
                        return Container(
                            height: double.infinity,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 30,
                                      color: Colors.black45,
                                      spreadRadius: -10)
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            child: GridTile(
                              header: GridTileBar(
                                // backgroundColor: Color(value),
                                title: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    deviceData['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
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
                                            houseID: widget.houseID,
                                            userType: widget.userType));
                                  },
                                  splashColor: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        height: height * 0.05,
                                        margin: const EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                          color: Color(value),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(''),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      RichText(
                                          text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '${deviceData["currCons"]}',
                                              style: const TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.w500)),
                                          const TextSpan(
                                            text: 'KWh',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      )),
                                      // Text(deviceData['status'] == 'ON'
                                      //     ? 'الاستهلاك الحالي'
                                      //     : 'آخر استهلاك تم تسجيله'),
                                      SizedBox(height: height * 0.02),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          child: controlDeviceStatus(
                                              deviceData['status'],
                                              deviceData['RealtimeID'])),
                                    ],
                                  )),
                            ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    });
              },
            ));
          } else {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.2, height * 0.18, width * 0.2, 10),
                  child: SvgPicture.asset('assets/images/noData.svg',
                      width: width * 0.6, semanticsLabel: 'House')),
              SizedBox(height: height * 0.02),
              const Text("عذرا ، هذا المنزل ليس به أجهزة.",
                  style: TextStyle(fontSize: 17))
            ]);
          }
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
                        houseID: widget.houseID,
                      )),
            );
          } else if (index == 1) {
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HouseMembers(houseId: widget.houseID)),
            );
          }
        },
        items: items);
  }
}

class global {
  static var index = 0;
}
