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

    var houseID = context.params.id;
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
          id: "123",
          type: "chat",
        },
        notification: {
          title: "Title",
          body: "Body",
          sound: "default",
        },
      };
      console.log(payload);
      //   const Token = data.data().token;
    //   console.log(Token);b
      fcm.sendToDevice(
        "c4BQlfekQyyTh8neLLI4sA:APA91bGKMNEDFlQghwgDtj_j1gxn-JyegDVHhdTDwXf7bksqF5al7Er6eGdUkM5ykBM8a4bsW2plA6PJuid3LZPa2F5yZrVvtjEqpN0a9KFh8NwFXZy1Plbl7He-D12KiQMpZWZ7VUDD",
        payload
      ); //return;

      var membersList = await admin
        .firestore()
        .collection("houseAccount")
        .doc(houseID)
        .collection("houseMember")
        .get();

    //   devicesList.forEach((doc) => {
    //     console.log(doc.id, "=>", doc.data());
    //     totalConsumption += doc.data().consumption;
    //   });
    }
  });
