import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import '../HouseAccount/list_of_houseMembers.dart';
import '../Registration/welcomePage.dart';

class dashboard extends StatefulWidget {
  final ID; //dash id
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

var sharedHouseName = '';
Future<Map<String, dynamic>> readSharedData(var dashID) =>
    FirebaseFirestore.instance.collection('dashboard').doc(dashID).get().then(
      (DocumentSnapshot doc) {
        FirebaseFirestore.instance
            .collection("houseAccount")
            .doc(doc["houseID"])
            .get()
            .then((value) {
          sharedHouseName = value.data()!["houseName"];
        });
        return doc.data() as Map<String, dynamic>;
      },
    );

Future<void> share(dashboardID) async {
  var uuid = const Uuid();
  uuid.v1();
  var value = new Random();
  var codeNumber = value.nextInt(900000) + 100000;

  await FlutterShare.share(
    title: 'مشاركة لوحة المعلومات',
    text:
        'لعرض لوحة المعلومات المشتركة ادخل الرمز ${codeNumber} في صفحة عرض لوحة المعلومات المشتركة',
  ); //expired

  await FirebaseFirestore.instance
      .collection('dashboard')
      .doc(dashboardID)
      .collection('sharedCode')
      .add({'dashID': dashboardID, 'code': codeNumber, 'isExpired': false});
}

class _dashboardState extends State<dashboard> {
  List months = [
    '',
    'يناير',
    'فبراير',
    'مارس',
    'ابريل',
    'مايو',
    'يونيو',
    'يوليو',
    'اغسطس',
    'سبتمبر',
    'نوفمبر',
    'اكتوبر',
    'ديسمبر'
  ];

  Future<void>? energy;
  Future? data;
  final _formKey = GlobalKey<FormState>();
  List? devices = [];
  List text = [
    [
      'فاتورة الكهرباء',
      '500.25SR',
      '\t',
      Colors.lightBlue.shade500,
      Colors.white,
      Color(0xff81D4FA),
    ],
    [
      'إجمالي استهلاك الطاقة',
      '150kWh',
      'تم بلوغ 50% من هدف الشهر',
      Colors.lightBlue.shade200,
      Colors.white,
      Colors.lightBlue.shade100,
    ]
  ];
  List<ChartData> chartData = [];

  int i = 0;
  var date = DateTime.now();
  var formatted = '';
  TextEditingController goalController = TextEditingController();
  String houseName = '';
  String houseID = '';
  double electricityBill = 0;
  double percentage = 0;
  double energyFromBill = 0;
  @override
  void initState() {
    setState(() {
      data = getData();
      // global.index = 2;
      int index = date.month;
      formatted = months[index];
      FirebaseFirestore.instance
          .collection("dashboard")
          .doc(widget.ID)
          .get()
          .then((value) {
        print("Dashboard ID : " + widget.ID);
        houseID = value.data()!["houseID"];
        userGoal = value.data()!["userGoal"];
        energy = totalEnergy();
        FirebaseFirestore.instance
            .collection("houseAccount")
            .doc(houseID)
            .get()
            .then((value) {
          houseName = value.data()!["houseName"];
          print('houseName: $houseName');
          double electricityBill = 0;
          double energyFromBill = 0;
        });
      });
    });

    super.initState();
  }

  String userGoal = '';
  int total = 0;

