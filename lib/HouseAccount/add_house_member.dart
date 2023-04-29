import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rashd/Dashboard/dashboard.dart';
import 'package:rashd/functions.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Devices/listOfDevices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'list_of_houseAccounts.dart';
import 'list_of_houseMembers.dart';

class add_house_member extends StatefulWidget {
  final houseID;
  const add_house_member({super.key, required this.houseID});
  @override
  add_house_memberState createState() => add_house_memberState();
}

class add_house_memberState extends State<add_house_member> {
  TextEditingController houseName = TextEditingController();
  TextEditingController membersPhoneNumber1 = TextEditingController();
  TextEditingController membersNames1 = TextEditingController();
  ScrollController list = ScrollController();
  String privilege_edit = 'viewer', privilege = '', ErorrMes = 'العضو :';
  var privilege_index = 1;

  final _formKey = GlobalKey<FormState>();
  void clearText() {
    membersPhoneNumber1.clear();
    membersNames1.clear();
    privilege_edit = 'viewer';
    privilege = '';
    privilege_index = 1;
  }

  @override
  void initState() {
    setState(() {
      clearText();
      privilege_index = 1;
      privilege_edit = 'viewer';
      privilege = 'viewer';
    });
    super.initState();
  }

  Future<Map<String, dynamic>> readHouseData(var id) =>
      FirebaseFirestore.instance.collection('houseAccount').doc(id).get().then(
        (DocumentSnapshot doc) {
          return doc.data() as Map<String, dynamic>;
        },
      );

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return FutureBuilder<Map<String, dynamic>>(
        future: readHouseData(widget.houseID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var houseData = snapshot.data as Map<String, dynamic>;
            return DraggableScrollableSheet(
                maxChildSize: 0.9,
                minChildSize: 0.9,
                initialChildSize: 0.9,
                builder: (_, controller) => Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      child: Stack(children: [
                        Positioned(
                          bottom: height * -1.3,
                          top: height * 0,
                          left: width * 0.01,
                          child: Container(
                            width: width * 1.5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [
                                  Colors.lightBlue.shade100,
                                  Colors.lightBlue.shade200
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blue.shade100,
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 10.0)
                                ]),
                          ),
                        ),
                        Positioned(
                          bottom: height * -1.5,
                          top: height * 0,
                          left: width * 0.01,
                          child: Container(
                            width: width * 1.5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [
                                  Colors.lightBlue.shade200,
                                  Colors.blue
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blue.shade100,
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 10.0)
                                ]),
                          ),
                        ),
                        Positioned(
                            width: 50,
                            height: 50,
                            top: height * 0.01,
                            right: width * 0.05,
                            child: IconButton(
                              iconSize: 30,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 60),
                              onPressed: () {
                                clearText();
                                Navigator.of(context).pop();
                              },
                            )),
                        Positioned(
                            width: width,
                            height: 50,
                            top: height * 0.03,
                            right: width * 0.15,
                            child: const Text(
                              'إضافة عضو للمنزل',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.08,
                              left: width * 0.06,
                              right: width * 0.06),
                          child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                controller: list,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: height * 0.035,
                                    ),
                                    const Text(
                                      'اسم العضو',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: height * 0.005),
                                    TextFormField(
                                      controller: membersNames1,
                                      textAlign: TextAlign.right,
                                      maxLength: 20,
                                      decoration: const InputDecoration(
                                        hintText: 'الاسم',
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().isEmpty) {
                                          return 'الرجاء ادخال اسم للعضو ';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: height * 0.01),
                                    const Text(
                                      'رقم الهاتف',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: height * 0.005),
                                    TextFormField(
                                      controller: membersPhoneNumber1,
                                      maxLength: 10,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: 'رقم الهاتف',
                                        contentPadding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().isEmpty) {
                                          return 'الرجاء ادخال رقم للهاتف';
                                        }
                                        if (value.length < 10) {
                                          return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: height * 0.01),
                                    const Text(
                                      'الصلاحية',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: height * 0.005),
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 15),
                                      child: ToggleSwitch(
                                        icons: const [
                                          Icons.edit_note_outlined,
                                          PhosphorIcons.binoculars
                                        ],
                                        minWidth: width * 0.436,
                                        minHeight: height * 0.055,
                                        borderWidth: 1,
                                        borderColor: [
                                          Colors.blue.shade400,
                                          Colors.blue.shade400
                                        ],
                                        iconSize: 25,
                                        customTextStyles: const [
                                          TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                          ),
                                          TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                          )
                                        ],
                                        initialLabelIndex: privilege_index,
                                        cornerRadius: 20.0,
                                        inactiveBgColor: Colors.white,
                                        totalSwitches: 2,
                                        labels: const ['   محرر', '   مشاهد'],
                                        activeBgColors: [
                                          [Colors.blue.shade400],
                                          [Colors.blue.shade400],
                                        ],
                                        onToggle: (index) {
                                          if (index == 0) {
                                            privilege_index = 0;
                                            privilege_edit = 'editor';
                                            setState(() {
                                              privilege = 'editor';
                                            });
                                          } else {
                                            privilege_index = 1;
                                            privilege_edit = 'viewer';
                                            setState(() {
                                              privilege = 'viewer';
                                            });
                                          }
                                        },
                                      ),
                                    )),
                                    SizedBox(height: height * 0.04),
                                    Container(
                                        width: width * 0.5,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 4),
                                                blurRadius: 5.0)
                                          ],
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            stops: [0.1, 1.0],
                                            colors: [
                                              Colors.blue.shade200,
                                              Colors.blue.shade400,
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            bool flag_exists = true;
                                            bool flag_owner = true;
                                            bool flag_notMember = true;
                                            if (!_formKey.currentState!
                                                .validate()) {
                                            } else {
                                              if (await exists(
                                                      membersPhoneNumber1
                                                          .text) ==
                                                  false) {
                                                flag_exists = false;
                                              }
                                              if (await notMember(
                                                      membersPhoneNumber1
                                                          .text) ==
                                                  false) {
                                                flag_notMember = false;
                                              }
                                              if (await notOwner(
                                                      membersPhoneNumber1
                                                          .text) ==
                                                  false) {
                                                flag_owner = false;
                                              }
                                              if (flag_exists == false) {
                                                showToast('invalid',
                                                    'العضو غير موجود بالنطام');
                                              } else if (flag_owner == false) {
                                                showToast('invalid',
                                                    'لا يمكن اضافة مالك المنزل كعضو');
                                              } else if (flag_notMember ==
                                                  false) {
                                                showToast('invalid',
                                                    'العضو مضاف بالفعل الى المنزل');
                                              } else {
                                                setData();
                                                showToast('valid',
                                                    'تم الإضافة بنجاح');
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HouseMembers(
                                                              houseId: widget
                                                                  .houseID),
                                                    ));
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: const Text('إضافة'),
                                        )),
                                  ],
                                ),
                              )),
                        ),
                      ]),
                    ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> setData() async {
    CollectionReference houses = FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.houseID)
        .collection('houseMember');

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('userAccount')
        .where('phone_number', isEqualTo: membersPhoneNumber1.text)
        .get();
    var userID = query.docs[0]['userId'];

    DocumentReference docReference = await houses.add({
      "memberID": userID,
      'memberPhoneNumber': membersPhoneNumber1.text,
      'nickName': membersNames1.text,
      'privilege': privilege,
      'docId': ''
    });
    houses.doc(docReference.id).update({'docId': docReference.id.toString()});
    setState(() {
      clearText();
    });
  }
  Future<bool> notMember(String number) async {
    bool validPhone = false;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.houseID)
        .collection('houseMember')
        .where('memberPhoneNumber', isEqualTo: number)
        .get();
    if (query.docs.isNotEmpty) {
      print('member exist!!');
      validPhone = false;
    } else {
      validPhone = true;
    }
    return validPhone;
  }
  Future<bool> notOwner(String number) async {
    bool validPhone = false;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('userAccount')
        .where('phone_number', isEqualTo: number)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (query.docs.isNotEmpty) {
      validPhone = false;
      print('is owner');
    } else {
      validPhone = true;
    }
    print(validPhone);
    return validPhone;
  }

  int index = 2;
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
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboard(
                      houseID: widget.houseID,
                    )),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListOfDevices(
                      houseID: widget.houseID,
                      userType: 'owner',
                    )),
          );
        } else if (index == 2) {}
      },
      items: <BottomNavyBarItem>[
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
      ],
    );
  }
}
