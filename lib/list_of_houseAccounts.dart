import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'create_house_account.dart';
import 'dashboard.dart';

class ListOfHouseAccounts extends StatefulWidget {
  const ListOfHouseAccounts({super.key});

  @override
  State<ListOfHouseAccounts> createState() => _ListOfHouseAccountsState();
}

class _ListOfHouseAccountsState extends State<ListOfHouseAccounts> {
  String name = '';
  @override
  void initState() {
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
        .doc('XTVOlBbBjSbQA7VN9IOrCnbSU1h1')
        .get()
        .then((value) {
      name = value.data()!["full_name"];
    });
  }

  Future getOwner() async {
    var collection = await FirebaseFirestore.instance
        .collection('houseAccount')
        .where('OwnerID', isEqualTo: 'XTVOlBbBjSbQA7VN9IOrCnbSU1h1');

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
        .where('memberID', isEqualTo: 'XTVOlBbBjSbQA7VN9IOrCnbSU1h1')
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
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              print('name:$name');
              return Text(
                '!مرحبًا $name',
                textAlign: TextAlign.right,
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
      body: SingleChildScrollView(
          child: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
            padding: const EdgeInsets.fromLTRB(6, 12, 0, 12),
            child: TextFormField(
              // maxLength: 20,
              readOnly: true,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'قائمة منازلي',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                border: InputBorder.none,
                prefixIcon: IconButton(
                  icon: const Icon(
                      // Based on passwordVisible state choose the icon
                      Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateHouseAccount()),
                    );
                  },
                ),
              ),
            )),
      ])),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildBottomNavigation() {
    return BottomNavyBar(
      selectedIndex: global.index,
      onItemSelected: (index) {
        setState(
          () => global.index = index,
        );
        if (global.index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateHouseAccount()),
          );
        } else if (global.index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListOfHouseAccounts()),
          );
        }
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.person_outline_rounded),
          // icon: IconButton(
          //     icon: const Icon(Icons.person_outline_rounded),
          //     onPressed: () {
          //       setState(
          //         () => this.index = index,
          //       );
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const CreateHouseAccount()),
          //       );
          //     }),
          title: const Text(
            'الملف الشخصي',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
        BottomNavyBarItem(
            icon: const Icon(Icons.holiday_village_rounded),
            // icon: IconButton(
            //     icon: const Icon(Icons.holiday_village_rounded),
            //     onPressed: () {

            //       setState(
            //         () => this.index = index,
            //       );
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const ListOfHouseAccounts()),
            //       );
            //     }),
            title: const Text(
              'منازلي',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
