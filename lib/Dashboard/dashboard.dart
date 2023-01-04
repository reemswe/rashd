import 'dart:core';
import 'dart:math';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';
import '../Devices/listOfDevices.dart';
import '../HouseAccount/add_house_member.dart';
import '../HouseAccount/list_of_house_accounts.dart';
import '../Registration/welcomePage.dart';

class dashboard extends StatefulWidget {
  final ID; //house id
  final isShared;
  const dashboard({super.key, required this.ID, this.isShared = false});

  @override
  State<dashboard> createState() => _dashboardState();
}

Future<Map<String, dynamic>> readHouseData(var id) =>
    FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
      (DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
      },
    );

Future<Map<String, dynamic>> readSharedData(var dashID) =>
    FirebaseFirestore.instance.collection('dashboard').doc(dashID).get().then(
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

class _dashboardState extends State<dashboard> {
  List text = [
    [
      'فاتورة الكهرباء\n\n500.25 SR',
      '500.25 SR',
      '\t',
      Color.fromARGB(255, 181, 251, 255),
      Colors.black
    ],
    [
      'اجمالي استهلاك الطاقة\n\n150 kWh\n\n  تم بلوغ 50% من هدف الشهر',
      '150 kWh',
      'تم بلوغ 50% من هدف الشهر',
      Color.fromARGB(255, 132, 230, 255),
      Colors.white
    ]
  ];
  final List<ChartData> chartData = [
    ChartData('الثلاجة', 350),
    ChartData('المكيف', 230),
    ChartData('التلفاز', 340),
    ChartData('المايكرويف', 250),
    ChartData('الفريزر', 400)
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<Map<String, dynamic>>(
        future: widget.isShared
            ? readSharedData(widget.ID)
            : readHouseData(widget.ID),
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
                        widget.isShared ? 'null' : houseData['houseName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          height: 1,
                        ),
                      ),
                      Text(
                        widget.isShared
                            ? ''
                            : (houseData['OwnerID'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? 'مالك المنزل'
                                : "عضو في المنزل"),
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
                actions: [
                  Visibility(
                    visible: !widget.isShared,
                    child: PopupMenuButton(
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
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
                                            color: Color.fromARGB(
                                                255, 35, 129, 6))),
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
                                            color: Color.fromARGB(
                                                255, 164, 10, 10))),
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
                            value: 'share',
                            child: Text("مشاركة لوحة المعلومات "),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text("حذف حساب المنرل",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 167, 32, 32))),
                          ),
                        ];
                      },
                    ),
                  )
                ],
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (widget.isShared) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Exit Shared Dashboard?"),
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Are you sure you want to exit the shared dashboard?",
                                  textAlign: TextAlign.left,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "\n*Please note that the shared code is a one time use code.",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.left,
                                    ))
                              ]),
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
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text("خروج",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 194, 98, 98))),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.isShared
                              ? welcomePage()
                              : ListOfHouseAccounts(),
                        ));
                  },
                ),
                elevation: 1.5,
              ),
              body: Container(
                transformAlignment: Alignment.topRight,
                child: Column(children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Text('لوحة المعلومات',
                                    style: TextStyle(fontSize: 25)),
                              ),
                              Visibility(
                                  visible: !widget.isShared,
                                  child: IconButton(
                                    icon: const Icon(Icons.ios_share),
                                    onPressed: () {
                                      share(houseData['dashboardID']);
                                    },
                                  )),
                            ]),
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          alignment: Alignment.topRight,
                          child: Text('شهر نوفمبر',
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  fontWeight: FontWeight.w300)),
                        )
                      ])),
                  Container(
                      decoration:
                          BoxDecoration(border: Border(top: BorderSide.none)),
                      width: width * 0.95,
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: Material(
                          elevation: 20,
                          borderRadius: BorderRadius.circular(30),
                          child: TextFormField(
                            readOnly: true,
                            maxLines: 4,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                  padding: EdgeInsets.only(right: 30),
                                  child: Text(
                                    'الهدف الإجمالي لإستهلاك الطاقة',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 20),
                                  )),
                              hintStyle: const TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 17, 184, 97),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 5, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white)),
                              suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 8, right: 0),
                                  child: InkWell(
                                    child: const Text(
                                      '300 kWh',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          fontSize: 20,
                                          decoration: TextDecoration.underline,
                                          color: Colors.green),
                                    ),
                                    onTap: () {
                                      // navigate to set goal or popup window
                                      // Navigator.push(

                                      // context,
                                      // MaterialPageRoute(
                                      //     builder: (context) => const Goal()),
                                      // );
                                    },
                                  )),
                            ),
                          ))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildCard(text[0], width, height),
                        buildCard(text[1], width, height),
                      ]),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 30,
                                color: Colors.black45,
                                spreadRadius: -10)
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Material(
                        child: TextFormField(
                          readOnly: true,
                          maxLines: 6,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            labelText: 'استهلاك الطاقة لكل جهاز',
                            hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 100, 100, 100)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 5, 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(color: Colors.white)),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                      title: AxisTitle(text: 'Devices')),
                                  primaryYAxis: NumericAxis(
                                      title: AxisTitle(text: 'kWh')),
                                  series: <ChartSeries<ChartData, String>>[
                                    // Renders column chart
                                    ColumnSeries<ChartData, String>(
                                        color:
                                            Color.fromARGB(255, 98, 227, 165),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        dataSource: chartData,
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: true),
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                  ]),
                            ),
                          ),
                        ),
                      ))
                ]),
              ),
              bottomNavigationBar: buildBottomNavigation(height),
            );
          } else {
            return Text('');
          }
        });
  }

  Widget buildBottomNavigation(height) {
    return Visibility(
        visible: !widget.isShared,
        child: BottomNavyBar(
          containerHeight: height * 0.07,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          selectedIndex: index,
          iconSize: 28,
          onItemSelected: (index) {
            setState(
              () => index = index,
            );
            if (index == 0) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => dashboard(
              //             ID: widget.houseID,
              //           )),
              // );
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
        ));
  }

  int index = 0;

  Widget buildCard(List content, width, height) {
    return Container(
        decoration: BoxDecoration(
            color: content[3],
            boxShadow: const [
              BoxShadow(
                  blurRadius: 30, color: Colors.black45, spreadRadius: -10)
            ],
            borderRadius: BorderRadius.circular(20)),
        width: width * 0.44,
        height: height * 0.15,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: GridTile(
          child: Center(
              child: Text(
            content[0],
            textAlign: TextAlign.center,
            style: TextStyle(color: content[4], fontWeight: FontWeight.w600),
          )),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
