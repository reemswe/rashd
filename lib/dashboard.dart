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

Future<Map<String, dynamic>> readSharedData(var dashID) =>
    FirebaseFirestore.instance.collection('dashboard').doc(dashID).get().then(
      (DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
      },
    );

Future<void> share(dashboardID) async {
  var uuid = const Uuid();
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
      'فاتورة الكهرباء\n\n500.25 SR',
      '500.25 SR',
      '\t',
      const Color.fromARGB(255, 92, 226, 233),
      Colors.black,
      const EdgeInsets.fromLTRB(15, 15, 12, 23),
    ],
    [
      'اجمالي استهلاك الطاقة\n\nkWh\n\n  تم بلوغ 50% من هدف الشهر',
      '',
      'تم بلوغ 50% من هدف الشهر',
      const Color.fromARGB(255, 107, 217, 245),
      Colors.white,
      const EdgeInsets.fromLTRB(0, 15, 10, 23),
    ]
  ];
  //List<ChartData>? chartData;
  List<ChartData> chartData = [
    // ChartData('الثلاجة', 350),
    // ChartData('المكيف', 230),
    // ChartData('التلفاز', 340),
    // ChartData('المايكرويف', 250),
    // ChartData('الفريزر', 400),
    // ChartData('المكيف1', 230),
    // ChartData('1التلفاز', 340),
    // ChartData('1المايكرويف', 250),
    // ChartData('1الفريزر', 400),
    // ChartData('المكيف2', 230),
    // ChartData('2التلفاز', 340),
    // ChartData('2المايكرويف', 250),
    // ChartData('2الفريزر', 400),
    // ChartData('1التلفاز', 340),
    // ChartData('1المايكرويف', 250),
    // ChartData('1الفريزر', 400),
    // ChartData('المكيف2', 230),
    // ChartData('2التلفاز', 340),
    // ChartData('2المايكرويف', 250),
    //ChartData('2الفريزر', 400)
  ];

  int i = 0;
  var date = DateTime.now();
  var formatted = '';
  TextEditingController goalController = TextEditingController();
  String houseName = '';
  String houseID = '';

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
        });
      });
    });

    super.initState();
  }

  String userGoal = '';
  int total = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<Map<String, dynamic>>(
        future: widget.isShared
            ? readSharedData(widget.ID)
            : readHouseData(houseID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var houseData = snapshot.data as Map<String, dynamic>;
            return Scaffold(
            //   appBar: AppBar(
            //     shape: const RoundedRectangleBorder(
            //       borderRadius: BorderRadius.vertical(
            //         bottom: Radius.circular(30),
            //       ),
            //     ),
            //     toolbarHeight: height * 0.15,
            //     title: Wrap(
            //         direction: Axis.vertical,
            //         spacing: 1,
            //         children: <Widget>[
            //           SizedBox(height: height * 0.01),
            //           Text(
            //             widget.isShared ? 'البيت' : houseData['houseName'],
            //             style: const TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 25,
            //               height: 1,
            //             ),
            //           ),
            //           Text(
            //             widget.isShared
            //                 ? ''
            //                 : (houseData['OwnerID'] ==
            //                         FirebaseAuth.instance.currentUser!.uid
            //                     ? 'مالك المنزل'
            //                     : "عضو في المنزل"),
            //             style: TextStyle(
            //               color: Colors.grey.shade900,
            //               fontWeight: FontWeight.w400,
            //               fontSize: 16,
            //               height: 1,
            //             ),
            //           )
            //         ]),
            //     backgroundColor: Colors.white,
            //     foregroundColor: Colors.black,
            //     actions: [
            //       //Wedd : added delete for member
            // IconButton(
            //     onPressed: () {
            //       if (houseID == FirebaseAuth.instance.currentUser!.uid) {
            //         showDialog(
            //           context: context,
            //           builder: (ctx) => AlertDialog(
            //             title: const Text(
            //               "حذف حساب المنزل",
            //               textAlign: TextAlign.center,
            //             ),
            //             content: const Text(
            //               "هل أنت متأكد من حذف حساب المنزل ؟",
            //               textAlign: TextAlign.right,
            //             ),
            //             actions: <Widget>[
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.of(ctx).pop();
            //                 },
            //                 child: Container(
            //                   padding: const EdgeInsets.all(14),
            //                   child: const Text("الغاء"),
            //                 ),
            //               ),
            //               // in ok button
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.of(ctx).pop();
            //                 },
            //                 // //ScaffoldMessenger.of(context).showSnackBar(
            //                 //           const SnackBar(
            //                 //               content: Text('تم حذف المنزل بنجاح')),
            //                 //         );
            //                 child: Container(
            //                   padding: const EdgeInsets.all(14),
            //                   child: const Text("حذف",
            //                       style: TextStyle(
            //                           color: Color.fromARGB(255, 164, 10, 10))),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       } else {
            //         showDialog(
            //           context: context,
            //           builder: (ctx) => AlertDialog(
            //             title: const Text(
            //               "الغاء الاشتراك في حساب المنزل",
            //               textAlign: TextAlign.center,
            //             ),
            //             content: const Text(
            //               "هل أنت متأكد من انك تريد الغاء الاشتراك في حساب المنزل ؟",
            //               textAlign: TextAlign.right,
            //             ),
            //             actions: <Widget>[
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.of(ctx).pop();
            //                 },
            //                 child: Container(
            //                   padding: const EdgeInsets.all(14),
            //                   child: const Text("لا"),
            //                 ),
            //               ),
            //               // in ok button
            //               TextButton(
            //                 onPressed: () {
            //                   FirebaseFirestore.instance
            //                       .collection('houseAccount')
            //                       .doc(houseID)
            //                       .collection('houseMember')
            //                       .doc(FirebaseAuth.instance
            //                                       .currentUser!.uid) //user id
            //                       .delete()
            //                       .then((snapshot) {
            //                     ScaffoldMessenger.of(context).showSnackBar(
            //                       const SnackBar(
            //                           content: Text('تم الغاء الاشتراك بنجاح')),
            //                     );
            //                   });
            //                   Navigator.of(ctx).pop();
            //                 },
            //                 child: Container(
            //                   padding: const EdgeInsets.all(14),
            //                   child: const Text("نعم",
            //                       style: TextStyle(
            //                           color: Color.fromARGB(255, 164, 10, 10))),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       }
            //     },
            //     icon: Icon(Icons.delete_forever)),
                  
            //     ],
            //     leading:
            //   IconButton(
            //       icon: const Icon(Icons.arrow_back_ios),
            //       onPressed: () {
            //         if (widget.isShared) {
            //           showDialog(
            //             context: context,
            //             builder: (ctx) => AlertDialog(
            //               title: const Text("الخروج من لوحة المعلومات؟"),
            //               content: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: const [
            //                     Text(
            //                       "هل أنت متأكد أنك تريد الخروج من لوحة المعلومات المشتركة؟",
            //                       textAlign: TextAlign.right,
            //                       style: TextStyle(
            //                           fontSize: 18,
            //                           fontWeight: FontWeight.w500),
            //                     ),
            //                     Align(
            //                         alignment: Alignment.centerRight,
            //                         child: Text(
            //                           "\n*يرجى ملاحظة أن الرمز المشترك يستخدم مرة واحدة.",
            //                           style: TextStyle(
            //                               fontSize: 15,
            //                               fontWeight: FontWeight.w300),
            //                           textAlign: TextAlign.right,
            //                         ))
            //                   ]),
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () async {
            //                     // Navigator.of(ctx).pop();
            //                     Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: (context) =>
            //                                 const welcomePage()));
            //                   },
            //                   child: Container(
            //                     padding: const EdgeInsets.all(14),
            //                     child: const Text("خروج",
            //                         style: TextStyle(
            //                             color:
            //                                 Color.fromARGB(255, 194, 98, 98))),
            //                   ),
            //                 ),
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.of(ctx).pop();
            //                   },
            //                   child: Container(
            //                     padding: const EdgeInsets.all(14),
            //                     child: const Text("إلغاء"),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         } else {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => const ListOfHouseAccounts(),
            //               ));
            //         }
            //       },
            //     ),
            //     elevation: 1.5,
            //   ),

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
                              Text(
                                widget.isShared
                                    ? 'البيت'
                                    : houseData['houseName'],
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
                                    ? ''
                                    : (houseData['OwnerID'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? 'مالك المنزل'
                                        : "عضو في المنزل"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 1,
                                ),
                              )
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
                                          color:
                                              Color.fromARGB(255, 17, 184, 97),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 15, 5, 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                                color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.white)),
                                        suffixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 8, right: 0),
                                            child: InkWell(
                                              child: const Text(
                                                '300 kWh',
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    decoration: TextDecoration
                                                        .underline,
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
                                    )));
                          }),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                          child: FloatingActionButton(
                              backgroundColor: Colors.lightGreen,
                              child: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return dialog();
                                    });
                              }))
                    ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildCard(text[0], width, height),
                          buildCard(text[1], width, height),
                        ]),
                    FutureBuilder(
                        future: data,
                        builder: (context, snapshot) {
                          return Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                              child: Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(30),
                                child: TextFormField(
                                  readOnly: true,
                                  maxLines: 6,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 10, 5, 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                0, 158, 158, 158))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                0, 189, 189, 189))),
                                    prefixIcon: Padding(
                                        padding: const EdgeInsets.all(5),
                                        //child: SingleChildScrollView(
                                        child: Stack(children: <Widget>[
                                          const AnimatedPositioned(
                                            // use top,bottom,left and right property to set the location and Transform.rotate to rotate the widget if needed
                                            right: 15,

                                            duration: Duration(seconds: 3),
                                            child: Text(
                                              'الأجهزة الأعلى استهلاكًا للطاقة',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      255, 62, 62, 62)),
                                            ),
                                          ),
                                          SfCartesianChart(
                                              margin: const EdgeInsets.all(20),
                                              primaryXAxis: CategoryAxis(
                                                  // visibleMinimum: 0,
                                                  // visibleMaximum: 29,
                                                  title: AxisTitle(
                                                      text: 'الأجهزة')),
                                              primaryYAxis: NumericAxis(
                                                  title:
                                                      AxisTitle(text: 'kWh')),
                                              series: <
                                                  ChartSeries<ChartData,
                                                      String>>[
                                                // Renders column chart
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
                                        ])),
                                  ),
                                ),
                              ));
                        }),
                  ]),
                ]),
              ),
              bottomNavigationBar: buildBottomNavigation(height, houseID),
            );
          } else {
            return const Text('');
          }
        });
  }

  Widget buildBottomNavigation(height, houseID) {
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
                    builder: (context) => listOfDevices(
                          ID: houseID, //house ID
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

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 20, top: 45 + 20, right: 20, bottom: 20),
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
              const Text(
                'حدد هدف الاستهلاك',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: goalController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: const InputDecoration(
                            hintText: '300',
                            suffixText: 'kWh',
                            suffixStyle: TextStyle(color: Colors.black)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء تحديد هدف';
                          } else {
                            return null;
                          }
                        },
                      ))),
              const SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(fontSize: 18),
                      )),
                  const SizedBox(
                    height: 10,
                    width: 30,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightGreen)),
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

  Widget dialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
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
    String percentage = '';
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
        percentage = ((total / int.parse(userGoal)) * 100).toStringAsFixed(1);
        text[1][0] =
            'اجمالي استهلاك الطاقة\n\n$total kWh\n\n  تم بلوغ $percentage% من هدف الشهر';
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
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
