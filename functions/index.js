const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const fcm = admin.messaging();

exports.sendWarningNotification = functions.firestore
  .document("houseAccount/{id}/houseDevices/{deviceId}")
  .onWrite(async (snapshot, context) => {
    console.log(snapshot.before.data());
    var houseID = context.params.id;
    var totalConsumption = 0;

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

    var house = await admin
      .firestore()
      .collection("houseAccount")
      .doc(houseID)
      .get();

    var totalConsumptionPercentage =
      (totalConsumption / house.data().goal) * 100;

    await admin.firestore().collection("houseAccount").doc(houseID).update({
      totalConsumption: totalConsumption,
      totalConsumptionPercentage: totalConsumptionPercentage,
    });

    if (totalConsumptionPercentage >= 75) {
      const payload = {
        data: {
          id: houseID,
          type: "warning",
        },
        notification: {
          title: "تحذير! استهلاك مرتفع",
          body:
            "إجمالي استهلاك الطاقة لـ " +
            house.data().houseName +
            " تجاوز 75% من الهدف.",
          sound: "default",
        },
      };
      console.log(payload);

      var houseOwner = await admin
        .firestore()
        .collection("userAccount")
        .doc(house.data().OwnerID)
        .get();

      console.log(houseOwner.data().token);

      fcm.sendToDevice(houseOwner.data().token, payload);

      var membersList = await admin
        .firestore()
        .collection("houseAccount")
        .doc(houseID)
        .collection("houseMember")
        .get();

      membersList.forEach(async (doc) => {
        console.log(doc.id, "=>", doc.data());
        var member = await admin
          .firestore()
          .collection("userAccount")
          .doc(doc.data().memberID)
          .get();
        fcm.sendToDevice(member.data().token, payload);
      });
    }
  });
