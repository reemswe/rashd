// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
// import 'package:flutter_test/flutter_test.dart';
import '../functions.dart';
import 'list_of_houseAccounts.dart';

class CreateHouseAccount extends StatefulWidget {
  var firestore, auth;

  CreateHouseAccount({super.key, this.firestore = null, this.auth = null});

  @override
  State<CreateHouseAccount> createState() => _CreateHouseAccountState();
}

class _CreateHouseAccountState extends State<CreateHouseAccount> {
  List<Widget> addMembers = [];
  List<bool> duplicates = [true, true, true, true, true];
  String existing = '';
  TextEditingController houseName = TextEditingController();
  List indexes = ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'];
  ScrollController list = ScrollController();
  List<TextEditingController> membersNames = [];
  TextEditingController membersNames1 = TextEditingController();
  TextEditingController membersNames2 = TextEditingController();
  TextEditingController membersNames3 = TextEditingController();
  TextEditingController membersNames4 = TextEditingController();
  TextEditingController membersNames5 = TextEditingController();
  TextEditingController membersPhoneNumber1 = TextEditingController();
  TextEditingController membersPhoneNumber2 = TextEditingController();
  TextEditingController membersPhoneNumber3 = TextEditingController();
  TextEditingController membersPhoneNumber4 = TextEditingController();
  TextEditingController membersPhoneNumber5 = TextEditingController();
  List<TextEditingController> membersPhones = [];
  int num = 0;
  //toggle swithc
  String privilege_edit = 'viewer', privilege = '';

  String privilege_edit2 = 'viewer', privilege2 = '';
  var privilege_index = 1;
  var privilege_index2 = 1;
  //toggle switch

