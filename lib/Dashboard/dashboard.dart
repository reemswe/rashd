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

import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:month_year_picker/month_year_picker.dart';

class dashboard extends StatefulWidget {
  final ID; //house id
  final isShared;

  const dashboard({super.key, required this.ID, this.isShared = false});

  @override
  State<dashboard> createState() => _dashboardState();
}

var sharedHouseName = '';

class _dashboardState extends State<dashboard> {
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

    await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.ID)
        .collection('sharedCode')
        .add({'houseID': widget.ID, 'code': codeNumber, 'isExpired': false});
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

  // Future<void>? energy;
  // Future? data;
  final _formKey = GlobalKey<FormState>();
  // List? devices = [];
  List energyData = [
    [
      'فاتورة الكهرباء',
      '500.25SR',
      '*الفاتورة تشمل ضريبة القيمة المضافة',
      Colors.lightBlue.shade500,
      Colors.white,
      const Color(0xff81D4FA),
    ],
    [
      'إجمالي استهلاك الطاقة',
      '150kWh',
      'تم بلوغ % من هدف الشهر',
      Colors.lightBlue.shade200,
      Colors.white,
      Colors.lightBlue.shade100,
    ]
  ];
  List<ChartData> chartData = [];
  // var houseID, houseName;
  int i = 0;

  var month = '';
  TextEditingController goalController = TextEditingController();
  double electricityBill = 0;
  double percentage = 0;
  double energyFromBill = 0;
  //late DateTime _selected;
  DateTime? _selected;
  @override
  void initState() {
    //  _selected = DateTime.now();
    month = months[DateTime.now().month];
    // getDeviceRealtimeData();
    // getDeviceID();
    getData();
    setState(() {
      // FirebaseFirestore.instance
      //     .collection("dashboard")
      //     .doc(widget.ID)
      //     .get()
      //     .then((value) {
      // energy = totalEnergy();
      // FirebaseFirestore.instance
      //     .collection("houseAccount")
      //     .doc(houseID)
      //     .get()
      //     .then((value) {
      //   houseName = value.data()!["houseName"];
      // double electricityBill = 0;
      // double energyFromBill = 0;
      // });
    });
    getToken();
    super.initState();
  }

  int total = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    calculateBill(10000);
    calculateEnergy(1080);

    var LRPadding = width * 0.025;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
          future: readHouseData(widget.ID),
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
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            height: 1,
                                          ),
                                        ),
                                      )
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
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.lightBlue.shade100,
                              ),
                              alignment: Alignment.center,
                              child:
                                  //month
                                  InkWell(
                                onTap: (() {
                                  _onPressed(context: context, locale: 'ar');

                                  // ubdateChart('march');
                                }),
                                child: Text(month,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        height: 1,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                            SizedBox(width: width * 0.26),
                            Visibility(
                                visible: !widget.isShared,
                                child: IconButton(
                                  icon: const Icon(Icons.ios_share),
                                  onPressed: () {
                                    final databaseRef = FirebaseDatabase
                                        .instance
                                        .ref('devicesList/Rashd-123/');

                                    databaseRef
                                        .once()
                                        .then((DatabaseEvent event) {
                                      print('Data : ${event.snapshot.value}');
                                    });

                                    // share();
                                  },
                                )),
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

                                      /// //  textDirection: TextDirection.ltr,
                                      Text(
                                        '${houseData['goal']} kWh',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.green),
                                      ),
                                    ]),
                              ))),
                      Visibility(
                          visible: !widget.isShared,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0, height * 0.09, width * 0.02, 0),
                              child: FloatingActionButton(
                                  backgroundColor: Colors.lightGreen,
                                  child: const Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return goalDialog(
                                              month, height, width);
                                        });
                                  })))
                    ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: width * 0.025),
                          buildCard(energyData[0], width, height),
                          SizedBox(width: width * 0.025),
                          buildCard(energyData[1], width, height),
                          SizedBox(width: width * 0.025),
                        ]),
                    // FutureBuilder(
                    //     future: data,
                    //     builder: (context, snapshot) {
                    //       return

                    //month picker
                    // if (_selected == null)
                    //   const Text('No month year selected.')
                    // else
                    //   Text(DateFormat().add_yM().format(_selected!)),
                    // TextButton(
                    //   child: const Text('DEFAULT LOCALE'),
                    //   onPressed: () => _onPressed(context: context),
                    // ),
                    // TextButton(
                    //   child: const Text('BAHASA MALAYSIA'),
                    //   onPressed: () =>
                    //       _onPressed(context: context, locale: 'ms'),
                    // ),
                    // TextButton(
                    //   child: const Text('اللغة العربية'),
                    //   onPressed: () =>
                    //       _onPressed(context: context, locale: 'ar'),
                    // ),
                    // Center(
                    //   child: Text(
                    //     'Year: {selectedDate?.year}\nMonth: {selectedDate?.month}',
                    //     style: Theme.of(context).textTheme.headlineMedium,
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    // FloatingActionButton(
                    //   backgroundColor: Colors.amberAccent,
                    //   onPressed: () {},
                    //   child: Icon(
                    //     Icons.calendar_month_outlined,
                    //     size: 35,
                    //     color: Colors.black,
                    //   ),
                    // ),

                    Container(
                        margin:
                            EdgeInsets.fromLTRB(LRPadding, 0, LRPadding, 12),
                        // padding: EdgeInsets.fromLTRB(width * 0.01,
                        //     height * 0.02, width * 0.05, height * 0.02),
                        child: Material(
                          elevation: 20,
                          borderRadius: BorderRadius.circular(30),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.01,
                                  height * 0.02, width * 0.01, height * 0.02),
                              child: Stack(children: <Widget>[
                                const Text(
                                  'الأجهزة الأعلى استهلاكًا للطاقة',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 62, 62, 62)),
                                ),
                                SizedBox(height: height * 0.0),
                                SfCartesianChart(
                                    primaryXAxis: CategoryAxis(
                                        title: AxisTitle(text: 'الأجهزة')),
                                    primaryYAxis: NumericAxis(
                                        title: AxisTitle(text: 'kWh')),
                                    series: <ChartSeries<ChartData, String>>[
                                      ColumnSeries<ChartData, String>(
                                          // color: const Color.fromARGB(
                                          //     255, 98, 227, 165),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          dataSource: chartData,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true),
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          yValueMapper: (ChartData data, _) =>
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
      bottomNavigationBar: buildBottomNavigation(height, widget.ID, true),
    );
  }

  Widget buildBottomNavigation(height, houseID, isOwner) {
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
                            houseID: houseID, //house ID
                          )),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HouseMembers(houseId: houseID)),
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
    // final selected = await showDatePicker(
    //   context: context,
    //   initialDate: _selected ?? DateTime.now(),
    //   firstDate: DateTime(2019),
    //   lastDate: DateTime(2022),
    //   locale: localeObj,
    // );
    if (selected != null) {
      setState(() {
        _selected = selected;
        //DateFormat d = print('month');
        //print(DateFormat.yMMMMd('en_US'));
        //   DateTime d = DateTime().now();

        // print(DateFormat.yMMMMd('ar').format(selected));
        // String d = DateFormat.yMMMMd().format(selected);
        // print(_selected?.year);
        // print((d.substring(0, d.indexOf(' '))).toLowerCase());
        // print(_selected?.month);
        // //  String y = selected?.year.toString();
        // print('_selected?.year');
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
    await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.ID)
        .update({
      'goal': goalController.text,
    });
    goalController.clear();
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
      total = total - i;
      setState(() {
        percentageStr = ((total / int.parse('100')) * 100).toStringAsFixed(1);
        energyData[1][1] = '${total}kWh';
        percentage = (total / int.parse('100')) * 100;
        i = total;
        calculateBill(total.toDouble());
        String e = electricityBill.toStringAsFixed(2);
        energyData[0][1] = '${e}SR';
      });
    });
  }

  Future<void> totalConsumption() async {
    String percentageStr = '';
    var collection = await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.ID)
        .collection('houseDevices');
    collection.snapshots().listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        var deviceID = data['ID']; // <-- Retrieving the value.
        setState(() {
          total += int.parse('100');
        });
      }
      total = total - i;
      setState(() {
        percentageStr = ((total / int.parse('100')) * 100).toStringAsFixed(1);
        energyData[1][1] = '${total}kWh';
        percentage = (total / int.parse('100')) * 100;
        i = total;
      });
    });
  }

  Future ubdateChart(String selectedYearMonth, String monthar) async {
    // print(months[DateTime.now().month]);
    //if (monthar = months[DateTime.now().month]) {
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
      double comonthlyCons = 0;
      String docID = '';

      chartData.clear();

//get devices name,color,id
      var collection = await FirebaseFirestore.instance
          .collection('houseAccount')
          .doc(widget.ID)
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
          docID = doc.id;
          print(doc.id);

//get monthlyConsumption
          var collection2 = await FirebaseFirestore.instance
              .collection('houseAccount')
              .doc(widget.ID)
              .collection('houseDevices')
              .doc(docID)
              .collection('monthlyConsumption');

          collection2.snapshots().listen(((querySnapshot) {
            // print(doc.data().values);
            for (var doc in querySnapshot.docs) {
              if (doc.exists) {
                print('====================m===================');
                Map<String, dynamic> data = doc.data();
                print(data);
                print(data[selectedYearMonth]);
                //if(data[month] != null)
                comonthlyCons =
                    double.parse(data[selectedYearMonth].toString());
                print(comonthlyCons);
                // setState(() {
                //   chartData.add(ChartData(name, comonthlyCons, Color(value)));
                // });
              }
            }
            print(comonthlyCons);
          }));
          print('////////////////////////////////');
          print('name $name');
          print('comonthlyCons $comonthlyCons');
          print('value $value');
//update chart
          setState(() {
            chartData.add(ChartData(name, comonthlyCons, Color(value)));
          });
        }
      }));

      // setState(() {
      //   chartData.clear();
      //   int value = 4278228616;
      //   String name = 'dev';
      //   double consum = 300;
      //   chartData.add(ChartData(name, consum, Color(value)));
      // });
    } //end of else
  }

  // Future<void> getDeviceID() async {
  //   await FirebaseFirestore.instance
  //       .collection('houseAccount')
  //       .doc(widget.ID)
  //       .collection('houseDevices')
  //       .doc(widget.deviceID)
  //       .get()
  //       .then((DocumentSnapshot doc) {
  //     deviceRealtimeID = doc['ID'];
  //     //  deviceColor = doc['color'];
  //     var color = deviceColor.split('(0x')[1].split(')')[0];
  //     int colorValue = int.parse(color, radix: 16);
  //     finalColor = Color(colorValue);
  //   });
  // }

  // Future<void> getRealtimeData() async {
  //   // await getDeviceID();

  //   final databaseRef = FirebaseDatabase.instance
  //       .ref('devicesList/${deviceID}/consumption/monthlyConsumption/');

  //   databaseRef.onValue.listen((event) {
  //     Map<dynamic, dynamic>? data =
  //         event.snapshot.value as Map<dynamic, dynamic>?;
  //     if (data != null) {
  //       data.forEach((key, values) {
  //         String name = key; //the name of the attribute
  //         double cons = values.toDouble(); //the value
  //       });
  //     }
  //   });
  // }

  Future getData() async {
    var collection = await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.ID)
        .collection('houseDevices');
    // to get data from all documents sequentially
    collection.snapshots().listen((querySnapshot) {
      chartData.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data(); // <-- Retrieving the value.
        setState(() {
          // devices!.add([
          //   {
          //     'name': data['name'],
          //     'consumption': data['consumption'],
          //     'color': data['color']
          //   }
          // ]);
          print(data);
          print(data['currentConsumption']);
          var color = data['color'].split('(0x')[1].split(')')[0];
          print('color $color');
          int value = int.parse(color, radix: 16);
          print('value $value');
          String name = data['name'];
          double consum = double.parse(data['currentConsumption'].toString());
          chartData.add(ChartData(name, consum, Color(value)));
        });
      }
      chartData.sort((a, b) => b.y.compareTo(a.y));
      chartData = chartData.take(10).toList();
      chartData.shuffle();
    });
    // return devices;
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
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
