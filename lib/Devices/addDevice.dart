// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List<WifiNetwork?>?
      _htResultNetwork; //display list of near available networks (will be modified to only display network result for Rashd devices)

  @override
  initState() {
    WiFiForIoTPlugin.isEnabled().then((val) {
      _isEnabled = val;
    });
    super.initState();
  }

  Widget getNetworks(height, width, _formKey) {
    // main widget, shows wifi info and disable, disconnect wifi
    // WiFiForIoTPlugin.isEnabled().then((val) {
    //   setState(() {
    //     _isEnabled = val;
    //   });
    // });
    if (_isEnabled) {
      return Column(children: [
        const Text("الرجاء تحديد اسم الشبكة الذي يطابق معرف جهازك."),
        FutureBuilder<dynamic>(
          future: loadWifiList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              _htResultNetwork = snapshot.data;
              if (_htResultNetwork != null && _htResultNetwork!.length > 0) {
                final List<InkWell> htNetworks = <InkWell>[];
                _htResultNetwork!.forEach((oNetwork) {
                  if ((oNetwork!.ssid!).contains("KSU")) {
                    //Rashd

                    htNetworks.add(InkWell(
                      child: Container(child: Text(oNetwork.ssid!)),
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
                                                  return '';
                                                } else {
                                                  return null;
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
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    print(passwordController);
                                                    var pass =
                                                        passwordController.text;
                                                    print(pass);
                                                    WiFiForIoTPlugin.connect(
                                                        //need a way to do validate the password to give the user a message, maybe try-catch will work
                                                        "${oNetwork.ssid}",
                                                        password:
                                                            pass, //  'Lamd@1422',
                                                        joinOnce: true,
                                                        security:
                                                            STA_DEFAULT_SECURITY);
                                                    Hive.box("devicesInfo").put(
                                                        "SSID",
                                                        oNetwork
                                                            .ssid); //Hive.box("devicesInfo").get("SSID")

                                                    // Navigator.of(context)
                                                    //     .pop();
                                                  }
                                                },
                                                child: const Text(
                                                  'تحديد',
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
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return Dialog(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(20),
                        //           ),
                        //           elevation: 0,
                        //           backgroundColor: Colors.transparent,
                        //           child: Column(
                        //             children: <Widget>[
                        //               Container(
                        //                 padding: EdgeInsets.only(
                        //                     left: width * 0.02,
                        //                     top: height * 0.08,
                        //                     right: width * 0.02,
                        //                     bottom: height * 0.05),
                        //                 margin: const EdgeInsets.only(top: 45),
                        //                 decoration: BoxDecoration(
                        //                     shape: BoxShape.rectangle,
                        //                     color: Colors.white,
                        //                     borderRadius:
                        //                         BorderRadius.circular(20),
                        //                     boxShadow: const [
                        //                       BoxShadow(
                        //                           color: Color.fromARGB(
                        //                               255, 41, 41, 41),
                        //                           offset: Offset(0, 10),
                        //                           blurRadius: 10),
                        //                     ]),
                        //                 child: Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: <Widget>[
                        //                     const Text(
                        //                       'حدد هدف استهلاك الطاقة لشهر ',
                        //                       style: TextStyle(
                        //                           fontSize: 22,
                        //                           fontWeight: FontWeight.w600),
                        //                     ),
                        //                     SizedBox(height: height * 0.01),
                        //                     Padding(
                        //                         padding: EdgeInsets.fromLTRB(
                        //                             width * 0.02,
                        //                             0,
                        //                             width * 0.02,
                        //                             0),
                        //                         child: Form(
                        //                             key: _formKey,
                        //                             child: TextFormField(
                        //                               controller:
                        //                                   passwordController,
                        //                               maxLines: 1,
                        //                               textAlign:
                        //                                   TextAlign.center,
                        //                               decoration:
                        //                                   const InputDecoration(
                        //                                       hintText:
                        //                                           '300kWh',
                        //                                       prefixText: 'kWh',
                        //                                       prefixStyle: TextStyle(
                        //                                           color: Colors
                        //                                               .black)),
                        //                               validator: (value) {
                        //                                 if (value!.isEmpty) {
                        //                                   return 'الرجاء تحديد الهدف';
                        //                                 } else {
                        //                                   return null;
                        //                                 }
                        //                               },
                        //                             ))),
                        //                     SizedBox(height: height * 0.02),
                        //                     Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.center,
                        //                       children: [
                        //                         ElevatedButton(
                        //                             style: ElevatedButton
                        //                                 .styleFrom(
                        //                                     fixedSize: Size(
                        //                                         width * 0.2,
                        //                                         height * 0.05),
                        //                                     backgroundColor:
                        //                                         Colors
                        //                                             .lightGreen),
                        //                             onPressed: () {
                        //                               if (_formKey.currentState!
                        //                                   .validate()) {
                        //                                 // setState(() {
                        //                                 //   // goal();
                        //                                 // });
                        //                                 print(
                        //                                     passwordController);
                        //                                 var pass =
                        //                                     passwordController
                        //                                         .text;
                        //                                 print(pass);
                        //                                 WiFiForIoTPlugin.connect(
                        //                                     "${oNetwork.ssid}",
                        //                                     password:
                        //                                         pass, //  'Lamd@1422',
                        //                                     joinOnce: true,
                        //                                     security:
                        //                                         STA_DEFAULT_SECURITY);
                        //                                 // UpdateDB();
                        //                                 // Navigator.of(context)
                        //                                 //     .pop();
                        //                               }
                        //                             },
                        //                             child: const Text(
                        //                               'تحديد',
                        //                               style: TextStyle(
                        //                                   fontSize: 18),
                        //                             )),
                        //                         const SizedBox(
                        //                           height: 10,
                        //                           width: 30,
                        //                         ),
                        //                         ElevatedButton(
                        //                             style: ElevatedButton
                        //                                 .styleFrom(
                        //                                     fixedSize: Size(
                        //                                         width * 0.2,
                        //                                         height * 0.05),
                        //                                     backgroundColor:
                        //                                         Colors
                        //                                             .redAccent),
                        //                             onPressed: () {
                        //                               Navigator.of(context)
                        //                                   .pop();
                        //                             },
                        //                             child: const Text(
                        //                               'إلغاء',
                        //                               style: TextStyle(
                        //                                   fontSize: 18),
                        //                             )),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ));
                        //     });

                        // WiFiForIoTPlugin.connect("${oNetwork.ssid}",
                        //     password: '0500991990',
                        //     joinOnce: true,
                        //     security: STA_DEFAULT_SECURITY);
                      },
                    ));
                  }
                });
                return Column(
                  children: htNetworks, //Display list of networks
                );
              } else {
                return const Text("no matching result");
              }
            } else {
              /// you handle others state like error while it will a widget no matter what, you can skip it
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
                child: getNetworks(height, width, _formKey)),
            // FutureBuilder<dynamic>(
            //   future: loadWifiList(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done &&
            //         snapshot.hasData) {
            //       _htResultNetwork = snapshot.data;
            //       final List<InkWell> htNetworks = <InkWell>[];
            //       for (var oNetwork in _htResultNetwork!) {
            //         print(170);
            //         if ((oNetwork!.ssid!).contains("KSU")) {
            //           //Rashd
            //           print(174);
            //           htNetworks.add(InkWell(
            //             child: Container(child: Text(oNetwork.ssid!)),
            //             onTap: () {
            //               WiFiForIoTPlugin.connect("${oNetwork.ssid}",
            //                   password: '0500991990',
            //                   joinOnce: true,
            //                   security: STA_DEFAULT_SECURITY);
            //               print(181);
            //             },
            //           ));
            //         }
            //       }
            //       return ListView(
            //         padding: kMaterialListPadding,
            //         children: htNetworks, //Display list of networks
            //       );
            //     } else {
            //       /// you handle others state like error while it will a widget no matter what, you can skip it
            //       return CircularProgressIndicator();
            //     }
            //   },
            // ),
          ])),
    );
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument);
}
