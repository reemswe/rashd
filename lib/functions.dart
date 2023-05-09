import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'Dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'main.dart';

Future<Map<String, dynamic>> readHouseData(id, isShared, firestore) {
  if (!TestWidgetsFlutterBinding.ensureInitialized().inTest) {
    firestore.collection('houseAccount').doc(id).get().then(
      (DocumentSnapshot doc) async {
        return doc.data() as Map<String, dynamic>;
      },
    );
  }
  return Future.value({
    'OwnerID': 'testId',
    'houseID': 'testHouseId',
    'houseName': 'houseName',
    'isNotificationSent': false,
    'goal': '0',
    'totalConsumption': 0,
    'totalConsumptionPercentage': 0
  });
}

void showToast(type, message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
      backgroundColor:
          type == 'valid' ? Colors.green.shade400 : Colors.red.shade400,
      textColor: Colors.white);
}

Future<bool> exists(
    String number, FirebaseFirestore firestore, FirebaseAuth auth) async {
  QuerySnapshot query = await firestore
      .collection('userAccount')
      .where('phone_number', isEqualTo: number)
      .get();

  if (query.docs.isNotEmpty &&
      query.docs[0]['userId'] != auth.currentUser!.uid) {
    return true;
  } else if (query.docs.isNotEmpty &&
      query.docs[0]['userId'] == auth.currentUser!.uid) {
    showToast('invalid', 'العضو هو مالك المنزل');
    return false;
  } else {
    showToast('invalid', 'العضو غير موجود بالنطام');
    return false;
  }
}

//! Device functions
// Future<void> updateDeviceStatus(value, deviceID) async {
//   final database = FirebaseDatabase.instance.ref('devicesList/${deviceID}');
//   await database.update({'status': value});
// }

// Widget controlDeviceStatus(
//   deviceStatus,
//   deviceRealtimeID,
// ) {
//   return LiteRollingSwitch(
//     value: deviceStatus != 'disconnected'
//         ? (deviceStatus == 'ON' ? true : false)
//         : false,
//     textOn: deviceStatus == 'disconnected' ? "غير متصل" : 'On',
//     textOff: deviceStatus != 'disconnected' ? 'Off' : "غير متصل",
//     colorOn: deviceStatus == 'disconnected'
//         ? Colors.grey.shade600
//         : Colors.green.shade400,
//     colorOff: deviceStatus != 'disconnected'
//         ? Colors.red.shade400
//         : Colors.grey.shade600,
//     iconOn: deviceStatus == 'disconnected' ? Icons.cancel : Icons.done,
//     iconOff: deviceStatus == 'disconnected'
//         ? Icons.cancel
//         : Icons.remove_circle_outline,
//     textOnColor: Colors.white,
//     textSize: 16,
//     width: 130,
//     onChanged: (bool state) async {
//       if (deviceStatus != 'disconnected') {
//         await updateDeviceStatus(state ? "ON" : "OFF", deviceRealtimeID);
//       }
//     },
//     onTap: () {},
//     onSwipe: () {},
//     onDoubleTap: () {},
//   );
// }

// Future<Map<String, dynamic>> getDeviceRealtimeData(houseID, deviceID) async {
//   List<ChartData> chartData = [];
//   Map<String, dynamic> deviceData = {};
//   Completer<Map<String, dynamic>> completer = Completer();

//   await FirebaseFirestore.instance //retrieve id and color from firestore
//       .collection('houseAccount')
//       .doc(houseID)
//       .collection('houseDevices')
//       .doc(deviceID)
//       .get()
//       .then((DocumentSnapshot doc) async {
//     var finalColor =
//         Color(int.parse(doc['color'].split('(0x')[1].split(')')[0], radix: 16));
//     deviceData = {
//       'RealtimeID': doc['ID'],
//       'color': finalColor,
//       'name': doc['name']
//     };
//     final databaseRef =
//         FirebaseDatabase.instance.ref('devicesList/${doc["ID"]}/');

//     await databaseRef.onValue.listen((event) {
//       chartData.clear();

//       // Convert the retrieved data to a list of ChartData objects
//       Map<dynamic, dynamic>? data =
//           event.snapshot.value as Map<dynamic, dynamic>?;
//       if (data != null) {
//         data.forEach((key, values) {
//           if (key == 'status') {
//             deviceData['status'] = values;
//           } else if (key == 'consumption') {
//             deviceData['currCons'] = values['currentConsumption'];
//             var monthlyConsumption = values['monthlyConsumption'];
//             monthlyConsumption.forEach((key, values) {
//               String name = key;
//               double cons = values.toDouble();
//               ChartData chart = ChartData(
//                   name,
//                   cons,
//                   Color(int.parse(doc['color'].split('(0x')[1].split(')')[0],
//                       radix: 16)));
//               chartData.add(chart);
//             });
//             deviceData['monthlyConsumption'] = chartData;
//           } else if (key == 'temperature') {
//             deviceData['temperature'] = values;
//           }
//         });
//       }
//       // Resolve the completer when the variables have been updated
//       completer.complete(deviceData);
//     });
//   });
//   // Return the completer's future to wait for the variables to be updated
//   return completer.future;
// }

getCurrentConsumption(deviceID, realDB) {
  Completer<double> completer = Completer();
  double consum = 0;
  //get currentConsumption from realtime
  final databaseRef = realDB.ref('devicesList/${deviceID}/');
  databaseRef.onValue.listen((DatabaseEvent event) {
    Map<dynamic, dynamic>? data =
        event.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      data.forEach((key, values) {
        if (key == 'consumption') {
          print(values['currentConsumption']);
          consum = double.parse(values['currentConsumption'].toString());
        }
      });
    }
    completer.complete(consum);
  });
  return completer.future;
}

// getMonthlyConsumption(deviceID, selectedYearMonth) {
//   Completer<double> completer = Completer();
//   double consum = 0;
//   //get currentConsumption from realtime
//   final databaseRef = FirebaseDatabase.instance.ref('devicesList/${deviceID}/');
//   databaseRef.onValue.listen((DatabaseEvent event) {
//     Map<dynamic, dynamic>? data =
//         event.snapshot.value as Map<dynamic, dynamic>?;
//     if (data != null) {
//       data.forEach((key, values) {
//         if (key == 'consumption') {
//           var monthlyConsumption = values['monthlyConsumption'];
//           monthlyConsumption.forEach((key, values) {
//             if (key == selectedYearMonth) {
//               consum = values.toDouble();
//             }
//           });
//         }
//       });
//     }
//     completer.complete(consum);
//   });
//   return completer.future;
// }

// //! tapping local notification
// void listenToNotificationStream(notificationService) =>
//     notificationService.behaviorSubject.listen((payload) {
//       if (payload != null && payload.isNotEmpty) {
//         Navigator.pushReplacement(
//           GlobalContextService.navigatorKey.currentState!.context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation1, animation2) => dashboard(
//               houseID: payload,
//             ),
//             transitionDuration: const Duration(seconds: 1),
//             reverseTransitionDuration: Duration.zero,
//           ),
//         );
//       }
//     });
