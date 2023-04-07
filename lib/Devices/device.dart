// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wifi_iot/wifi_iot.dart';

import '../Dashboard/dashboard.dart';
import 'listOfDevices.dart';

class Device extends StatefulWidget {
  final deviceID;
  final houseID;
  const Device({super.key, required this.houseID, required this.deviceID});
  @override
  DeviceState createState() => DeviceState();
}

class DeviceState extends State<Device> {
  TextEditingController nameController = TextEditingController();
  var deviceRealtimeID = '', deviceColor = '';
  var deviceData;

  @override
  initState() {
    super.initState();
    getMonthlyConsumption();
  }

  Future<void> getDeviceID() async {
    await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.houseID)
        .collection('houseDevices')
        .doc(widget.deviceID)
        .get()
        .then((DocumentSnapshot doc) {
      deviceRealtimeID = doc['ID'];
      deviceColor = doc['color'];
    });
  }

  Future<Map<String, dynamic>> readDeviceData() => FirebaseFirestore.instance
          .collection('houseAccount')
          .doc(widget.houseID)
          .collection('houseDevices')
          .doc(widget.deviceID)
          .get()
          .then(
        (DocumentSnapshot doc) {
          return doc.data() as Map<String, dynamic>;
        },
      );

  List<ChartData> chartData = [];

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      minChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (_, controller) => Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: FutureBuilder<Map<String, dynamic>>(
              future: readDeviceData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var deviceData = snapshot.data as Map<String, dynamic>;
                  var color = deviceData['color'].split('(0x')[1].split(')')[0];
                  int colorValue = int.parse(color, radix: 16);
                  var finalColor = Color(colorValue);
                  Object? deviceStatus = 'disconnected';
                  final databaseRef = FirebaseDatabase.instance
                      .ref('devicesList/Rashd-123/status/');

                  databaseRef.onValue.listen((event) {
                    deviceStatus = event.snapshot.value;
                  });
                  return Stack(children: [
                    Positioned(
                        bottom: height * -1.3,
                        top: height * 0,
                        left: width * 0.01,
                        child: Opacity(
                          opacity: 0.5,
                          child: Container(
                            width: width * 1.5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    finalColor,
                                    finalColor,
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0.1, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: finalColor,
                                      offset: Offset(4, 4),
                                      blurRadius: 8.0)
                                ]),
                          ),
                        )),
                    Positioned(
                      bottom: height * -1.4,
                      top: height * 0,
                      left: width * 0.01,
                      child: Container(
                        width: width * 1.5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                finalColor,
                                finalColor,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              stops: [0.1, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: finalColor,
                                  offset: Offset(4, 4),
                                  blurRadius: 8.0)
                            ]),
                      ),
                    ),
                    Positioned(
                        width: 50,
                        height: 50,
                        top: height * 0.01,
                        right: width * 0.05,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 60),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )),
                    Positioned(
                        width: width,
                        height: 50,
                        top: height * 0.03,
                        right: width * 0.15,
                        child: Text(
                          deviceData['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        )),
                    Positioned(
                        width: width,
                        height: height,
                        top: height * 0.1,
                        child: ListView(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: LiteRollingSwitch(
                              value: deviceStatus == 'ON' ? true : false,
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
                                print(state);
                                await updateDeviceStatus(
                                    state ? "ON" : "OFF", deviceRealtimeID);
                              },
                              onTap: () {},
                              onSwipe: () {},
                              onDoubleTap: () {},
                            ),
                          ),
                          SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                  title: AxisTitle(text: 'الأشهر')),
                              primaryYAxis:
                                  NumericAxis(title: AxisTitle(text: 'kWh')),
                              series: <ChartSeries<ChartData, String>>[
                                LineSeries<ChartData, String>(
                                    width: 3,
                                    dataSource: chartData,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true),
                                    xValueMapper: (ChartData data, _) => data.x,
                                    pointColorMapper: (ChartData data, _) =>
                                        data.color,
                                    yValueMapper: (ChartData data, _) =>
                                        data.y),
                              ])
                        ])),
                  ]);
                } else {
                  return Text('test');
                }
              })),
    );
  }

  Future<void> getMonthlyConsumption() async {
    await getDeviceID();
    var color = deviceColor.split('(0x')[1].split(')')[0];
    int colorValue = int.parse(color, radix: 16);

    final databaseRef = FirebaseDatabase.instance
        .ref('devicesList/Rashd-123/consumption/monthlyConsumption/');

    databaseRef.onValue.listen((event) {
      // Clear the existing chart data
      chartData.clear();

      // Convert the retrieved data to a list of ChartData objects
      Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, values) {
          String name = key;
          double cons = values.toDouble();
          ChartData chart = ChartData(name, cons, Color(colorValue));
          chartData.add(chart);
        });
      }
    });
  }
}
