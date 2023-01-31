import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
// import 'package:rashd/dashboard.dart';
import 'package:rashd/Dashboard/dashboard.dart';

import '../Registration/profile.dart';
import '../create_house_account.dart';

class ListOfHouseAccounts extends StatefulWidget {
  const ListOfHouseAccounts({super.key});

  @override
  State<ListOfHouseAccounts> createState() => _ListOfHouseAccountsState();
}

class _ListOfHouseAccountsState extends State<ListOfHouseAccounts> {
  String name = '';

  //! FCM
  var fcmToken;
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      setState(() {
        fcmToken = token;
        print('fcmToken: $fcmToken');
      });
      await FirebaseFirestore.instance
          .collection('userAccount')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));
    });

    await FirebaseMessaging.instance.onTokenRefresh
        .listen((String token) async {
      print("New token: $token");
      await FirebaseFirestore.instance
          .collection('userAccount')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));
    });
  }

  @override
  void initState() {
    getToken();

    setState(() {
      getData();

      owner = getOwner();
      member = getMember();
    });
    super.initState();
  }

  Future? owner;
  Future? member;

  List? houseOwner = [];
  List? houseMember = [];
  Future getData() async {
    await FirebaseFirestore.instance
        .collection("userAccount")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      name = value.data()!["full_name"];
    });
  }

  Future getOwner() async {
    var collection = await FirebaseFirestore.instance
        .collection('houseAccount')
        .where('OwnerID', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    // to get data from all documents sequentially
    collection.snapshots().listen((querySnapshot) {
      houseOwner!.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data(); // <-- Retrieving the value.

        setState(() {
          houseOwner!.add([
            {'houseName': data['houseName'], 'dashboardID': data['dashboardID']}
          ]);
        });
      }
      print('houseOwn: $houseOwner');
    });

    return houseOwner;
  }

  Future getMember() async {
    var collection =
        await FirebaseFirestore.instance.collection('houseAccount');
    collection.snapshots().listen((querySnapshot) async {
      houseMember!.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data(); // house account info
        String houseID = data['houseID'];
        print('house id= $houseID');
        if (await exixts(houseID)) {
          setState(() {
            houseMember!.add([
              {
                'houseName': data['houseName'],
                'dashboardID': data['dashboardID']
              }
            ]);
          });
        }
      }
      print('helooooooo');
      print('housemem: $houseMember');
    });
    return houseMember;
  }

  Future<bool> exixts(String id) async {
    bool exists = false;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(id)
        .collection('houseMember')
        .where('memberID',
            isEqualTo: FirebaseAuth
                .instance.currentUser!.uid) //there is a logical error here
        .get();
    if (query.docs.isNotEmpty) {
      exists = true;
    } else {
      exists = false;
    }

    return exists;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  print('name:$name');
                  return Text(
                    '!مرحبًا $name',
                  );
                }),
            leading: const Text(''),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(40),
                right: Radius.zero,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 119, 201, 239),
          ),
          body: SafeArea(
              child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SegmentedTabControl(
                // Customization of widget

                backgroundColor: Colors.grey[100],
                indicatorColor: Colors.grey[400],
                tabTextColor: Colors.black45,
                selectedTabTextColor: Colors.white,
                squeezeIntensity: 2,
                height: 45,

                tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: Theme.of(context).textTheme.bodyText1,
                // Options for selection
                // All specified values will override the [SegmentedTabControl] setting
                tabs: const [
                  SegmentTab(
                    label: 'منازلي',
                  ),
                  SegmentTab(
                    label: 'اشتراكاتي',
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 70),
                child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: TextFormField(
                                // maxLength: 20,
                                readOnly: true,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    border: InputBorder.none,
                                    suffixIcon: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              // Based on passwordVisible state choose the icon
                                              Icons.add),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CreateHouseAccount()),
                                            );
                                          },
                                        ),
                                        Text('إضافة منزل جديد',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    )),
                              )),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: FutureBuilder(
                                future: owner,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text(
                                      "Something went wrong",
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    houseOwner = snapshot.data as List;
                                    print(houseOwner);
                                    return buildItems(houseOwner);
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              )),
                        ],
                      ),
                      FutureBuilder(
                        future: member,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text(
                              "Something went wrong",
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            houseMember = snapshot.data as List;
                            print(houseMember);

                            return buildItems(houseMember);
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ]))
          ])),
          bottomNavigationBar: buildBottomNavigation(height),
        ));
  }

  Widget buildItems(dataList) => ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: dataList.length,
      // separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            decoration: BoxDecoration(
              // border: Border.all(color: Color(0xff940D5A)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(13.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 6.0),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: ListTile(
                trailing: Text(
                  dataList[index][0]["houseName"],
                ),
                leading: const Icon(Icons.arrow_back_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => dashboard(
                              ID: dataList[index][0]["dashboardID"],
                            )),
                  );
                }));
      });

  int index = 0;
  Widget buildBottomNavigation(height) {
    return BottomNavyBar(
      containerHeight: height * 0.07,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      selectedIndex: index,
      iconSize: 28,
      onItemSelected: (index) {
        setState(
          () => index = index,
        );
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const profile()),
          );
        } else if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListOfHouseAccounts()),
          );
        }
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            icon: const Icon(Icons.holiday_village_rounded),
            title: const Text(
              'منازلي',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
        BottomNavyBarItem(
          icon: const Icon(Icons.person_outline_rounded),
          title: const Text(
            'حسابي',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
      ],
    );
  }
}
