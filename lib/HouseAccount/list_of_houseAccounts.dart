import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:rashd/dashboard.dart';
import 'package:rashd/Dashboard/dashboard.dart';

import '../Notification/FCM.dart';
import '../Notification/localNotification.dart';
import '../Registration/profile.dart';
import '../create_house_account.dart';
import '../main.dart';

class ListOfHouseAccounts extends StatefulWidget {
  const ListOfHouseAccounts({super.key});

  @override
  State<ListOfHouseAccounts> createState() => _ListOfHouseAccountsState();
}

class _ListOfHouseAccountsState extends State<ListOfHouseAccounts>
    with TickerProviderStateMixin {
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

  NotificationService notificationService = NotificationService();
  late final PushNotification warningNotification = PushNotification();

  //! tapping local notification
  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        if (payload != null && payload.isNotEmpty) {
          Navigator.pushReplacement(
            GlobalContextService.navigatorKey.currentState!.context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => dashboard(
                ID: payload,
              ),
              transitionDuration: const Duration(seconds: 1),
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      });

  String userName = '';
  late TabController tabController;

  @override
  void initState() {
    warningNotification.initApp();

    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    tabController = TabController(
      length: 2,
      vsync: this,
    );

    getToken();

    setState(() {
      getData();
      getOwner();
      getMember();
    });
    super.initState();
  }

  List? houseOwner = [];
  List? houseMember = [];
  Future getData() async {
    await FirebaseFirestore.instance
        .collection("userAccount")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userName = value.data()!["full_name"];
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
            {'houseName': data['houseName'], 'houseID': data['houseID']}
          ]);
        });
      }
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
              {'houseName': data['houseName'], 'dashboardID': data['houseID']}
            ]);
          });
        }
      }
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

  var assetName = 'assets/images/house.svg';

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: [
        Positioned(
          bottom: height * 0,
          top: height * -1.25,
          left: width * 0.1,
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
        Column(children: [
          SizedBox(height: height * 0.02),
          Padding(
              padding: EdgeInsets.only(right: width * 0.05),
              child: Text('مرحبًا، $userName!',
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w600))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
                padding: EdgeInsets.only(right: width * 0.05),
                child: const Text('قائمة المنازل',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600))),
            Padding(
                padding: EdgeInsets.only(left: width * 0.02),
                child: IconButton(
                  color: Color(0xFF64B5F6),
                  iconSize: 40,
                  icon: const Icon(Icons.add_circle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateHouseAccount()),
                    );
                  },
                )),
          ]),
          SizedBox(height: height * 0.03),
          TabBar(
            controller: tabController,
            labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
            indicator: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [Colors.lightBlue.shade200, Colors.blue],
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            indicatorWeight: 5,
            indicatorPadding: const EdgeInsets.only(top: 47),
            tabs: const <Tab>[
              Tab(text: 'منازلي'),
              Tab(text: 'اشتراكاتي'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontSize: 19),
          ),
          Container(
              width: double.maxFinite,
              height: height * 0.8,
              child: TabBarView(controller: tabController, children: [
                buildItems(houseOwner, height, width),
                buildItems(houseMember, height, width)
              ])),
        ]),
      ]),
      bottomNavigationBar: buildBottomNavigation(height),
    );
  }

  Widget buildItems(dataList, height, width) {
    if (dataList.length > 0) {
      return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                // height: height * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 30,
                          color: Colors.black45,
                          spreadRadius: -10)
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                    trailing: const Icon(Icons.arrow_forward_ios),
                    leading: Text(
                      dataList[index][0]["houseName"],
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      print('houseID');
                      print(dataList[index][0]["houseID"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => dashboard(
                                ID: '0mHcZmbfEDK8CebdkVYR' // dataList[index][0]["houseID"],
                                )),
                      );
                    }));
          });
    }
    return Padding(
        padding: const EdgeInsets.all(38),
        child: SvgPicture.asset(assetName,
            width: width * 0.5, height: height * 0.5, semanticsLabel: 'House'));
  }

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
