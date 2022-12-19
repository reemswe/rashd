import 'dart:core';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Devices/listOfDevices.dart';
import 'add_house_member.dart';
import 'list_of_house_accounts.dart';

class dashboard extends StatefulWidget {
  final houseID;
  const dashboard({super.key, required this.houseID});

  @override
  State<dashboard> createState() => _dashboardState();
}

Future<Map<String, dynamic>> readHouseData(var id) =>
    FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
      (DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
      },
    );

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
        future: readHouseData(widget.houseID),
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
                actions: [
                  PopupMenuButton(
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
                                  hintStyle: TextStyle(color: Colors.grey[800]),
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
                                          color:
                                              Color.fromARGB(255, 35, 129, 6))),
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
                ],
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
              body: Container(
                transformAlignment: Alignment.topRight,
                child: Column(
                    //padding: const EdgeInsets.all(20),
                    //shrinkWrap: true,
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                          child: Column(children: [
                            TextFormField(
                              readOnly: true,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: ' لوحة المعلومات',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 0, 20, 0),
                                border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                            ),
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
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide.none)),
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
                                      borderSide: const BorderSide(
                                          color: Colors.white)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide:
                                          BorderSide(color: Colors.white)),

                                  suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8, right: 0),
                                      child: InkWell(
                                        child: const Text(
                                          '300 kWh',
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              fontSize: 20,
                                              decoration:
                                                  TextDecoration.underline,
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

                                  //const Padding(
                                  //     padding: EdgeInsets.all(15),
                                  //     child: Text(
                                  //       '300 kWh',
                                  //       style: TextStyle(
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.w500),

                                  // )),
                                  //InkWell(hintText: 'حدد هدف الشهر')
                                ),
                              ))),
                      // Expanded(
                      //   child:

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildCard(text[0], width, height),
                            buildCard(text[1], width, height),
                            // GridView.builder(
                            //   itemCount: 2,
                            //   gridDelegate:
                            //       const SliverGridDelegateWithFixedCrossAxisCount(
                            //           crossAxisCount: 2,
                            //           crossAxisSpacing: 0.0,
                            //           mainAxisSpacing: 4.0),
                            //   itemBuilder: (BuildContext context, int index) {
                            //     final item = text[index];
                            //     return buildCard(item, width);
                            //   },
                            // )
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
                            // elevation: 20,
                            // borderRadius: BorderRadius.circular(30),
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                            color: Color.fromARGB(
                                                255, 98, 227, 165),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            dataSource: chartData,
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible: true),
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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => listOfDevices(
                      houseID: widget.houseID,
                    )),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    add_house_member(houseID: widget.houseID)),
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

  int index = 0;
  Widget b1uildBottomNavigation() {
    return BottomNavyBar(
      selectedIndex: 0,
      onItemSelected: (index) {
        setState(
          () => this.index = index,
        );
        if (index == 0) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const devicesList()),
          // );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const dashboard(
                      houseID: null,
                    )),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListOfHouseAccounts()),
          );
        }
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
        BottomNavyBarItem(
            icon: const Icon(Icons.holiday_village_rounded),
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
              'منازلي',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  Widget buildCard(List content, width, height) {
    return Container(
        decoration: BoxDecoration(
            // color: Colors.white,
            color: content[3],
            // borderRadius: BorderRadius.circular(17.0),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 30, color: Colors.black45, spreadRadius: -10)
            ],
            borderRadius: BorderRadius.circular(20)),
        width: width * 0.44,
        height: height * 0.15,
        // padding: const EdgeInsets.fromLTRB(6, 5, 2, 9),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        //color: content[3],
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
