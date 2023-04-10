import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Dashboard/dashboard.dart';
import 'Devices/listOfDevices.dart';
import 'HouseAccount/list_of_houseMembers.dart';

Future<Map<String, dynamic>> readHouseData(id, uid, isShared) =>
    FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
      (DocumentSnapshot doc) async {
        userType = await getUserType(id, uid, isShared);
        return doc.data() as Map<String, dynamic>;
      },
    );

Future<String> getUserType(houseID, uid, isShared) async {
  if (!isShared) {
    await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(houseID)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        if (['OwnerID'] == uid) {
          return 'owner';
        } else {
          FirebaseFirestore.instance
              .collection('houseAccount')
              .doc(houseID)
              .collection('houseMember')
              .snapshots()
              .listen((querySnapshot) {
            for (var doc in querySnapshot.docs) {
              if (doc['memberID'] == uid) {
                return doc['privilege'];
              }
            }
          });
        }
      },
    );
  }
  return 'visitor';
}

Future<void> updateDeviceStatus(value, deviceID) async {
  final database = FirebaseDatabase.instance.ref('devicesList/${deviceID}');
  await database.update({'status': value});
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
