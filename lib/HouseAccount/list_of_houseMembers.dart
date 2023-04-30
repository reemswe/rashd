import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import '../Dashboard/dashboard.dart';
import '../Devices/listOfDevices.dart';
import '../functions.dart';
import 'add_house_member.dart';
import 'list_of_houseAccounts.dart';

class HouseMembers extends StatefulWidget {
  var firestore, auth;

  final String houseId;
  HouseMembers(
      {super.key,
      required this.houseId,
      this.firestore = null,
      this.auth = null});

  @override
  State<HouseMembers> createState() => _houseMembersState();
}

class _houseMembersState extends State<HouseMembers> {
  Future? data;
  List? membersList = [];
  @override
  void initState() {
    if (!TestWidgetsFlutterBinding.ensureInitialized().inTest) {
      widget.firestore = FirebaseFirestore.instance;
      widget.auth = FirebaseAuth.instance;
    }
    data = getData();
    membersList!.clear();
    super.initState();
  }

  Future getData() async {
    var collection = await widget.firestore
        .collection('houseAccount')
        .doc(widget.houseId)
        .collection('houseMember');

    // to get data from all documents sequentially
    collection.snapshots().listen((querySnapshot) {
      membersList!.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data(); // <-- Retrieving the value.
        setState(() {
          membersList!.add([
            {
              'docId': data['docId'],
              'nickName': data['nickName'],
              'privilege': data['privilege'],
            }
          ]);
        });
      }
    });
    return membersList;
  }

  List dataList = [];
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<Map<String, dynamic>>(
        future: readHouseData(widget.houseId, false, widget.firestore),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var houseData = snapshot.data as Map<String, dynamic>;
            return Scaffold(
              body: Container(
                transformAlignment: Alignment.topRight,
                child: Stack(children: [
                  Positioned(
                    bottom: height * 0,
                    top: height * -1.4,
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
                  FutureBuilder(
                    future: data,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                          "Something went wrong",
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        dataList = snapshot.data as List;

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.02),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.01, 5, width * 0.05, 5),
                                  child: Wrap(
                                      direction: Axis.vertical,
                                      spacing: 1,
                                      children: <Widget>[
                                        SizedBox(height: height * 0.02),
                                        Row(children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.arrow_back_ios),
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListOfHouseAccounts(),
                                                  ));
                                            },
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  houseData['houseName'],
                                                  style: const TextStyle(
                                                    letterSpacing: 1.2,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    height: 1,
                                                  ),
                                                ),
                                                Text(
                                                  (houseData['OwnerID'] ==
                                                          widget.auth
                                                              .currentUser!.uid
                                                      ? 'مالك المنزل'
                                                      : "عضو في المنزل"),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    height: 1,
                                                  ),
                                                )
                                              ])
                                        ]),
                                      ])),
                              SizedBox(height: height * 0.01),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        child: Text(
                                          "قائمة الأعضاء",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                          ),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: IconButton(
                                          iconSize: 33,
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                enableDrag: false,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                  top: Radius.circular(105.0),
                                                )),
                                                builder: (context) =>
                                                    add_house_member(
                                                        houseID:
                                                            widget.houseId));
                                          },
                                        )),
                                  ]),
                              buildItems(dataList, width, height)
                            ]);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ]),
              ),
              bottomNavigationBar: buildBottomNavigation(
                  height, houseData['OwnerID'] == widget.auth.currentUser!.uid),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  // builds the list to show house members
  Widget buildItems(dataList, width, height) => ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(
          width * 0.03, height * 0.003, width * 0.03, height * 0.03),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        Widget icon = const Icon(PhosphorIcons.binoculars);
        if (dataList[index][0]["privilege"] == 'editor') {
          icon = Icon(Icons.edit_note_outlined);
        }
        return Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.005, 0, height * 0.005),
            margin: EdgeInsets.fromLTRB(0, height * 0.00, 0, height * 0.009),
            decoration: BoxDecoration(
              // border: Border.all(color: Color(0xff940D5A)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(13.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8.0)
              ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: width * 0.01),
                  Text(
                    dataList[index][0]["nickName"],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: width * 0.5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        icon,
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                          //delet house member
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text(
                                  "حذف عضو من المنزل ",
                                  textAlign: TextAlign.center,
                                ),
                                content: const Text(
                                  "هل أنت متأكد من أنك تريد حذف العضو؟",
                                  textAlign: TextAlign.left,
                                ),
                                actions: <Widget>[
                                  //delet
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                      print("inside delete");
                                      await widget.firestore
                                          .collection('houseAccount')
                                          .doc(widget.houseId)
                                          .collection('houseMember')
                                          .get()
                                          .then((snapshot) {
                                        List<DocumentSnapshot> allDocs =
                                            snapshot.docs;
                                        List<DocumentSnapshot> filteredDocs =
                                            allDocs
                                                .where((document) =>
                                                    (document.data() as Map<
                                                        String,
                                                        dynamic>)['docId'] ==
                                                    dataList[index][0]
                                                        ["docId"]) // member ID
                                                .toList();
                                        for (DocumentSnapshot ds
                                            in filteredDocs) {
                                          ds.reference.delete().then((_) {
                                            print("member delete deleted");
                                            showToast(
                                                'valid', 'تم حذف العضو بنجاح ');
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("حذف",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 164, 10, 10))),
                                    ),
                                  ),
                                  //cancel button
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      child: const Text(
                                        "تراجع",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ]),
                ]));
      });

  int index = 2;
  Widget buildBottomNavigation(height, isOwner) {
    var items = isOwner
        ? <BottomNavyBarItem>[
            BottomNavyBarItem(
                icon: const Icon(Icons.bar_chart_rounded),
                title: const Text(
                  'لوحة المعلومات',
                  textAlign: TextAlign.center,
                ),
                activeColor: Colors.lightBlue),
            BottomNavyBarItem(
              icon: const Icon(Icons.electrical_services_rounded),
              title: const Text(
                'الأجهزة',
                textAlign: TextAlign.center,
              ),
              activeColor: Colors.lightBlue,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.people_alt_rounded),
              title: const Text(
                'اعضاء المنزل',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ]
        : <BottomNavyBarItem>[
            BottomNavyBarItem(
                icon: const Icon(Icons.bar_chart_rounded),
                title: const Text(
                  'لوحة المعلومات',
                  textAlign: TextAlign.center,
                ),
                activeColor: Colors.lightBlue),
            BottomNavyBarItem(
              icon: const Icon(Icons.electrical_services_rounded),
              title: const Text(
                'الأجهزة',
                textAlign: TextAlign.center,
              ),
              activeColor: Colors.lightBlue,
            ),
          ];

    return BottomNavyBar(
        containerHeight: height * 0.07,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: index,
        iconSize: 28,
        onItemSelected: (index) {
          setState(
            () => index = index,
          );
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => dashboard(
                        houseID: widget.houseId,
                      )),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListOfDevices(
                        houseID: widget.houseId,
                        userType: 'owner',
                      )),
            );
          } else if (index == 2) {}
        },
        items: items);
  }
}
