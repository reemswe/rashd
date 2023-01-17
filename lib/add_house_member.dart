import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class add_house_member extends StatefulWidget {
  final ID;
  const add_house_member({super.key, required this.ID});
  //({super.key});

  @override
  add_house_memberState createState() => add_house_memberState();
}

class add_house_memberState extends State<add_house_member> {
  int counter = 1;
  TextEditingController houseName = TextEditingController();
  List<Widget> addMembers = [];
  TextEditingController membersPhoneNumber1 = TextEditingController();
  TextEditingController membersPhoneNumber2 = TextEditingController();
  TextEditingController membersPhoneNumber3 = TextEditingController();
  TextEditingController membersPhoneNumber4 = TextEditingController();
  TextEditingController membersPhoneNumber5 = TextEditingController();
  TextEditingController membersNames1 = TextEditingController();
  TextEditingController membersNames2 = TextEditingController();
  TextEditingController membersNames3 = TextEditingController();
  TextEditingController membersNames4 = TextEditingController();
  TextEditingController membersNames5 = TextEditingController();
  List<TextEditingController> membersPhones = [];
  List<TextEditingController> membersNames = [];
  List<bool> duplicates = [true, true, true, true, true];

  ScrollController list = ScrollController();
  String existing = '';
  //toggle swithc
  String privilege_edit = 'viewer', privilege = '';
  var privilege_index = 1;
  String privilege_edit2 = 'viewer', privilege2 = '';
  var privilege_index2 = 1;
  //toggle switch

  List roles = ['viewer', 'viewer', 'viewer', 'viewer', 'viewer'];

