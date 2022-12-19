import 'dart:core';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:hackathon/profile.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'create_house_account.dart';
import 'goal.dart';
import 'houseDevicesList.dart';
import 'list_of_house_accounts.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  List text = [
    [
      'فاتورة الكهرباء\n\n500.25 SR',
      '500.25 SR',
      '\t',
      Color.fromARGB(255, 92, 226, 233),
      Colors.black
    ],
    [
      'اجمالي استهلاك الطاقة\n\n150 kWh\n\n  تم بلوغ 50% من هدف الشهر',
      '150 kWh',
      'تم بلوغ 50% من هدف الشهر',
      Color.fromARGB(255, 107, 217, 245),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' البيت',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                child: Text("مشاركة لوحة المعلومات "),
                value: 'share',
              ),
              PopupMenuItem(
                child: Text("حذف حساب المنرل",
                    style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
                value: 'delete',
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
                      decoration: const InputDecoration(
                        hintText: ' شهر نوفمبر',
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ])),
              Container(
                  padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                  child: Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
                        readOnly: true,
                        maxLines: 4,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          suffixIcon: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                'الهدف لإجمالي استهلاك \n :الطاقة',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 17),
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
                              borderSide: const BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0)),
                          prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 8, right: 0),
                              child: InkWell(
                                child: const Text(
                                  '300 kWh',
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                      color: Colors.green),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Goal()),
                                  );
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
              Expanded(
                child: Stack(children: [
                  Container(
                      child: GridView.builder(
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
                  Container(
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
                                    const BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0)),
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
              )
            ]),
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  int index = 0;
  Widget buildBottomNavigation() {
    return BottomNavyBar(
      selectedIndex: global.index,
      onItemSelected: (index) {
        setState(
          () => global.index = index,
        );
        if (global.index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const devicesList()),
          );
        } else if (global.index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const dashboard()),
          );
        } else if (global.index == 2) {
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
        margin: const EdgeInsets.fromLTRB(15, 23, 10, 23),
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


/*
IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          */ 