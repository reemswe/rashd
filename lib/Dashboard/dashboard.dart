import 'dart:core';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:rashd/list_of_houseMembers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'create_house_account.dart';

class dashboard extends StatefulWidget {
  final String dashId;
  const dashboard({super.key, required this.dashId});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List months = [
    '',
    'جانيوري',
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
  double electricityBill = 0;
  @override
  void initState() {
    setState(() {
      data = getData();
      // global.index = 2;
      int index = date.month;
      formatted = months[index];
      FirebaseFirestore.instance
          .collection("dashboard")
          .doc(widget.dashId)
          .get()
          .then((value) {
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
        });
      });
    });

    super.initState();
  }

  String userGoal = '0';
  int total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
            future: goal(),
            builder: (context, snapshot) {
              return Text(
                houseName,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              );
            }),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: //Icon(Icons.more_vert)
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
                                color: Color.fromARGB(255, 35, 129, 6))),
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
                                color: Color.fromARGB(255, 164, 10, 10))),
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
                    style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
              ),
            ];
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        // maxLength: 20,
                        readOnly: true,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: formatted,
                          hintStyle: const TextStyle(fontSize: 15),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          border: InputBorder.none,
                        ),
                      ),
                    ])),
                Stack(children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                      child: FutureBuilder(
                          future: goal(),
                          builder: (context, snapshot) {
                            return Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(30),
                                child: TextFormField(
                                  readOnly: true,
                                  maxLines: 4,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    suffixIcon: const Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Text(
                                          'الهدف لإجمالي استهلاك \n :الطاقة',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    hintStyle: const TextStyle(
                                      fontSize: 10,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 17, 184, 97),
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 15, 5, 10),
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
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 8, right: 0),
                                      child: Text(
                                        '$userGoal kWh',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            // decoration: TextDecoration.underline,
                                            color: Colors.green),
                                      ),
                                    ),
                                  ),
                                ));
                          })),
                  //floating action button
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
                Expanded(
                  child: Stack(children: [
                    Container(
                        child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 4.0),
                      itemBuilder: (BuildContext context, int index) {
                        final item = text[index];

                        return buildCard(item);
                      },
                    )),
                    Container(child: Text(electricityBill.toString())),
                    //chart
                    FutureBuilder(
                        future: data,
                        builder: (context, snapshot) {
                          return Container(
                              margin: const EdgeInsets.fromLTRB(0, 170, 0, 12),
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
                        })
                  ]),
                ),
              ])),
      // bottomNavigationBar: buildBottomNavigation(),
    );
  }

  // Widget buildBottomNavigation() {
  //   return BottomNavyBar(
  //     selectedIndex: global.index,
  //     onItemSelected: (index) {
  //       setState(
  //         () => global.index = index,
  //       );
  //       if (global.index == 0) {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //       builder: (context) => HouseMembers(
  //         //             houseId: houseID,
  //         //           )),
  //         // );
  //       } else if (global.index == 1) {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //       builder: (context) => const dashboard(
  //         //             dashId: 'fIgVgfieeVqGRB9oRne1',
  //         //           )),
  //         // );
  //       } else if (global.index == 2) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const dashboard(
  //                     dashId: 'fIgVgfieeVqGRB9oRne1',
  //                   )),
  //         );
  //       } else if (global.index == 3) {}
  //     },
  //     items: <BottomNavyBarItem>[
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.people_alt_rounded),
  //         title: const Text(
  //           ' الأعضاء',
  //           textAlign: TextAlign.center,
  //         ),
  //         activeColor: Colors.lightBlue,
  //       ),
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.electrical_services_rounded),
  //         title: const Text(
  //           ' اجهزتي',
  //           textAlign: TextAlign.center,
  //         ),
  //         activeColor: Colors.lightBlue,
  //       ),
  //       BottomNavyBarItem(
  //           icon: const Icon(Icons.auto_graph_outlined),
  //           title: const Text(
  //             'لوحة المعلومات',
  //             textAlign: TextAlign.center,
  //           ),
  //           activeColor: Colors.lightBlue),
  //       BottomNavyBarItem(
  //           icon: const Icon(Icons.holiday_village_rounded),
  //           title: const Text(
  //             'منازلي',
  //             textAlign: TextAlign.center,
  //           ),
  //           activeColor: Colors.lightBlue),
  //     ],
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   );
  // }

  Widget buildCard(List content) {
    return Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xff940D5A)),

          color: content[3],
          borderRadius: BorderRadius.circular(17.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 7.0),
              blurRadius: 7.0,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(6, 5, 2, 9),
        margin: content[5],
        //color: content[3],

        child: FutureBuilder(
            future: energy,
            builder: (context, snapshot) {
              return GridTile(
                child: Center(
                    child: Text(
                  content[0],
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: content[4], fontWeight: FontWeight.w600),
                )),
              );
            }));
    //}));
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
                            double e = double.parse(goalController.text);
                            goal();
                            calculateBill(e);
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

  Future<void> UpdateDB() async {
    var Edit_info =
        FirebaseFirestore.instance.collection('dashboard').doc(widget.dashId);
    Edit_info.update({
      'userGoal': goalController.text,
    });
  }

  Future<void> goal() async {
    await FirebaseFirestore.instance
        .collection("dashboard")
        .doc(widget.dashId)
        .get()
        .then((value) {
      userGoal = value.data()!["userGoal"];
      print('user goal: $userGoal');
    });
  }

  Future<void> totalEnergy() async {
    String percentage = '';
    var collection = await FirebaseFirestore.instance
        .collection('dashboard')
        .doc(widget.dashId)
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

//calculate electricity bill for 30 days
//بدون رسوم خدمة العداد
  void calculateBill(double e) {
    double slat_1 = 0;
    double slat_2 = 0;
    if (e > 6000) {
      slat_1 = 6000 * 0.18;
      slat_2 = (e - 6000) * 0.30;
    } else {
      slat_1 = e * 0.18;
    }
    setState(() {
      electricityBill = (slat_1 + slat_2) * 1.15;
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
