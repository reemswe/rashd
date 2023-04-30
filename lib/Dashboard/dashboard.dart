// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:core';
import 'dart:math';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';
import '../Devices/listOfDevices.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import '../HouseAccount/list_of_houseMembers.dart';
import '../Registration/welcomePage.dart';
import '../functions.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_test/flutter_test.dart';

class dashboard extends StatefulWidget {
  var firestore, auth, realDB;

  final houseID;
  final isShared;

  dashboard(
      {super.key,
      required this.houseID,
      this.firestore = null,
      this.realDB = null,
      this.auth = null,
      this.isShared = false});

  @override
  State<dashboard> createState() => DashboardState();
}

class DashboardState extends State<dashboard> {
  var deviceRealtimeID = '';
  Future<void> share() async {
    var uuid = const Uuid();
    uuid.v1();
    var value = new Random();
    var codeNumber = value.nextInt(900000) + 100000;

    await FlutterShare.share(
      title: 'مشاركة لوحة المعلومات',
      text:
          'لعرض لوحة المعلومات المشتركة ادخل الرمز ${codeNumber} في صفحة عرض لوحة المعلومات المشتركة',
    );

    await widget.firestore
        .collection('houseAccount')
        .doc(widget.houseID)
        .collection('sharedCode')
        .add({
      'houseID': widget.houseID,
      'code': codeNumber,
      'isExpired': false
    });
  }

