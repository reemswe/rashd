const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const fcm = admin.messaging();

exports.sendChatNotification = functions.firestore
  .document("houseAccount/{id}/houseDevices/{deviceId}")
  .onWrite(async (snapshot, context) => {
    console.log(snapshot.data());
    const deviceData = snapshot.data();
    console.log(deviceData);
    console.log(deviceData.read);
    console.log(snapshot.ref.parent.parent.id);
    console.log(snapshot.ref.id);

    var houseID = snapshot.ref.parent.parent.id;
    if (
      new String(deviceData.text).valueOf() !=
      new String(
        "This chat offers Text to Speech service, please long press on the chat to try it."
      ).valueOf()
    ) {
      await admin
        .firestore()
        .collection("requests")
        .doc(houseID)
        .get()
        .then(async (snap) => {
          console.log(snap);
          if (!snap.exists) {
            console.log("No such Request document!");
          } else {
            console.log(snap);

            var receiverID =
              new String(snap.data().VolID).valueOf() ==
              new String(deviceData.author).valueOf()
                ? snap.data().userID
                : snap.data().VolID;
            await admin
              .firestore()
              .collection("users")
              .doc(receiverID)
              .get()
              .then((data) => {
                console.log(data);
                if (!snap.exists) {
                  console.log("No such User document!");
                } else {
                  console.log(data);
                  var name = data.data().name;
                  var Title = "New Chat from: " + name;
                  var Body =
                    new String(chatData.text).valueOf() ==
                    new String("").valueOf()
                      ? new String(chatData.audio).valueOf() ==
                        new String("").valueOf()
                        ? "Image"
                        : "Audio Chat"
                      : chatData.text;
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
                }
              });
          }
        });
    }
  });
