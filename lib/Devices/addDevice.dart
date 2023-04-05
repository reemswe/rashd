// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:hive/hive.dart';

import 'listOfDevices.dart';

const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

class AddDevice extends StatefulWidget {
  final ID; //house ID
  const AddDevice({super.key, required this.ID});
  @override
  AddDeviceState createState() => AddDeviceState();
}

class AddDeviceState extends State<AddDevice> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _isEnabled = false;
  bool connected = false;
  int _index = 0;
  int selectedNetwork = -1;

  List<WifiNetwork?>?
      _htResultNetwork; //display list of near available networks (will be modified to only display network result for Rashd devices)

  @override
  initState() {
    WiFiForIoTPlugin.isEnabled().then((val) {
      _isEnabled = val;
    });
    super.initState();
  }

  Widget getNetworks(height, width, formKey, type) {
    if (_isEnabled) {
      return Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(
            type == 'wifi' ? "شبكة الإنترنت" : "شبكة الجهاز",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: Text(
              type == 'wifi'
                  ? "الرجاء الاتصال بالشبكة"
                  : "الرجاء تحديد اسم الشبكة الذي يطابق معرف جهازك.",
              style: const TextStyle(fontSize: 17),
            )),
        FutureBuilder<dynamic>(
          future: loadWifiList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              _htResultNetwork = snapshot.data;
              if (_htResultNetwork != null && _htResultNetwork!.isNotEmpty) {
                final List<InkWell> htNetworks = <InkWell>[];
                for (int i = 0; i < _htResultNetwork!.length; i++) {
                  var oNetwork = _htResultNetwork![i];
                  var condition = type == 'wifi'
                      ? !(oNetwork!.ssid!).contains("R")
                      : (oNetwork!.ssid!).contains("Abo");
                  if (condition) {
                    htNetworks.add(InkWell(
                      onTap: () {
                        passwordController.clear();
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Align(
                                            child: Text(
                                          'كلمة المرور',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        )),
                                        SizedBox(height: height * 0.01),
                                        const Text(
                                          'الرجاء إدخال كلمة المرور المرتبطة بالجهاز',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Form(
                                            key: formKey,
                                            child: TextFormField(
                                              controller: passwordController,
                                              obscureText: true,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                  hintText: 'كلمة السر'),
                                              validator: (value) {
                                                if (value!.isEmpty ||
                                                    value.length < 8) {
                                                  return "الرجاء إدخال كلمة سر صالحة.";
                                                }
                                              },
                                            )),
                                        SizedBox(height: height * 0.025),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    ),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(
                                                      Size(width * 0.2,
                                                          height * 0.05),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green
                                                                .shade300)),
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    var pass =
                                                        passwordController.text;
                                                    bool isVaild = await WiFiForIoTPlugin
                                                        .connect(
                                                            //need a way to do validate the password to give the user a message, maybe try-catch will work
                                                            "${oNetwork.ssid}",
                                                            password: pass,
                                                            joinOnce: true,
                                                            security:
                                                                STA_DEFAULT_SECURITY);

                                                    if (isVaild) {
                                                      setState(() {
                                                        connected = true;
                                                        selectedNetwork = i;
                                                        passwordController
                                                            .clear();
                                                      });
                                                      Hive.box("devicesInfo").put(
                                                          "SSID",
                                                          oNetwork
                                                              .ssid); //Hive.box("devicesInfo").get("SSID")

                                                      Navigator.of(context)
                                                          .pop();

                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "تم الاتصال بالشبكة بنجاح",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM, // Also possible "TOP" and "CENTER"
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade400,
                                                          textColor:
                                                              Colors.white);
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "كلمة مرور غير صالحة ، الرجاء المحاولة مرة أخرى.",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                          textColor:
                                                              Colors.white);
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  'اتصال',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )),
                                            SizedBox(
                                              height: 10,
                                              width: width * 0.1,
                                            ),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    ),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(
                                                      Size(width * 0.2,
                                                          height * 0.05),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .red.shade400)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'إلغاء',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, 1),
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedNetwork == i
                                    ? Colors.green.shade200
                                    : Colors.white,
                                width: 3,
                              ),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.black45,
                                    spreadRadius: -10)
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(oNetwork.ssid!),
                                Visibility(
                                    visible: selectedNetwork == i,
                                    child: Icon(Icons.task_alt,
                                        size: 28, color: Colors.green.shade300))
                              ])),
                    ));
                  }
                }
                return Column(
                  children: htNetworks.isNotEmpty
                      ? htNetworks
                      : [
                          Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.01,
                                  height * 0.03, width * 0.01, height * 0.03),
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0, height * 0.01, 0, 1),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      color: Colors.white, //Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 20,
                                            color: Colors.black45,
                                            spreadRadius: -10)
                                      ],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(type != 'wifi'
                                      ? "لم يتم العثور على الأجهزة ، يرجى التأكد من أن جهازك متصل بالطاقة وقريب من الهاتف."
                                      : "لم يتم العثور على الشبكات ، يرجى التأكد من وجود شبكة قريبة قيد التشغيل.")))
                        ], //Display list of networks
                );
              } else {
                return const Text("");
              }
            } else {
              return const Text("");
            }
          },
        ),
      ]);
    } else {
      // main widget, shows wifi info and disable, disconnect wifi
      WiFiForIoTPlugin.isEnabled().then((val) {
        setState(() {
          _isEnabled = val;
        });
      });
      //in case the wifi is disabled
      return Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(
            type == 'wifi' ? "شبكة الإنترنت" : "شبكة الجهاز",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: height * 0.03),
        const Text(
            "تم تعطيل شبكة الإنترنت اللاسلكية، يرجى تفعيلها لأضافة الجهاز.",
            style: TextStyle(fontSize: 17, color: Colors.red)),
        SizedBox(height: height * 0.03),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.2, 0, width * 0.2, 0),
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
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(100, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      "تفعيل",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      WiFiForIoTPlugin.setEnabled(true,
                          shouldOpenSettings: true);
                    });
                  }),
            ))
      ]);
    }
  }

  Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = <WifiNetwork>[];
    }
    return htResultNetwork;
  }

  final formKey1 = GlobalKey<FormState>();
  var color = Colors.white;

  @override
  Widget build(BuildContext context) {
    final formKey2 = GlobalKey<FormState>();
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
          child: Stack(children: [
            Positioned(
              bottom: height * -1.3,
              top: height * 0,
              left: width * 0.01,
              child: Container(
                width: width * 1.5,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Colors.lightBlue.shade100,
                      Colors.lightBlue.shade200
                    ]),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.shade100,
                          offset: const Offset(4.0, 4.0),
                          blurRadius: 10.0)
                    ]),
              ),
            ),
            Positioned(
              bottom: height * -1.4,
              top: height * 0,
              left: width * 0.01,
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
                child: const Text(
                  "إضافة جهاز",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                )),
            Positioned(
                width: width,
                height: height,
                top: height * 0.1,
                child: Theme(
                    data: ThemeData(canvasColor: Colors.white),
                    child: Stepper(
                      elevation: 1,
                      currentStep: _index,
                      type: StepperType.horizontal,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails controls) {
                        return _index != 2 && _isEnabled
                            ? Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 30, 10, 0),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(350, 50)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                      ),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(50, 10, 50, 10),
                                        child: Text(
                                          'التالي',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () {
                                        controls.onStepContinue!();
                                      }),
                                ))
                            : const Text('');
                      },
                      onStepContinue: () {
                        if (connected) {
                          setState(() {
                            _index += 1;
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "الرجاء الاتصال بالشبكة للمتابعة.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red.shade400,
                              textColor: Colors.white);
                        }
                      },
                      onStepTapped: (int index) {
                        if (connected) {
                          setState(() {
                            _index = index;
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "الرجاء الاتصال بالجهاز للمتابعة.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red.shade400,
                              textColor: Colors.white);
                        }
                      },
                      steps: <Step>[
                        Step(
                            state: _index != 0
                                ? StepState.complete
                                : StepState.indexed,
                            isActive: true,
                            title: Text('الاتصال بالجهاز',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _index == 0
                                        ? FontWeight.w700
                                        : FontWeight.w500)),
                            content: getNetworks(
                                height, width, formKey2, 'devices')),
                        Step(
                          state: _index > 1
                              ? StepState.complete
                              : StepState.indexed,
                          isActive: _index != 0 ? true : false,
                          title: Text('الاتصال بالشبكة',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _index == 1
                                      ? FontWeight.w700
                                      : FontWeight.w500)),
                          content: getNetworks(height, width, formKey2, 'wifi'),
                        ),
                        Step(
                          state: _index > 2
                              ? StepState.complete
                              : StepState.indexed,
                          isActive: _index == 2 ? true : false,
                          title: Text('معلومات الجهاز',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _index == 2
                                      ? FontWeight.w700
                                      : FontWeight.w500)),
                          content: Form(
                            key: formKey1,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "معلومات الجهاز",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.02,
                                          height * 0.01,
                                          width * 0.02,
                                          height * 0.01),
                                      child: Column(children: [
                                        const Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            "الاسم",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
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
                                        SizedBox(height: height * 0.025),
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
                                        SizedBox(height: height * 0.015),
                                        ColorPicker(
                                          hasBorder: true,
                                          borderColor: Colors.grey.shade200,
                                          color: color,
                                          pickersEnabled: {
                                            ColorPickerType.accent: false,
                                            ColorPickerType.custom: true,
                                            ColorPickerType.primary: false
                                          },
                                          onColorChanged: (Color temp) =>
                                              setState(() {
                                            color = temp;
                                            print(color);
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
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                    ),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(const Size(
                                                                350, 50)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    shadowColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            50, 10, 50, 10),
                                                    child: Text(
                                                      'إضافة الجهاز',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    if (formKey1.currentState!
                                                        .validate()) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'houseAccount')
                                                          .doc(widget.ID)
                                                          .collection(
                                                              'houseDevices')
                                                          .add({
                                                        'ID':
                                                            '${Hive.box("devicesInfo").get("SSID")}',
                                                        'name':
                                                            nameController.text,
                                                        'color': '$color',
                                                        'status': false,
                                                      });
                                                      await UpdateRealtimeDB();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                listOfDevices(
                                                                  ID: widget.ID,
                                                                )),
                                                      );
                                                    }
                                                  }),
                                            )),
                                      ]))
                                ]),
                          ),
                        ),
                      ],
                    )))
          ])),
    );
  }

  Future<void> UpdateRealtimeDB() async {
    var SSID = Hive.box("devicesInfo").get("SSID");
    SSID = "Rashd-123";
    DatabaseReference database =
        FirebaseDatabase.instance.ref('devicesList/${SSID}/');
    database.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(data);
    });

    await database
        .update({'HouseID': widget.ID})
        .then(
          (value) => print("value: "),
        )
        .onError((error, stackTrace) => print(error));
  }
}
