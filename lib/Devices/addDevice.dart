// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:hive/hive.dart';

const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

class AddDevice extends StatefulWidget {
  final ID; //house ID
  const AddDevice({super.key, required this.ID});
  @override
  AddDeviceState createState() => AddDeviceState();
}

class AddDeviceState extends State<AddDevice> {
  TextEditingController passwordController = TextEditingController();
  bool _isEnabled = false;
  bool connected = false;
  int _index = 0;

  List<WifiNetwork?>?
      _htResultNetwork; //display list of near available networks (will be modified to only display network result for Rashd devices)

  @override
  initState() {
    WiFiForIoTPlugin.isEnabled().then((val) {
      _isEnabled = val;
    });
    super.initState();
  }

  Widget getNetworks(height, width, _formKey, type) {
    var green = Colors.white;
    if (_isEnabled) {
      return Column(children: [
        Align(
            alignment: Alignment.topRight,
            child: Text(
              type == 'wifi'
                  ? "الرجاء الاتصال بالشبكة"
                  : "الرجاء تحديد اسم الشبكة الذي يطابق معرف جهازك.",
              style: TextStyle(fontSize: 17),
            )),
        FutureBuilder<dynamic>(
          future: loadWifiList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              _htResultNetwork = snapshot.data;
              if (_htResultNetwork != null && _htResultNetwork!.isNotEmpty) {
                final List<InkWell> htNetworks = <InkWell>[];
                for (var oNetwork in _htResultNetwork!) {
                  var condition = type == 'wifi'
                      ? !(oNetwork!.ssid!).contains("Rashd")
                      : (oNetwork!.ssid!).contains("Abo");
                  if (condition) {
                    //Rashd
                    htNetworks.add(InkWell(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(10, height * 0.01, 10, 1),
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: green, //Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.black45,
                                    spreadRadius: -10)
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(oNetwork.ssid!)),
                      onTap: () {
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
                                            key: _formKey,
                                            child: TextFormField(
                                              controller: passwordController,
                                              obscureText: true,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                  hintText: 'كلمة السر'),
                                              validator: (value) {
                                                if (value!.isEmpty) {
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
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(width * 0.2,
                                                        height * 0.05),
                                                    backgroundColor:
                                                        Colors.lightGreen),
                                                onPressed: () async {
                                                  if (_formKey.currentState!
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
                                                        green = Colors.red;
                                                        connected = true;
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
                                            const SizedBox(
                                              height: 10,
                                              width: 30,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(width * 0.2,
                                                        height * 0.05),
                                                    backgroundColor:
                                                        Colors.redAccent),
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
                    ));
                  }
                }
                return Column(
                  children: htNetworks, //Display list of networks
                );
              } else {
                return const Text("no matching result");
              }
            } else {
              return const CircularProgressIndicator();
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
        const SizedBox(height: 10),
        const Text("Wifi Disabled"),
        MaterialButton(
          color: Colors.blue,
          child: const Text(
            "Enable",
          ),
          onPressed: () {
            setState(() {
              WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
            });
          },
        ),
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final _formKey = GlobalKey<FormState>();

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
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => listOfDevices(
                    //         ID: widget.ID,
                    //       ),
                    //     ));
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
                right: width * 0.01,
                child: Theme(
                    data: ThemeData(canvasColor: Colors.white),
                    child: Stepper(
                      margin: const EdgeInsets.fromLTRB(10, 1, 1, 10),
                      elevation: 1,
                      currentStep: _index,
                      type: StepperType.horizontal,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails controls) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _index == 0
                                ? Column(children: [
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 30, 0, 0),
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
                                              onPressed: () {
                                                controls.onStepContinue!();
                                              }),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ])
                                : Column(children: [
                                    Row(children: [
                                      Center(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 4),
                                                blurRadius: 5.0)
                                          ],
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          50)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                            ),
                                            child: Text(
                                              'Back',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue.shade800),
                                            ),
                                            onPressed: controls.onStepCancel),
                                      )),
                                      const SizedBox(width: 20),
                                      Center(
                                          child: Container(
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
                                              Colors.cyanAccent,
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          50)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                            ),
                                            child: const Text(
                                              'Register',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            onPressed: () async {}),
                                      )),
                                    ]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ])
                          ],
                        );
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
                            _index += 1;
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
                            title: const Text('الاتصال بالجهاز'),
                            content: getNetworks(
                                height, width, _formKey, 'devices')),
                        Step(
                          state: _index > 1
                              ? StepState.complete
                              : StepState.indexed,
                          isActive: _index != 0 ? true : false,
                          title: const Text('الاتصال بالشبكة'),
                          content: getNetworks(height, width, _formKey, 'wifi'),
                        ),
                        Step(
                            state: _index > 1
                                ? StepState.complete
                                : StepState.indexed,
                            isActive: _index != 0 ? true : false,
                            title: const Text('معلومات الجهاز'),
                            content: const Text('معلومات الجهاز') //deviceInfo,
                            ),
                      ],
                    )))
          ])),
    );
  }
}
