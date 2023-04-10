import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        if (await exixts(houseID)) {
          setState(() {
            houseMember!.add([
              {'houseName': data['houseName'], 'houseID': data['houseID']}
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
          SizedBox(height: height * 0.05),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(right: width * 0.05),
                  child: Text('مرحبًا، $userName!',
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)))),
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
                  color: const Color(0xFF64B5F6),
                  iconSize: 40,
                  icon: const Icon(Icons.add_circle),
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        backgroundColor: Colors.transparent,
                        context: context,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                          top: Radius.circular(105.0),
                        )),
                        builder: (context) => const CreateHouseAccount());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const CreateHouseAccount()),
                    // );
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
                stops: const [0.0, 1.0],
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
          Expanded(
              child: TabBarView(controller: tabController, children: [
            buildItems("O", houseOwner, height, width),
            buildItems("M", houseMember, height, width)
          ])),
        ]),
      ]),
      bottomNavigationBar: buildBottomNavigation(height),
    );
  }

  Widget buildItems(type, dataList, height, width) {
    if (dataList.length > 0) {
      return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.all(8),
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    iconSize: 35,
                    color: Color.fromARGB(255, 122, 3, 3),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text(
                            "هل أنت متأكد ؟",
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            "هل أنت متأكد من أنك تريد حذف المنزل ؟ ",
                            textAlign: TextAlign.end,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text(
                                  "إلغاء",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                if (type == 'M') {
                                  print("inside member");
                                  await FirebaseFirestore.instance
                                      .collection('houseAccount')
                                      .doc(dataList[index][0]["houseID"])
                                      .collection('houseMember')
                                      .get()
                                      .then((snapshot) {
                                    List<DocumentSnapshot> allDocs =
                                        snapshot.docs;
                                    List<DocumentSnapshot> filteredDocs =
                                        allDocs
                                            .where((document) =>
                                                (document.data() as Map<String,
                                                    dynamic>)['memberID'] ==
                                                'TOd45A8GUpbgWLVCTOvHTaKF4CB3') // member ID
                                            .toList();
                                    for (DocumentSnapshot ds in filteredDocs) {
                                      ds.reference.delete().then((_) {
                                        print("member delete deleted");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('تم حذف  المنزل بنجاح '),
                                        ));
                                      });
                                    }
                                  });
                                } else {
                                  //if user is owner !
                                  print("inside Owner");
                                  //Delete house account
                                  await FirebaseFirestore.instance
                                      .collection('houseAccount')
                                      .get()
                                      .then((snapshot) async {
                                    List<DocumentSnapshot> allDocs =
                                        snapshot.docs;
                                    List<DocumentSnapshot> filteredDocs =
                                        allDocs
                                            .where((document) =>
                                                (document.data() as Map<String,
                                                    dynamic>)['houseID'] ==
                                                dataList[index][0][
                                                    "houseID"]) // tile list house ID
                                            .toList();
                                    for (DocumentSnapshot ds in filteredDocs) {
                                      //**********************************************************************
                                      //delete dashboard
                                      await FirebaseFirestore.instance
                                          .collection('dashboard')
                                          .get()
                                          .then((snapshot) async {
                                        List<DocumentSnapshot> dash_allDocs =
                                            snapshot.docs;
                                        List<DocumentSnapshot>
                                            dash_filteredDocs = dash_allDocs
                                                .where((document) =>
                                                    (document.data() as Map<
                                                        String,
                                                        dynamic>)['houseID'] ==
                                                    dataList[index][0]
                                                        ["houseID"])
                                                .toList();
                                        for (DocumentSnapshot dash_ds
                                            in dash_filteredDocs) {
                                          //delete dashboard_readings
                                          await FirebaseFirestore.instance
                                              .collection('dashboard')
                                              .doc(dash_ds['dashboardID'])
                                              .collection('dashboard_readings')
                                              .get()
                                              .then((snapshot) {
                                            for (DocumentSnapshot dash_ds
                                                in snapshot.docs) {
                                              dash_ds.reference.delete();
                                            }
                                          });
                                          print("dashboard_readings deleted");

                                          //delete sharedCode
                                          await FirebaseFirestore.instance
                                              .collection('dashboard')
                                              .doc(dash_ds['dashboardID'])
                                              .collection('sharedCode')
                                              .get()
                                              .then((snapshot) {
                                            for (DocumentSnapshot dash_ds
                                                in snapshot.docs) {
                                              dash_ds.reference.delete();
                                            }
                                          });
                                          print("dashboard sharecode deleted");

                                          dash_ds.reference.delete().then((_) {
                                            print("dashboard deleted");
                                          });
                                        }
                                      });
                                      //**********************************************************************
                                      //delete house account devices
                                      await FirebaseFirestore.instance
                                          .collection('houseAccount')
                                          .doc(ds['houseID'])
                                          .collection('houseDevices')
                                          .get()
                                          .then((snapshot) {
                                        for (DocumentSnapshot ds
                                            in snapshot.docs) {
                                          ds.reference.delete();
                                        }
                                      });
                                      print("house account devices deleted");

                                      //delete house account members
                                      await FirebaseFirestore.instance
                                          .collection('houseAccount')
                                          .doc(ds['houseID'])
                                          .collection('houseMember')
                                          .get()
                                          .then((snapshot) {
                                        for (DocumentSnapshot ds
                                            in snapshot.docs) {
                                          ds.reference.delete();
                                        }
                                      });
                                      print("house account members deleted");

                                      ds.reference.delete().then((_) {
                                        print("house account deleted");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('تم حذف  المنزل بنجاح '),
                                        ));
                                      });
                                    }
                                  });
                                } //else end
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text("حذف",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 124, 18, 18))),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  leading: Text(
                    dataList[index][0]["houseName"],
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    print('houseID');
                    print(dataList[index][0]["houseID"]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => dashboard(
                                ID: dataList[index][0]
                                    ["houseID"], //'0mHcZmbfEDK8CebdkVYR' //
                              )),
                    );
                  }),
          });
    }
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
          padding:
              EdgeInsets.fromLTRB(width * 0.15, height * 0.2, width * 0.15, 10),
          child: SvgPicture.asset(assetName,
              width: width * 0.7, semanticsLabel: 'House')),
      SizedBox(height: height * 0.02),
      type == "M"
          ? const Text("عذرا ، لم تتم إضافتك إلى أي منزل كعضو.",
              style: TextStyle(fontSize: 17))
          : Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text("عذرا ، ليس لديك منازل حاليا ، قم ",
                  style: TextStyle(fontSize: 17)),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateHouseAccount(),
                        ));
                  },
                  child: const Text("بإنشاء حساب منزل",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          decoration: TextDecoration.underline))),
              const Text(" الان.", style: TextStyle(fontSize: 17)),
            ]))
    ]);
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
