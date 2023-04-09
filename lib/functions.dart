import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<Map<String, dynamic>> readHouseData(var id) =>
    FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
      (DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
      },
    );

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
