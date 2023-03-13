// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';

const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

class AddDevice extends StatefulWidget {
  final ID; //house ID
  const AddDevice({super.key, required this.ID});
  @override
  AddDeviceState createState() => AddDeviceState();
}

class AddDeviceState extends State<AddDevice> {
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

  Widget getNetworks(height, width) {
    //main widget, shows wifi info and disable, disconnect wifi
    // WiFiForIoTPlugin.isEnabled().then((val) {
    //   setState(() {
    //     _isEnabled = val;
    //   });
    // });
    if (_htResultNetwork != null && _htResultNetwork!.length > 0) {
      return Column(children: [
        const Text("الرجاء تحديد اسم الشبكة الذي يطابق معرف جهازك."),
        FutureBuilder<dynamic>(
          future: loadWifiList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              _htResultNetwork = snapshot.data;
              final List<InkWell> htNetworks = <InkWell>[];
              _htResultNetwork!.forEach((oNetwork) {
                final PopupCommand oCmdConnect =
                    PopupCommand("Connect", oNetwork!.ssid!);
                final List<PopupMenuItem<PopupCommand>> htPopupMenuItems = [];
                print(170);
                if ((oNetwork.ssid!).contains("Abo")) {
                  //Rashd
                  print(174);
                  htNetworks.add(InkWell(
                    child: Container(child: Text(oNetwork.ssid!)),
                    onTap: () {
                      WiFiForIoTPlugin.connect("${oNetwork.ssid}",
                          password: '0500991990',
                          joinOnce: true,
                          security: STA_DEFAULT_SECURITY);
                      print(181);
                    },
                  ));
                }
              });
              return Column(
                children: htNetworks, //Display list of networks
              );
            } else {
              /// you handle others state like error while it will a widget no matter what, you can skip it
              return CircularProgressIndicator();
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
      if (_isEnabled) {}
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
                child: getNetworks(height, width)),
            // FutureBuilder<dynamic>(
            //   future: loadWifiList(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done &&
            //         snapshot.hasData) {
            //       _htResultNetwork = snapshot.data;
            //       final List<InkWell> htNetworks = <InkWell>[];
            //       _htResultNetwork!.forEach((oNetwork) {
            //         final PopupCommand oCmdConnect =
            //             PopupCommand("Connect", oNetwork!.ssid!);
            //         final List<PopupMenuItem<PopupCommand>> htPopupMenuItems =
            //             [];
            //         print(170);
            //         if ((oNetwork.ssid!).contains("Abo")) {
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
            //       });
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