  //! FCM
  var fcmToken;
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      setState(() {
        fcmToken = token;
      });
      await FirebaseFirestore.instance
          .collection('userAccount')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));
    });

    await FirebaseMessaging.instance.onTokenRefresh
        .listen((String token) async {
      await FirebaseFirestore.instance
          .collection('userAccount')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));
    });
  }

  List months = [
    '',
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر'
  ];

  final _formKey = GlobalKey<FormState>();
  List energyData = [
    [
      'فاتورة الكهرباء',
      '0SR',
      '*الفاتورة تشمل ضريبة القيمة المضافة',
      Colors.lightBlue.shade500,
      Colors.white,
      const Color(0xff81D4FA),
    ],
    [
      'إجمالي استهلاك الطاقة',
      '0kWh',
      'تم بلوغ % من هدف الشهر',
      Colors.lightBlue.shade200,
      Colors.white,
      Colors.lightBlue.shade100,
    ]
  ];
  List<ChartData> chartData = [];
  int i = 0;

  var month = '';
  TextEditingController goalController = TextEditingController();
  double electricityBill = 0;
  double percentage = 0;
  double energyFromBill = 0;
  DateTime? _selected;

  @override
  void initState() {
    if (!TestWidgetsFlutterBinding.ensureInitialized().inTest) {
      widget.firestore = FirebaseFirestore.instance;
      widget.auth = FirebaseAuth.instance;
      widget.realDB = FirebaseDatabase.instance;
      if (!widget.isShared) {
        getToken();
      }
    }
    super.initState();
    getGoal();
    month = months[DateTime.now().month];
    getData();
  }

  Future<String> getUserType() async {
    var userType = '';
    QuerySnapshot<Map<String, dynamic>> query;

    if (!widget.isShared) {
      await widget.firestore
          .collection('houseAccount')
          .doc(widget.houseID)
          .get()
          .then((DocumentSnapshot doc) async {
        if (doc['OwnerID'] == widget.auth.currentUser!.uid) {
          userType = 'owner';
          return 'owner';
        } else {
          query = await widget.firestore
              .collection('houseAccount')
              .doc(widget.houseID)
              .collection('houseMember')
              .get();

          for (var doc in query.docs) {
            if (doc['memberID'] == widget.auth.currentUser!.uid) {
              userType = doc['privilege'];
            }
          }
        }
      });
    }
    return userType;
  }

  double total = 0;
  double usergoal = 1;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    var LRPadding = width * 0.025;

    return FutureBuilder<String>(
        future: getUserType(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var userType = snapshot.data;
            print('userType $userType');

            return Scaffold(
              body: FutureBuilder<Map<String, dynamic>>(
                  future: readHouseData(
                      widget.houseID, widget.isShared, widget.firestore),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var houseData = snapshot.data as Map<String, dynamic>;
                      return Container(
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
                                  gradient: LinearGradient(colors: [
                                    Colors.lightBlue.shade200,
                                    Colors.blue
                                  ]),
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
                                          icon:
                                              const Icon(Icons.arrow_back_ios),
                                          color: Colors.white,
                                          onPressed: () {
                                            if (widget.isShared) {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                      "الخروج من لوحة المعلومات؟"),
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        Text(
                                                          "هل أنت متأكد أنك تريد الخروج من لوحة المعلومات المشتركة؟",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              "\n*يرجى ملاحظة أن الرمز المشترك يستخدم مرة واحدة.",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ))
                                                      ]),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.uid ==
                                                            null) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const welcomePage()));
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ListOfHouseAccounts()));
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child: const Text(
                                                            "خروج",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        194,
                                                                        98,
                                                                        98))),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child:
                                                            const Text("إلغاء"),
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
                                                        ListOfHouseAccounts(),
                                                  ));
                                            }
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
                                                widget.isShared
                                                    ? 'عضو زائر'
                                                    : (userType == 'owner'
                                                        ? 'مالك المنزل'
                                                        : (userType == 'viewer'
                                                            ? 'عضو مشاهد في المنزل'
                                                            : "عضو محرر في المنزل")),
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
                            Container(
                                padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                child: Column(children: [
                                  Row(children: [
                                    // const Padding(
                                    //   padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    //   child: Text('لوحة المعلومات',
                                    //       style: TextStyle(
                                    //           fontSize: 25,
                                    //           color: Colors.white)),
                                    // ),
                                    // SizedBox(width: width * 0.02),
                                    // Container(
                                    //     width: width * 0.2,
                                    //     padding: const EdgeInsets.all(3),
                                    //     decoration: BoxDecoration(
                                    //       borderRadius:
                                    //           BorderRadius.circular(30),
                                    //       color: Colors.lightBlue.shade100,
                                    //     ),
                                    //     alignment: Alignment.center,
                                    //     child:
                                    //         //month
                                    //         InkWell(
                                    //       onTap: (() {
                                    //         _onPressed(
                                    //             context: context, locale: 'ar');
                                    //       }),
                                    //       child: Text(month,
                                    //           style: const TextStyle(
                                    //               fontSize: 16,
                                    //               color: Colors.blue,
                                    //               height: 0,
                                    //               fontWeight: FontWeight.w300)),
                                    //     )),
                                    // SizedBox(width: width * 0.26),
                                    // Visibility(
                                    //     visible: userType == 'owner',
                                    //     child: IconButton(
                                    //       icon: const Icon(Icons.ios_share),
                                    //       onPressed: () {
                                    //         share();
                                    //       },
                                    //     )),//user367 8511
                                  ]),
                                ])),
                            Stack(children: [
                              Container(
                                  decoration: const BoxDecoration(
                                      border: Border(top: BorderSide.none)),
                                  padding: EdgeInsets.fromLTRB(
                                      LRPadding, height * 0.02, LRPadding, 0),
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
                                              const Text(
                                                'الهدف الإجمالي لإستهلاك الطاقة',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Text(
                                                '${houseData['goal']} kWh',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.green),
                                              ),
                                            ]),
                                      ))),
                              Visibility(
                                  visible: userType == 'owner',
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0, height * 0.09, width * 0.02, 0),
                                      child: FloatingActionButton(
                                          backgroundColor: Colors.lightGreen,
                                          child: const Icon(Icons.edit),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return goalDialog(
                                                      month, height, width);
                                                });
                                          })))
                            ]),
                            // Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     children: [
                            //       SizedBox(width: width * 0.025),
                            //       buildCard(energyData[0], width, height),
                            //       SizedBox(width: width * 0.025),
                            //       buildCard(energyData[1], width, height),
                            //       SizedBox(width: width * 0.025),
                            //     ]),

                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    LRPadding, 0, LRPadding, 12),
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
                                        const Text(
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
                                                  pointColorMapper:
                                                      (ChartData data, _) =>
                                                          data.color,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.y),
                                            ])
                                      ]),
                                    ),
                                  ),
                                ))
                            //     }),
                          ]),
                        ]),
                      );
                    } else {
                      return const Text("No data");
                    }
                  }),
              bottomNavigationBar: buildBottomNavigation(height, userType),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget buildBottomNavigation(
    height,
    userType,
  ) {
    var items = userType == 'owner'
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
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                activeColor: Colors.lightBlue),
            BottomNavyBarItem(
              icon: const Icon(Icons.electrical_services_rounded),
              title: const Text(
                'الأجهزة',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
              activeColor: Colors.lightBlue,
            ),
          ];

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
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListOfDevices(
                          houseID: widget.houseID, userType: userType)),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HouseMembers(houseId: widget.houseID)),
                );
              }
            },
            items: items));
  }

  int index = 0;
  Widget buildCard(List content, width, height) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 1.0],
                colors: [content[3], content[5]]),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 8.0)
            ],
            borderRadius: BorderRadius.circular(20)),
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

  Widget dialogContentBox(context, formatted, height, width) {
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
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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
                          var regExp = RegExp(
                              r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
                              "'" // <-- ' is added to the expression
                              ']');
                          if (value!.isEmpty) {
                            return 'الرجاء تحديد الهدف';
                          } else if (value.length < 3) {
                            return ' الحد الأدنى للهدف هو 100kWh';
                          } else if (regExp.hasMatch(value)) {
                            return 'الرجاءادخال رقم صحيح';
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await UpdateGoal();
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

  Widget goalDialog(formatted, height, width) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContentBox(context, formatted, height, width),
    );
  }

  Future<void> _onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      locale: localeObj,
    );

    if (selected != null) {
      setState(() {
        _selected = selected;
        print((DateFormat('yyyy-MMMM').format(selected)).toLowerCase());
        String selectedYearMonth =
            (DateFormat('yyyy-MMMM').format(selected)).toLowerCase();
        print(DateFormat.MMMM('ar').format(selected));
        month = DateFormat.MMMM('ar').format(selected);
        ubdateChart(selectedYearMonth, month);
      });
    }
  }

  Future<void> UpdateGoal() async {
    await widget.firestore
        .collection('houseAccount')
        .doc(widget.houseID)
        .update({
      'goal': goalController.text,
    });
    setState(() {
      //refreshing page for new goal & precentage
      usergoal = double.parse(goalController.text);
      percentage = (total / usergoal) * 100;
      energyData[1][2] = 'تم بلوغ ${percentage.toInt()}% من هدف الشهر';
    });
    goalController.clear();
  }

  Future ubdateChart(String selectedYearMonth, String monthar) async {
    double total = 0;

    print('(monthar = months[DateTime.now().month])');
    print(monthar);
    print(months[DateTime.now().month]);
    if (monthar == months[DateTime.now().month]) {
      setState(() {
        getData();
      });
    } else {
      int value = 0;
      String name = '';
      double monthlyCons = 0;
      String deviceID = '';
      chartData.clear();

      //get devices name,color,id
      var collection = await widget.firestore
          .collection('houseAccount')
          .doc(widget.houseID)
          .collection('houseDevices');

      collection.snapshots().listen(((querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          print('==================hd=====================');
          Map<String, dynamic> data = doc.data();
          print(data);
          print(data['name']);
          name = data['name'];
          var color = data['color'].split('(0x')[1].split(')')[0];
          value = int.parse(color, radix: 16);
          print(doc.id);
          deviceID = data['ID'];

          monthlyCons = await getMonthlyConsumption(
            deviceID,
            selectedYearMonth,
          );

          setState(() {
            total += monthlyCons;
            chartData.add(ChartData(name, monthlyCons, Color(value)));
          });
        }
        setState(() {
          energyData[1][1] = '${total}kWh';
          calculateBill(total.toDouble());
          String e = electricityBill.toStringAsFixed(2);
          energyData[0][1] = '${e}SR';
          //remove precentae
          energyData[1][2] = '';
        });
      }));
    } //end of else
  }

  Future<double> getGoal() async {
    double goal = 0;
    await widget.firestore
        .collection('houseAccount')
        .doc(widget.houseID)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print(doc.data());
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        print('====================goal===================');
        print(data['goal']);
        goal = double.parse(data['goal'].toString());
      }
    });
    setState(() {
      usergoal = goal;
    });
    return goal;
  }

  Future getData() async {
    var collection = await widget.firestore
        .collection('houseAccount')
        .doc(widget.houseID)
        .collection('houseDevices');
    // to get data from all documents sequentially
    collection.snapshots().listen((querySnapshot) async {
      chartData.clear();
      total = 0;
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data(); // <-- Retrieving the value.
        //get id,name,color from firestore
        String deviceID = data['ID'];
        var color = data['color'].split('(0x')[1].split(')')[0];
        String name = data['name'];
        int value = int.parse(color, radix: 16);
        double consum = 0;

        consum = await getCurrentConsumption(deviceID, widget.realDB);
        // setState(() {
        total += consum;
        chartData.add(ChartData(name, consum, Color(value)));
        print('================precentage==================');
        print((total / usergoal) * 100);
        // });
      }
      print('usergoal');
      print(usergoal);
      //set total consumption and bill
      // setState(() {
      energyData[1][1] = '${total.toStringAsFixed(2)}kWh';
      percentage = (total / usergoal) * 100;
      //  i = total;
      energyData[1][2] = 'تم بلوغ ${percentage.toInt()}% من هدف الشهر';
      calculateBill(total.toDouble());
      String e = electricityBill.toStringAsFixed(2);
      energyData[0][1] = '${e}SR';
      // });

      chartData.sort((a, b) => b.y.compareTo(a.y));
    });
    print('================precentage==================');
    print((total / usergoal) * 100);
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
    // setState(() {
    electricityBill = (slat_1 + slat_2) * 1.15;
    electricityBill.toInt();
    // });
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
    // setState(() {
    energyFromBill = (slat_1 + slat_2);
    // });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