  List roles = ['viewer', 'viewer', 'viewer', 'viewer', 'viewer'];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // if (!TestWidgetsFlutterBinding.ensureInitialized().inTest) {
    // FirebaseFirestore.instance = FirebaseFirestore.instance;
    // FirebaseAuth.instance = FirebaseAuth.instance;
    // }
    addMembers = [];
    setState(() {
      createList();
      clearText();
      //toggle switch
      privilege_index = 1;
      privilege_edit = 'viewer';
      privilege = 'viewer';
      privilege_index2 = 1;
      privilege_edit2 = 'viewer';
      privilege2 = 'viewer';
      //toggle switch
    });
    super.initState();
  }

  void addMemberWidget(height, width) {
    setState(() {
      addMembers.add(members(height, width));
    });
  }

  void createList() {
    setState(() {
      membersPhones.add(membersPhoneNumber1);
      membersPhones.add(membersPhoneNumber2);
      membersPhones.add(membersPhoneNumber3);
      membersPhones.add(membersPhoneNumber4);
      membersPhones.add(membersPhoneNumber5);
      membersNames.add(membersNames1);
      membersNames.add(membersNames2);
      membersNames.add(membersNames3);
      membersNames.add(membersNames4);
      membersNames.add(membersNames5);
    });
  }

  Widget members(height, width) {
    num++;

    String place = indexes[num];
    setState(() {
      privilege_edit2 = 'viewer';
      privilege2 = 'viewer';
      privilege_index2 = 1;
    });

    return Column(children: <Widget>[
      SizedBox(height: height * 0.04),
      Container(
        margin: EdgeInsets.only(left: width * 0.56),
        padding: EdgeInsets.only(top: height * 0.004, bottom: height * 0.004),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.lightBlue.shade100,
        ),
        alignment: Alignment.center,
        child: Text('عضو المنزل $place',
            style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                height: 1,
                fontWeight: FontWeight.w300)),
      ),
      SizedBox(height: height * 0.01),
      TextFormField(
        maxLength: 20,
        controller: membersNames[num],
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'الاسم ',
          suffixIcon: Icon(
            Icons.person,
            color: Color.fromRGBO(53, 152, 219, 1),
          ),
        ),
        validator: (value) {
          if (membersPhones[num].text != '' &&
              (value == null || value.isEmpty || value.trim().isEmpty)) {
            return 'اختر إسمًا للعضو ';
          }
          return null;
        },
      ),
      SizedBox(height: height * 0.01),
      TextFormField(
        controller: membersPhones[num],
        maxLength: 10,
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: ' رقم الجوال ',
          suffixIcon: Icon(
            Icons.phone,
            color: Color.fromRGBO(53, 152, 219, 1),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (membersNames[num].text != '' &&
              (value == null ||
                  value.isEmpty ||
                  value.length < 10 ||
                  value.trim().isEmpty)) {
            return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
          }
          return null;
        },
      ),
      SizedBox(height: height * 0.03),
      SizedBox(
          child: ToggleSwitch(
        icons: const [Icons.edit_note_outlined, PhosphorIcons.binoculars],
        minWidth: width * 0.436,
        minHeight: height * 0.055,
        borderWidth: 1,
        borderColor: [Colors.blue.shade400, Colors.blue.shade400],
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
        initialLabelIndex: privilege_index2,
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
            privilege_index2 = 0;
            privilege_edit2 = 'editor';
            setState(() {
              privilege2 = 'editor';
              roles[num] = 'editor';
            });
          } else {
            privilege_index2 = 1;
            privilege_edit2 = 'viewer';
            setState(() {
              privilege2 = 'viewer';
              roles[num] = 'viewer';
            });
          }
        },
      )),
    ]);
  }

  void clearText() {
    houseName.clear();
    membersPhoneNumber1.clear();
    membersPhoneNumber2.clear();
    membersPhoneNumber3.clear();
    membersPhoneNumber4.clear();
    membersPhoneNumber5.clear();
    membersNames1.clear();
    membersNames2.clear();
    membersNames3.clear();
    membersNames4.clear();
    membersNames5.clear();
  }

  Future<void> setData() async {
    CollectionReference houses =
        FirebaseFirestore.instance.collection('houseAccount');

    String houseId = '';
    DocumentReference docReference = await houses.add({
      'OwnerID': FirebaseAuth.instance.currentUser!.uid,
      'houseID': '',
      'houseName': houseName.text,
      'isNotificationSent': false,
      'goal': '0',
      'totalConsumption': 0,
      'totalConsumptionPercentage': 0
    });

    houseId = docReference.id;
    houses.doc(houseId).update({'houseID': houseId});

    for (int i = 0; i <= num; i++) {
      if (membersPhones[i].text != '') {
        QuerySnapshot query = await FirebaseFirestore.instance
            .collection('userAccount')
            .where('phone_number', isEqualTo: membersPhones[i].text)
            .get();
        var userID = query.docs[0]['userId'];
        houses.doc(houseId).collection('houseMember').add({
          'memberPhoneNumber': membersPhones[i].text,
          'privilege': roles[i],
          'nickName': membersNames[i].text,
          'memberID': userID
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    createList();
    return DraggableScrollableSheet(
        maxChildSize: 0.9,
        minChildSize: 0.9,
        initialChildSize: 0.9,
        builder: (_, controller) => Scaffold(
                body: Container(
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
                Positioned(
                    width: 50,
                    height: 50,
                    top: height * 0.01,
                    right: width * 0.05,
                    child: IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 60),
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
                      "إنشاء حساب للمنزل",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: height * 0.08),
                    child: SingleChildScrollView(
                        controller: list,
                        physics: const ScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView(
                                key: const Key("formScroll"),
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    left: width * 0.06, right: width * 0.06),
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        SizedBox(height: height * 0.02),
                                        const Text(
                                            textAlign: TextAlign.right,
                                            'علامة * تمثل الحقول الإلزامية',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(height: height * 0.020),
                                        const Text(
                                          'اسم المنزل*',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: height * 0.005),
                                        TextFormField(
                                          controller: houseName,
                                          maxLength: 20,
                                          textAlign: TextAlign.right,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'اسم المنزل',
                                            suffixIcon: Icon(
                                              Icons.house,
                                              color: Color.fromRGBO(
                                                  53, 152, 219, 1),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value.trim().isEmpty) {
                                              return 'الرجاء ادخال اسم للمنزل';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: height * 0.020),
                                        const Text(
                                          'أعضاء المنزل',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: height * 0.007),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.56),
                                          padding: EdgeInsets.only(
                                              top: height * 0.004,
                                              bottom: height * 0.004),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.lightBlue.shade100,
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text('عضو المنزل الأول',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue,
                                                  height: 1,
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        TextFormField(
                                          maxLength: 20,
                                          controller: membersNames[0],
                                          textAlign: TextAlign.right,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'الاسم ',
                                            suffixIcon: Icon(
                                              Icons.person,
                                              color: Color.fromRGBO(
                                                  53, 152, 219, 1),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (membersPhones[0].text != '' &&
                                                (value == null ||
                                                    value.isEmpty ||
                                                    value.trim().isEmpty)) {
                                              return 'اختر إسمًا للعضو ';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: height * 0.010),
                                        TextFormField(
                                          controller: membersPhones[0],
                                          maxLength: 10,
                                          textAlign: TextAlign.right,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'رقم الهاتف',
                                            suffixIcon: Icon(
                                              Icons.phone,
                                              color: Color.fromRGBO(
                                                  53, 152, 219, 1),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          validator: (value) {
                                            if (membersNames[0].text != '' &&
                                                (value == null ||
                                                    value.isEmpty ||
                                                    value.length < 10 ||
                                                    value.trim().isEmpty)) {
                                              return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: height * 0.03),
                                        SizedBox(
                                            width: width * 0.8,
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
                                              initialLabelIndex:
                                                  privilege_index,
                                              cornerRadius: 20.0,
                                              inactiveBgColor: Colors.white,
                                              totalSwitches: 2,
                                              labels: const [
                                                '   محرر',
                                                '   مشاهد'
                                              ],
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
                                                    roles[0] = 'editor';
                                                  });
                                                } else {
                                                  privilege_index = 1;
                                                  privilege_edit = 'viewer';
                                                  setState(() {
                                                    privilege = 'viewer';
                                                    roles[0] = 'viewer';
                                                  });
                                                }
                                              },
                                            )),
                                        ListView.builder(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: addMembers.length,
                                            itemBuilder: (context, index) {
                                              return addMembers[index];
                                            }),
                                        Visibility(
                                            visible: !(addMembers.length > 3),
                                            child: TextButton(
                                              style: const ButtonStyle(
                                                alignment:
                                                    Alignment.centerRight,
                                              ),
                                              onPressed: () {
                                                if (addMembers.length > 3) {
                                                  showToast('invalid',
                                                      'يمكنك إضافة المزيد لاحقًا من لوحة المعلومات');
                                                } else {
                                                  createList();
                                                  addMemberWidget(
                                                      height, width);
                                                }
                                              },
                                              child: Text(
                                                ' إضافة عضو آخر',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.blue.shade600,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            )),
                                        const SizedBox(height: 10),
                                        Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 30, 10, 0),
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
                                                stops: const [0.1, 1.0],
                                                colors: [
                                                  Colors.blue.shade200,
                                                  Colors.blue.shade400,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    int singular = 0;
                                                    existing = '';
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      for (int i = 0;
                                                          i <= num;
                                                          i++) {
                                                        if (membersPhones[i]
                                                                .text
                                                                .isNotEmpty &&
                                                            await exists(
                                                                membersPhones[i]
                                                                    .text,
                                                                FirebaseFirestore
                                                                    .instance,
                                                                FirebaseAuth
                                                                    .instance)) {
                                                          duplicates[i] = true;
                                                        } else {
                                                          duplicates[i] = false;
                                                        }
                                                      }
                                                      for (int i = 0;
                                                          i <= num;
                                                          i++) {
                                                        if (!duplicates[i] &&
                                                            membersPhones[i]
                                                                .text
                                                                .isNotEmpty) {
                                                          String place =
                                                              indexes[i];
                                                          existing +=
                                                              'العضو $place ,  ';
                                                          singular++;
                                                        }
                                                      }
                                                      if (singular == 0) {
                                                        await setData();
                                                        showToast('valid',
                                                            "تم إضافة المنزل بنجاح");

                                                        // navigate back when house added successfully
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ListOfHouseAccounts(
                                                                      firestore:
                                                                          widget
                                                                              .firestore,
                                                                      auth: widget
                                                                          .auth),
                                                            ));
                                                      } else {
                                                        if (singular > 1) {
                                                          existing +=
                                                              ' غير موجودين بالنظام';
                                                        } else {
                                                          existing +=
                                                              ' غير موجود بالنظام';
                                                        }
                                                        showToast('invalid',
                                                            existing);
                                                      }
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                    ),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(const Size(
                                                                350, 50)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    shadowColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            50, 10, 50, 10),
                                                    child: Text(
                                                      'إنشاء',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            )),
                                        SizedBox(height: height * 0.08)
                                      ])
                                ]),
                          ),
                        )))
              ]),
            )));
  }
}
