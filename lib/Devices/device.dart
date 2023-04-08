// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
  var deviceData, finalColor = Colors.white;
  var isEditing = false;
  Object? deviceStatus = 'disconnected', currCons = 0, temperature = 0;

  @override
  initState() {
    getDeviceRealtimeData();
    getDeviceID();
    super.initState();
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
      print('deviceColor $deviceColor');
      deviceColor = doc['color'];
      var color = deviceColor.split('(0x')[1].split(')')[0];
      int colorValue = int.parse(color, radix: 16);
      finalColor = Color(colorValue);
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
                        width: width * 0.80,
                        height: 50,
                        top: height * 0.03,
                        right: width * 0.15,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                !isEditing
                                    ? deviceData['name']
                                    : 'تحرير معلومات الجهاز',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                              Visibility(
                                  visible: !isEditing,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.0001,
                                                vertical: height * 0.0001),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color:
                                                  finalColor, //Colors.lightBlue.shade100,
                                            ),
                                            alignment: Alignment.center,
                                            child: IconButton(
                                              icon: const Icon(
                                                color: Colors.black,
                                                Icons.create_rounded,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  nameController.text =
                                                      deviceData['name'];
                                                  isEditing = true;
                                                });
                                              },
                                            )),
                                        IconButton(
                                          icon: const Icon(
                                            size: 30,
                                            color: Colors.red,
                                            Icons.delete_forever_outlined,
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal:
                                                            width * 0.05,
                                                        vertical:
                                                            height * 0.01),
                                                title:
                                                    const Text("حذف الجهاز؟"),
                                                content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const [
                                                      Text(
                                                        "هل أنت متأكد أنك تريد حذف الجهاز؟",
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
                                                            "\n*لا يمكن التراجع عن هذا الإجراء",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ))
                                                    ]),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'houseAccount')
                                                          .doc(widget.houseID)
                                                          .collection(
                                                              'houseDevices')
                                                          .doc(widget.deviceID)
                                                          .delete();

                                                      DatabaseReference
                                                          database =
                                                          FirebaseDatabase
                                                              .instance
                                                              .ref(
                                                                  'devicesList/${deviceRealtimeID}/');

                                                      await database.update(
                                                          {'HouseID': ''});

                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();

                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "تم حذف الجهاز بنجاح.",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade400,
                                                          textColor:
                                                              Colors.white);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      child: const Text("حذف",
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
                                                          const EdgeInsets.all(
                                                              14),
                                                      child:
                                                          const Text("إلغاء"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ])),
                            ])),
                    Positioned(
                        width: width,
                        height: height,
                        top: height * 0.1,
                        child: isEditing
                            ? ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.06),
                                children: [
                                    SizedBox(height: height * 0.01),
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "الاسم",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                        ),
                                        child: Form(
                                          key: formKey,
                                          child: TextFormField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: height * 0.02,
                                              ),
                                              labelText: 'اسم الجهاز',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  (value.trim()).isEmpty) {
                                                return 'الرجاء ادخال اسم للجهاز';
                                              }
                                              return null;
                                            },
                                          ),
                                        )),
                                    SizedBox(height: height * 0.04),
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "لون الجهاز",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        'الرجاء تحديد لون لتمييز الجهاز',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.06,
                                          height * 0.01,
                                          width * 0.06,
                                          height * 0.01),
                                      child: ColorPicker(
                                        hasBorder: true,
                                        borderColor: Colors.grey.shade200,
                                        color: finalColor,
                                        pickersEnabled: const {
                                          ColorPickerType.accent: false,
                                          ColorPickerType.custom: true,
                                          ColorPickerType.primary: false
                                        },
                                        onColorChanged: (Color temp) =>
                                            setState(() {
                                          setState(() => finalColor = temp);
                                        }),
                                        width: 35,
                                        height: 35,
                                        enableShadesSelection: false,
                                        selectedColorIcon: Icons.check,
                                        borderRadius: 30,
                                        customColorSwatchesAndNames: {
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffFFADAD)):
                                              "0xffFFADAD",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffffd6a5)):
                                              "0xffffd6a5",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xfffcf6bd)):
                                              "0xfffcf6bd",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffcaffbf)):
                                              "0xffcaffbf",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffd0f4de)):
                                              "0xffd0f4de",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffbde0fe)):
                                              "0xffbde0fe",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffa9def9)):
                                              "0xffa9def9",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffa0c4ff)):
                                              "0xffa0c4ff",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffd7c8f3)):
                                              "0xffd7c8f3",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffcdc1ff)):
                                              "0xffcdc1ff",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffffc6ff)):
                                              "0xffffc6ff",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffffe5ec)):
                                              "0xffffe5ec",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xfffffffc)):
                                              "0xfffffffc",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffedede9)):
                                              "0xffedede9",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffe2e2e2)):
                                              "0xffe2e2e2",
                                          ColorTools.createPrimarySwatch(
                                                  const Color(0xffe3d5ca)):
                                              "0xffe3d5ca",
                                        },
                                        padding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 4),
                                              blurRadius: 5.0)
                                        ],
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.0, 1.0],
                                          colors: [
                                            Colors.blue,
                                            Color(0xFF39d6ce),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (isEditing) {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                content: const Text(
                                                  "Discard the changes you made?",
                                                  textAlign: TextAlign.left,
                                                ),
                                                actions: <Widget>[
                                                  // cancle button
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      child: const Text(
                                                          "Keep editing"),
                                                    ),
                                                  ),
                                                  //ok button
                                                  TextButton(
                                                    onPressed: () async {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //       builder: (context) => userProfile(
                                                      //           userType: widget
                                                      //               .userType,
                                                      //           selectedTab:
                                                      //               2,
                                                      //           selectedSubTab:
                                                      //               1),
                                                      //     ));
                                                      var n =
                                                          Navigator.of(context);
                                                      n.pop();
                                                      n.pop();
                                                    },
                                                    child: Container(
                                                      //color: Color.fromARGB(255, 164, 20, 20),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      child: const Text(
                                                          "Discard",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      164,
                                                                      10,
                                                                      10))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 30, 10, 0),
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 4),
                                                blurRadius: 5.0)
                                          ],
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            stops: [0.1, 1.0],
                                            colors: [
                                              Colors.blue.shade200,
                                              Colors.blue.shade400,
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                  ),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          const Size(350, 50)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      50, 10, 50, 10),
                                                  child: Text(
                                                    'التالي',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                onPressed: () {}))),
                                  ])
                            : ListView(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                ),
                                children: [
                                    SizedBox(height: height * 0.01),
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "الاسم",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Visibility(
                                        visible: isEditing,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.08,
                                            ),
                                            child: Form(
                                              key: formKey,
                                              child: TextFormField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: width * 0.04,
                                                  ),
                                                  labelText: 'اسم الجهاز',
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      (value.trim()).isEmpty) {
                                                    return 'الرجاء ادخال اسم للجهاز';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ))),
                                    Visibility(
                                        visible: isEditing,
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                width * 0.06,
                                                height * 0.01,
                                                width * 0.06,
                                                height * 0.01),
                                            child: ColorPicker(
                                              hasBorder: true,
                                              borderColor: Colors.grey.shade200,
                                              color: finalColor,
                                              pickersEnabled: const {
                                                ColorPickerType.accent: false,
                                                ColorPickerType.custom: true,
                                                ColorPickerType.primary: false
                                              },
                                              onColorChanged: (Color temp) =>
                                                  setState(() {
                                                setState(
                                                    () => finalColor = temp);
                                              }),
                                              width: 35,
                                              height: 35,
                                              enableShadesSelection: false,
                                              selectedColorIcon: Icons.check,
                                              borderRadius: 30,
                                              customColorSwatchesAndNames: {
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffFFADAD)):
                                                    "0xffFFADAD",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffffd6a5)):
                                                    "0xffffd6a5",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xfffcf6bd)):
                                                    "0xfffcf6bd",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffcaffbf)):
                                                    "0xffcaffbf",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffd0f4de)):
                                                    "0xffd0f4de",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffbde0fe)):
                                                    "0xffbde0fe",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffa9def9)):
                                                    "0xffa9def9",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffa0c4ff)):
                                                    "0xffa0c4ff",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffd7c8f3)):
                                                    "0xffd7c8f3",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffcdc1ff)):
                                                    "0xffcdc1ff",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffffc6ff)):
                                                    "0xffffc6ff",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffffe5ec)):
                                                    "0xffffe5ec",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xfffffffc)):
                                                    "0xfffffffc",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffedede9)):
                                                    "0xffedede9",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffe2e2e2)):
                                                    "0xffe2e2e2",
                                                ColorTools.createPrimarySwatch(
                                                        const Color(
                                                            0xffe3d5ca)):
                                                    "0xffe3d5ca",
                                              },
                                              padding: const EdgeInsets.all(0),
                                            ))),
                                    Visibility(
                                        visible: !isEditing,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: LiteRollingSwitch(
                                            value:
                                                deviceStatus != 'disconnected'
                                                    ? (deviceStatus == 'ON'
                                                        ? true
                                                        : false)
                                                    : false,
                                            textOn: 'On',
                                            textOff:
                                                deviceStatus != 'disconnected'
                                                    ? 'Off'
                                                    : "غير متصل",
                                            colorOn: Colors.green.shade400,
                                            colorOff:
                                                deviceStatus != 'disconnected'
                                                    ? Colors.red.shade400
                                                    : Colors.grey.shade600,
                                            iconOn: Icons.done,
                                            iconOff:
                                                Icons.remove_circle_outline,
                                            textOnColor: Colors.white,
                                            textSize: 16.0,
                                            width: 100,
                                            onChanged: (bool state) async {
                                              if (deviceStatus !=
                                                  'disconnected') {
                                                await updateDeviceStatus(
                                                    state ? "ON" : "OFF",
                                                    deviceRealtimeID);
                                              }
                                            },
                                            onTap: () {},
                                            onSwipe: () {},
                                            onDoubleTap: () {},
                                          ),
                                        )),
                                    SizedBox(height: height * 0.01),
                                    Visibility(
                                        visible: !isEditing,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(children: [
                                                Text('$currCons',
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Text('الاستهلاك الحالي'),
                                              ]),
                                              Column(children: [
                                                Text('$temperature',
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Text('درجة حرارة الجهاز')
                                              ])
                                            ])),
                                    SizedBox(height: height * 0.01),
                                    Visibility(
                                        visible: !isEditing,
                                        child: SfCartesianChart(
                                            primaryXAxis: CategoryAxis(
                                                title:
                                                    AxisTitle(text: 'الأشهر')),
                                            primaryYAxis: NumericAxis(
                                                title: AxisTitle(text: 'kWh')),
                                            series: <
                                                ChartSeries<ChartData, String>>[
                                              LineSeries<ChartData, String>(
                                                  width: 3,
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
                                            ]))
                                  ])),
                  ]);
                } else {
                  return const Text('');
                }
              })),
    );
  }

  Future<void> getDeviceRealtimeData() async {
    await getDeviceID();
    var color = deviceColor.split('(0x')[1].split(')')[0];
    int colorValue = int.parse(color, radix: 16);

    final databaseRef =
        FirebaseDatabase.instance.ref('devicesList/$deviceRealtimeID/');

    databaseRef.onValue.listen((event) {
      Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, values) {
          if (key == 'status') {
            deviceStatus = values;
            print(values);
          } else if (key == 'consumption') {
            print(values['currentConsumption']);
            currCons = values['currentConsumption'];
          } else if (key == 'temperature') {
            print(values);
            temperature = values;
          }
        });
      }
    });

    databaseRef.onValue.listen((event) {
      // Clear the existing chart data
      chartData.clear();

      // Convert the retrieved data to a list of ChartData objects
      Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      setState(() {});
      if (data != null) {
        data.forEach((key, values) {
          if (key == 'status') {
            deviceStatus = values;
          } else if (key == 'consumption') {
            currCons = values['currentConsumption'];
            var monthlyConsumption = values['monthlyConsumption'];
            monthlyConsumption.forEach((key, values) {
              String name = key;
              double cons = values.toDouble();
              ChartData chart = ChartData(name, cons, Color(colorValue));
              chartData.add(chart);
            });
          } else if (key == 'temperature') {
            temperature = values;
          }
        });
      }
    });
  }
}