  @override
  Widget build(BuildContext context) {
    calculateBill(6000);
    calculateEnergy(1080);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    List text2 = [
      [
        'فاتورة الكهرباء',
        '${electricityBill}SR',
        '*الفاتورة تشمل ضريبة القيمة المضافة',
        Colors.lightBlue.shade500,
        Colors.white,
        Color(0xff81D4FA),
      ],
      [
        'إجمالي استهلاك الطاقة',
        '${energyFromBill}kWh',
        'تم بلوغ ${percentage}% من هدف الشهر',
        Colors.lightBlue.shade200,
        Colors.white,
        Colors.lightBlue.shade100,
      ]
    ];
    var LRPadding = width * 0.025;

    return FutureBuilder<Map<String, dynamic>>(
        future: widget.isShared
            ? readSharedData(widget.ID)
            : readHouseData(houseID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var houseData = snapshot.data as Map<String, dynamic>;
            return Scaffold(
              body: Container(
                transformAlignment: Alignment.topRight,
                child: Stack(children: [
                  Positioned(
                    bottom: height * 0,
                    top: height * -1.1,
                    left: width * 0.1,
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
                  ListView(children: [
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
                                    if (widget.isShared) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text(
                                              "الخروج من لوحة المعلومات؟"),
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                  "هل أنت متأكد أنك تريد الخروج من لوحة المعلومات المشتركة؟",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      "\n*يرجى ملاحظة أن الرمز المشترك يستخدم مرة واحدة.",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ))
                                              ]),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                // Navigator.of(ctx).pop();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const welcomePage()));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text("خروج",
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
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text("إلغاء"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ListOfHouseAccounts(),
                                          ));
                                    }
                                  },
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.isShared
                                            ? sharedHouseName
                                            : houseData['houseName'],
                                        style: const TextStyle(
                                          letterSpacing: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          height: 1,
                                        ),
                                      ),
                                      Visibility(
                                          visible: !widget.isShared,
                                          child: Text(
                                            widget.isShared
                                                ? ''
                                                : (houseData['OwnerID'] ==
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
                                          ))
                                    ])
                              ]),
                            ])),
                    Container(
                        padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                        child: Column(children: [
                          Row(children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text('لوحة المعلومات',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                            ),
                            SizedBox(width: width * 0.02),
                            Container(
                              width: width * 0.2,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.lightBlue.shade100,
                              ),
                              alignment: Alignment.center,
                              child: Text(formatted,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      height: 1,
                                      fontWeight: FontWeight.w300)),
                            ),
                            SizedBox(width: width * 0.26),
                            Visibility(
                                visible: !widget.isShared,
                                child: IconButton(
                                  icon: const Icon(Icons.ios_share),
                                  onPressed: () {
                                    share(houseData['dashboardID']);
                                  },
                                )),
                          ]),
                        ])),
                    Stack(children: [
                      FutureBuilder(
                          future: goal(),
                          builder: (context, snapshot) {
                            return Container(
                                decoration: const BoxDecoration(
                                    border: Border(top: BorderSide.none)),
                                padding: EdgeInsets.fromLTRB(
                                    LRPadding, height * 0.01, LRPadding, 0),
                                child: Material(
                                    elevation: 20,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.01,
                                            height * 0.035,
                                            width * 0.01,
                                            height * 0.035),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                'الهدف الإجمالي لإستهلاك الطاقة',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Text(
                                                '$userGoal kWh',
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    // decoration: TextDecoration
                                                    //     .underline,
                                                    color: Colors.green),
                                              ),
                                            ]))));
                          }),
                      Visibility(
                          visible: !widget.isShared,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0, height * 0.08, width * 0.02, 0),
                              child: FloatingActionButton(
                                  backgroundColor: Colors.lightGreen,
                                  child: const Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return dialog(
                                              formatted, height, width);
                                        });
                                  })))
                    ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: width * 0.025),
                          buildCard(text2[0], width, height),
                          SizedBox(width: width * 0.025),
                          buildCard(text2[1], width, height),
                          SizedBox(width: width * 0.025),
                        ]),
                    FutureBuilder(
                        future: data,
                        builder: (context, snapshot) {
                          return Container(
                              margin: EdgeInsets.fromLTRB(
                                  LRPadding, 0, LRPadding, 12),
                              // padding: EdgeInsets.fromLTRB(width * 0.01,
                              //     height * 0.02, width * 0.05, height * 0.02),
                              child: Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(30),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.01,
                                        height * 0.02,
                                        width * 0.01,
                                        height * 0.02),
                                    child: Stack(children: <Widget>[
                                      Text(
                                        'الأجهزة الأعلى استهلاكًا للطاقة',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 62, 62, 62)),
                                      ),
                                      SizedBox(height: height * 0.0),
                                      SfCartesianChart(
                                          primaryXAxis: CategoryAxis(
                                              title:
                                                  AxisTitle(text: 'الأجهزة')),
                                          primaryYAxis: NumericAxis(
                                              title: AxisTitle(text: 'kWh')),
                                          series: <
                                              ChartSeries<ChartData, String>>[
                                            ColumnSeries<ChartData, String>(
                                                color: const Color.fromARGB(
                                                    255, 98, 227, 165),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4)),
                                                dataSource: chartData,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        isVisible: true),
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y),
                                          ])
                                    ]),
                                  ),
                                ),
                              ));
                        }),
                  ]),
                ]),
              ),
            );
          } else {
            return const Text('');
          }
        });
  }

  Widget buildCard(List content, width, height) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 1.0],
                colors: [content[3], content[5]]),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 8.0)
            ],
            borderRadius: BorderRadius.circular(20)),
        // width: width * 0.44,
        height: height * 0.15,
        padding: EdgeInsets.fromLTRB(
            width * 0.02, height * 0.01, width * 0.02, height * 0.01),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: GridTile(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Text(
                content[0],
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: content[4],
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              Center(
                  child: Text(
                content[1],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: content[4],
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )),
              Text(
                content[2],
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: content[4],
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ])));
  }

  contentBox(context, formatted, height, width) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: width * 0.02,
              top: height * 0.08,
              right: width * 0.02,
              bottom: height * 0.05),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 41, 41, 41),
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'حدد هدف استهلاك الطاقة لشهر ' + formatted,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                  padding:
                      EdgeInsets.fromLTRB(width * 0.02, 0, width * 0.02, 0),
                  child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: goalController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            hintText: '300kWh',
                            prefixText: 'kWh',
                            prefixStyle: TextStyle(color: Colors.black)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء تحديد الهدف';
                          } else {
                            return null;
                          }
                        },
                      ))),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(width * 0.2, height * 0.05),
                          backgroundColor: Colors.lightGreen),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            goal();
                          });
                          UpdateDB();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'تحديد',
                        style: TextStyle(fontSize: 18),
                      )),
                  const SizedBox(
                    height: 10,
                    width: 30,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(width * 0.2, height * 0.05),
                          backgroundColor: Colors.redAccent),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 27,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: Image.asset(
                  'lib/icons/goal.png',
                  width: 150,
                  height: 120,
                )),
          ),
        ),
      ],
    );
  }

  Widget dialog(formatted, height, width) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, formatted, height, width),
    );
  }

  Future<void> goal() async {
    await FirebaseFirestore.instance
        .collection("dashboard")
        .doc(widget.ID)
        .get()
        .then((value) {
      userGoal = value.data()!["userGoal"];
      print('user goal: $userGoal');
    });
  }

  Future<void> UpdateDB() async {
    var Edit_info =
        FirebaseFirestore.instance.collection('dashboard').doc(widget.ID);
    Edit_info.update({
      'userGoal': goalController.text,
    });
  }

  Future<void> totalEnergy() async {
    String percentageStr = '';
    var collection = await FirebaseFirestore.instance
        .collection('dashboard')
        .doc(widget.ID)
        .collection('dashboard_readings');
    collection.snapshots().listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        var fooValue = data['energy_consumption']; // <-- Retrieving the value.
        setState(() {
          total += int.parse(fooValue);
        });
      }
      print('i: $i and total: $total');
      total = total - i;
      print('t0tal after: $total');
      setState(() {
        percentageStr =
            ((total / int.parse(userGoal)) * 100).toStringAsFixed(1);
        text[1][1] = '${total}kWh';
        percentage = (total / int.parse(userGoal)) * 100;
        i = total;
      });
      print('i after: $i');
    });
  }

  Future getData() async {
    var collection = await FirebaseFirestore.instance
        .collection('houseAccount')
        // .doc(houseID)
        .doc('12Tk9jBwrDGhYe2Yjzrl')
        .collection('houseDevices');

    // to get data from all documents sequentially
    collection.snapshots().listen((querySnapshot) {
      chartData.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data(); // <-- Retrieving the value.
        setState(() {
          devices!.add([
            {'name': data['name'], 'consumption': data['consumption']}
          ]);
          String name = data['name'];
          double consum = double.parse(data['consumption'].toString());
          chartData.add(ChartData(name, consum));

          print("name: $name consum: $consum");
        });
      }
      chartData.sort((a, b) => b.y.compareTo(a.y));
      chartData = chartData.take(10).toList();
      chartData.shuffle();
      print(chartData.take(20));
    });
    // print(membersList);
    return devices;
  }

  //calculate electricity bill for 30 days
//بدون رسوم خدمة العداد
  void calculateBill(double energy) {
    double slat_1 = 0;
    double slat_2 = 0;
    if (energy > 6000) {
      slat_1 = 6000 * 0.18;
      slat_2 = (energy - 6000) * 0.30;
    } else {
      slat_1 = energy * 0.18;
    }
    setState(() {
      electricityBill = (slat_1 + slat_2) * 1.15;
      electricityBill.toInt();
      print(electricityBill);
    });
  }
//calculate energy from electricity bill

  void calculateEnergy(double bill) {
    double slat_1 = 0;
    double slat_2 = 0;
    //double energy = 0;
    if (bill > 1080) {
      slat_1 = 6000; // 1080/0.18
      slat_2 = (bill - 1080) / 0.30;
    } else {
      slat_1 = bill / 0.18;
    }
    setState(() {
      energyFromBill = (slat_1 + slat_2);
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
