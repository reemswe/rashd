import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> readHouseData(var id) =>
    FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
      (DocumentSnapshot doc) {
        return doc.data() as Map<String, dynamic>;
      },
    );

    // Future<Map<String, dynamic>> readSharedData(var dashID) =>
//     FirebaseFirestore.instance.collection('dashboard').doc(dashID).get().then(
//       (DocumentSnapshot doc) {
//         FirebaseFirestore.instance
//             .collection("houseAccount")
//             .doc(doc["houseID"])
//             .get()
//             .then((value) {
//           sharedHouseName = value.data()!["houseName"];
//         });
//         return doc.data() as Map<String, dynamic>;
//       },
//     );
