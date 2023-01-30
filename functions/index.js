const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const fcm = admin.messaging();

exports.sendWarningNotification = functions.firestore
  .document("houseAccount/{id}/houseDevices/{deviceId}")
  .onWrite(async (snapshot, context) => {
    console.log(snapshot.before.data());
    // const deviceData = snapshot.data().original;
    // console.log(deviceData);
    // console.log(deviceData.read);
    // console.log(snapshot.ref.parent.parent.id);
    // console.log(snapshot.ref.id);

    var houseID = context.params.id; //snapshot.before.ref.parent.parent.id; //"ffDQbRQQ8k9RzlGQ57FL"; //snapshot.ref.parent.parent.id;
    var totalConsumption = 0;

    // collection.snapshots().listen((querySnapshot) => {
    //   print("i: $i and total: $total");
    //   total = total - i;
    //   print("t0tal after: $total");
    //   percentageStr = ((total / int.parse(userGoal)) * 100).toStringAsFixed(1);
    //   text[1][1] = "${total}kWh";
    //   percentage = (total / int.parse(userGoal)) * 100;
    //   i = total;
    //   print("i after: $i");
    // });

    var devicesList = await admin
      .firestore()
      .collection("houseAccount")
      .doc(houseID)
      .collection("houseDevices")
      .get();

    devicesList.forEach((doc) => {
      console.log(doc.id, "=>", doc.data());
      totalConsumption += doc.data().consumption;
    });

    var userGoal = await admin
      .firestore()
      .collection("houseAccount")
      .doc(houseID)
      .get();

    var totalConsumptionPercentage =
      (totalConsumption / userGoal.data().goal) * 100;

    await admin.firestore().collection("houseAccount").doc(houseID).update({
      totalConsumption: totalConsumption,
      totalConsumptionPercentage: totalConsumptionPercentage,
    });

    console.log(userGoal);

    if (totalConsumptionPercentage >= 75) {
      const payload = {
        data: {
          id: reqID,
          type: "chat",
        },
        notification: {
          title: Title,
          body: Body,
          sound: "default",
        },
      };
      console.log(payload);
      const Token = data.data().token;
      console.log(Token);
      return fcm.sendToDevice(Token, payload);

      var membersList = await admin
        .firestore()
        .collection("houseAccount")
        .doc(houseID)
        .collection("houseMember")
        .get();

      devicesList.forEach((doc) => {
        console.log(doc.id, "=>", doc.data());
        totalConsumption += doc.data().consumption;
      });
    }
    // await admin
    //   .firestore()
    //   .collection("requests")
    //   .doc(houseID)
    //   .get()
    //   .then(async (snap) => {
    //     console.log(snap);
    //     if (!snap.exists) {
    //       console.log("No such Request document!");
    //     } else {
    //       console.log(snap);
    //       var receiverID =
    //         new String(snap.data().VolID).valueOf() ==
    //         new String(deviceData.author).valueOf()
    //           ? snap.data().userID
    //           : snap.data().VolID;
    //       await admin
    //         .firestore()
    //         .collection("users")
    //         .doc(receiverID)
    //         .get()
    //         .then((data) => {
    //           console.log(data);
    //           if (!snap.exists) {
    //             console.log("No such User document!");
    //           } else {
    //             console.log(data);
    //             var name = data.data().name;
    //             var Title = "New Chat from: " + name;
    //             var Body =
    //               new String(chatData.text).valueOf() ==
    //               new String("").valueOf()
    //                 ? new String(chatData.audio).valueOf() ==
    //                   new String("").valueOf()
    //                   ? "Image"
    //                   : "Audio Chat"
    //                 : chatData.text;
    //             const payload = {
    //               data: {
    //                 id: reqID,
    //                 type: "chat",
    //               },
    //               notification: {
    //                 title: Title,
    //                 body: Body,
    //                 sound: "default",
    //               },
    //             };
    //             console.log(payload);
    //             const Token = data.data().token;
    //             console.log(Token);
    //             return fcm.sendToDevice(Token, payload);
    //           }
    //         });
    //     }
    //   });
  });