  List indexes = ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'];
  int num = 0;
  void addMemberWidget() {
    setState(() {
      addMembers.add(members());
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

  Widget members() {
    num++;

    String place = indexes[num];
    setState(() {
      privilege_edit2 = 'viewer';
      privilege2 = 'viewer';
      privilege_index2 = 1;
    });

    return Container(
        padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
        child: Column(children: <Widget>[
          Text('  عضو المنزل $place ', textAlign: TextAlign.right),
          TextFormField(
            maxLength: 20,
            controller: membersNames[num],
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: ' الاسم ',
              contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: const BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0)),
            ),
            validator: (value) {
              if (membersPhones[num].text != '' && value == '') {
                return 'اختر إسمًا للعضو ';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: membersPhones[num],
            maxLength: 10,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: ' رقم الجوال ',
              contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: const BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0)),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isNotEmpty && value.length < 10) {
                return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ToggleSwitch(
              minWidth: 150.0,
              minHeight: 45.0,
              borderWidth: 1,
              borderColor: const [
                Color.fromARGB(255, 149, 149, 149),
                Color.fromARGB(255, 149, 149, 149)
              ],
              customTextStyles: const [
                TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                )
              ],
              initialLabelIndex: privilege_index2,
              cornerRadius: 10.0,
              activeFgColor: const Color.fromARGB(255, 255, 255, 255),
              inactiveBgColor: Colors.white,
              inactiveFgColor: Colors.black,
              totalSwitches: 2,
              labels: const ['محرر', 'مشاهد'],
              activeBgColors: const [
                [Colors.blue],
                [Colors.blue],
              ],
              onToggle: (index) {
                if (index == 0) {
                  privilege_index2 = 0;
                  privilege_edit2 = 'editor';
                  setState(() {
                    privilege2 = 'editor';
                    roles[num] = 'editor';
                  });
                  print('switched to: editor');
                  print(privilege2);
                } else {
                  privilege_index2 = 1;
                  privilege_edit2 = 'viewer';
                  setState(() {
                    privilege2 = 'viewer';
                    roles[num] = 'viewer';
                  });
                  print('switched to: viewer');
                  print(privilege2);
                }
              },
            ),
          ),
        ]));
  }

  final _formKey = GlobalKey<FormState>();
  void clearText() {
    membersPhoneNumber1.clear();
    membersPhoneNumber2.clear();
    membersPhoneNumber3.clear();
    membersPhoneNumber4.clear();
    membersPhoneNumber5.clear();
    counter = 1;
  }

  void init() {
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
  }

  @override
  Widget build(BuildContext context) {
    createList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' إضافة عضو للمنزل',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          controller: list,
          physics: const ScrollPhysics(),
          child: Form(
              key: _formKey,
              child: Scrollbar(
                  thumbVisibility: true,
                  controller: list,
                  child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      children: [
                        Container(
                            //padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                            padding: const EdgeInsets.fromLTRB(6, 12, 0, 0),
                            child: TextFormField(
                              // maxLength: 20,
                              readOnly: true,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: 'علامة * تمثل الحقول الإلزامية',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 10, 0, 10),
                                border: InputBorder.none,
                              ),
                            )),
                        Container(
                            padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 12, 6, 12),
                                    child: Column(children: <Widget>[
                                      TextFormField(
                                        // maxLength: 20,
                                        maxLength: 20,
                                        controller: membersNames[0],
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          hintText: '* الاسم ',
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  borderSide: const BorderSide(
                                                      color: Colors.red,
                                                      width: 2.0)),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '  رجاء ادخل اسم العضو ';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        // maxLength: 20,

                                        controller: membersPhones[0],
                                        maxLength: 10,

                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          hintText: '* رقم الجوال ',
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  borderSide: const BorderSide(
                                                      color: Colors.red,
                                                      width: 2.0)),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '  رجاء ادخل رقم هاتف';
                                          }
                                          if (value.length < 10) {
                                            return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: ToggleSwitch(
                                          minWidth: 150.0,
                                          minHeight: 45.0,
                                          borderWidth: 1,
                                          borderColor: const [
                                            Color.fromARGB(255, 149, 149, 149),
                                            Color.fromARGB(255, 149, 149, 149)
                                          ],
                                          customTextStyles: const [
                                            TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            )
                                          ],
                                          initialLabelIndex: privilege_index,
                                          cornerRadius: 10.0,
                                          activeFgColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          inactiveBgColor: Colors.white,
                                          inactiveFgColor: Colors.black,
                                          totalSwitches: 2,
                                          labels: const ['محرر', 'مشاهد'],
                                          activeBgColors: const [
                                            [Colors.blue],
                                            [Colors.blue],
                                          ],
                                          onToggle: (index) {
                                            if (index == 0) {
                                              privilege_index = 0;
                                              privilege_edit = 'editor';
                                              setState(() {
                                                privilege = 'editor';
                                                roles[0] = 'editor';
                                              });
                                              print('switched to: editor');
                                              print(privilege);
                                            } else {
                                              privilege_index = 1;
                                              privilege_edit = 'viewer';
                                              setState(() {
                                                privilege = 'viewer';
                                                roles[0] = 'viewer';
                                              });
                                              print('switched to: viewer');
                                              print(privilege);
                                            }
                                          },
                                        ),
                                      ),
                                    ])),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: addMembers.length,
                                    itemBuilder: (context, index) {
                                      return addMembers[index];
                                    }),
                                Visibility(
                                  visible: counter < 5,
                                  child: TextButton(
                                    style: const ButtonStyle(
                                      alignment: Alignment.centerRight,
                                    ),
                                    onPressed: () {
                                      createList();
                                      addMemberWidget();
                                      counter++;
                                    },
                                    child: const Text(
                                      ' إضافة عضو آخر',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        45, 10, 45, 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        int singular = 0;
                                        existing = '';
                                        if (!_formKey.currentState!
                                            .validate()) {
                                        } else {
                                          print(houseName.text);
                                          bool flag = true;
                                          for (int i = 0; i <= num; i++) {
                                            if (membersPhones[i]
                                                    .text
                                                    .isNotEmpty &&
                                                await exixts(
                                                    membersPhones[i].text)) {
                                              duplicates[i] = true;
                                              print('true-->' +
                                                  membersPhones[i].text);
                                            } else {
                                              duplicates[i] = false;
                                              print('false-->' +
                                                  membersPhones[i].text);
                                            }
                                          }
                                          for (int i = 0; i <= num; i++) {
                                            if (!duplicates[i] &&
                                                membersPhones[i]
                                                    .text
                                                    .isNotEmpty) {
                                              String place = indexes[i];
                                              existing += 'العضو $place ,  ';
                                              singular++;
                                            }
                                          }
                                          if (singular == 0) {
                                            setData();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                      '  تم الاضافة بنجاح',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    backgroundColor:
                                                        Colors.green));
                                          } else {
                                            if (singular > 1) {
                                              existing +=
                                                  ' غير موجودين بالنظام';
                                            } else {
                                              existing += ' غير موجود بالنظام';
                                            }
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                      existing,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent));
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
                            )),
                      ])))),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Future<void> setData() async {
    CollectionReference houses =
        FirebaseFirestore.instance.collection('houseAccount');
    for (int i = 0; i <= num; i++) {
      if (membersPhones[i].text != '') {
        print('phone: ' + membersPhones[i].text);
        print('privilege: ' + roles[i]);
        houses.doc(widget.ID).collection('houseMember').add({
          'memberID': membersPhones[i].text,
          'privilege': roles[i],
          'nickName': membersNames[i].text
        });
      }
    }
  }

  int index = 2;
  Widget buildBottomNavigation() {
    return BottomNavyBar(
      //containerHeight: height * 0.07,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      selectedIndex: index,
      iconSize: 28,
      onItemSelected: (index) {
        setState(
          () => index = index,
        );
        if (index == 0) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => dashboard(
          //             ID: widget.ID,
          //           )),
          // );
        } else if (index == 1) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => listOfDevices(
          //             ID: widget.ID,
          //           )),
          // );
        } else if (index == 2) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) =>
          //           add_house_member(ID: widget.ID)),
          // );
        }
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

  Future<bool> exixts(String number) async {
    bool invalidPhone = false;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('userAccount')
        .where('phone_number', isEqualTo: number)
        .get();
    if (query.docs.isNotEmpty) {
      invalidPhone = true;
    } else {
      invalidPhone = false;
    }

    return invalidPhone;
  }


class global {
  static var index = 0;
}
