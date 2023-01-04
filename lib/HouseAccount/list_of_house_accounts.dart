import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rashd/Devices/listOfDevices.dart';
import 'package:rashd/Registration/register.dart';
import 'package:rashd/Dashboard/dashboard.dart';
import 'package:rashd/Registration/profile.dart';
import 'package:rashd/Registration/welcomePage.dart';

import 'create_house_account.dart';

class ListOfHouseAccounts extends StatefulWidget {
  const ListOfHouseAccounts({super.key});

  @override
  State<ListOfHouseAccounts> createState() => _ListOfHouseAccountsState();
}

class _ListOfHouseAccountsState extends State<ListOfHouseAccounts> {
  int selectedIndex = 0;

  late PageController pageController;
  var userData;

  @override
  void initState() {
    userData = readUserData(FirebaseAuth.instance.currentUser!.uid);

    pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  String name = 'null';
  Future<Map<String, dynamic>> readUserData(var id) =>
      FirebaseFirestore.instance.collection('userAccount').doc(id).get().then(
        (DocumentSnapshot doc) {
          userData = doc.data() as Map<String, dynamic>;
          print(userData);

          return doc.data() as Map<String, dynamic>;
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
          future: readUserData(FirebaseAuth.instance.currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              userData = snapshot.data as Map<String, dynamic>;
              return Scaffold(
                appBar: AppBar(
                    title: Text(
                      '! مرحبًا ' + userData['full_name'],
                      textAlign: TextAlign.right,
                      // style: TextStyle(color),
                    ),
                    leading: const Text(''),
                    centerTitle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(40),
                        right: Radius.zero,
                      ),
                    ),
                    backgroundColor: Color.fromARGB(255, 194, 236, 255)),
                body: Container(
                  transformAlignment: Alignment.topRight,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(6, 12, 0, 12),
                          child: TextFormField(
                            readOnly: true,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: 'قائمة منازلي',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //border: InputBorder.none,
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateHouseAccount()),
                                  );
                                },
                              ),
                            ),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                          child: TextFormField(
                            // maxLength: 20,
                            readOnly: true,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: 'البيت',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0)),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => dashboard(
                                            ID: 'ffDQbRQQ8k9RzlGQ57FL')
                                        // const listOfDevices(
                                        //   ID: 'ffDQbRQQ8k9RzlGQ57FL',
                                        // )
                                        ),
                                  );
                                },
                              ),
                            ),
                          )),
                      // Container(
                      //     padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                      //     child: TextFormField(
                      //       // maxLength: 20,
                      //       readOnly: true,
                      //       textAlign: TextAlign.right,
                      //       decoration: InputDecoration(
                      //         hintText: 'المزرعة',
                      //         contentPadding:
                      //             const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide:
                      //                 const BorderSide(color: Colors.grey)),
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide:
                      //                 BorderSide(color: Colors.grey.shade400)),
                      //         errorBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.red, width: 2.0)),
                      //         focusedErrorBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.red, width: 2.0)),
                      //         prefixIcon: IconButton(
                      //           icon: const Icon(
                      //               // Based on passwordVisible state choose the icon
                      //               Icons.arrow_back_ios),
                      //           onPressed: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       const listOfDevices()),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     )),
                      // Container(
                      //     padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                      //     child: TextFormField(
                      //       // maxLength: 20,
                      //       readOnly: true,
                      //       textAlign: TextAlign.right,
                      //       decoration: InputDecoration(
                      //         hintText: 'الاستراحة',
                      //         contentPadding:
                      //             const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide:
                      //                 const BorderSide(color: Colors.grey)),
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide:
                      //                 BorderSide(color: Colors.grey.shade400)),
                      //         errorBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.red, width: 2.0)),
                      //         focusedErrorBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(100.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.red, width: 2.0)),
                      //         prefixIcon: IconButton(
                      //           icon: const Icon(
                      //               // Based on passwordVisible state choose the icon
                      //               Icons.arrow_back_ios),
                      //           onPressed: () {
                      //             // Navigator.push(
                      //             //   context,
                      //             //   MaterialPageRoute(
                      //             //       builder: (context) =>
                      //             //           const dashboard()),
                      //             // );
                      //           },
                      //         ),
                      //       ),
                      //     )),
                      // TextButton(
                      //   onPressed: () async {
                      //     await _signOut();
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.all(14),
                      //     child: const Text("Log out",
                      //         style: TextStyle(
                      //             color: Color.fromARGB(255, 164, 10, 10))),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                bottomNavigationBar: buildBottomNavigation(),
              );
            } else {
              return Text('');
            }
          }),
    );
  }

  int index = 0;
  Widget buildBottomNavigation() {
    return BottomNavyBar(
      selectedIndex: 0,
      onItemSelected: (index) {
        setState(
          () => this.index = index,
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
            'الملف الشخصي',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  navigateRoutes() {
    switch (index) {
      case 0:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListOfHouseAccounts()),
          );
          break;
        }
      case 1:
        {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const CreateHouseAccount()),
          // );
          break;
        }
    }
  }

  //! Logout
  Future<void> _signOut() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const welcomePage()));
    Future.delayed(const Duration(seconds: 1),
        () async => await FirebaseAuth.instance.signOut());
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   Workmanager().cancelAll();
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => const login()));
    //   Future.delayed(const Duration(seconds: 1),
    //       () async => await FirebaseAuth.instance.signOut());
    // });
  }
}
