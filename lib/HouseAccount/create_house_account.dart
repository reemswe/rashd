import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rashd/Registration/profile.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';

class CreateHouseAccount extends StatefulWidget {
  const CreateHouseAccount({super.key});

  @override
  State<CreateHouseAccount> createState() => _CreateHouseAccountState();
}

class _CreateHouseAccountState extends State<CreateHouseAccount> {
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

  ScrollController list = ScrollController();

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
        padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              Text(
                'عضو المنزل $place',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              // Text('  عضو المنزل $place ', textAlign: TextAlign.right),
              TextFormField(
                maxLength: 20,
                controller: membersNames[num],
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: ' الاسم ',
                ),
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
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ToggleSwitch(
                  minWidth: 210.0,
                  minHeight: 50.0,
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
                  cornerRadius: 100.0,
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
  }

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    createList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' إنشاء حساب للمنزل',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
          controller: list,
          physics: const ScrollPhysics(),
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  //padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                  padding: const EdgeInsets.fromLTRB(6, 8, 0, 12),
                  child: Text(
                      textAlign: TextAlign.right,
                      'علامة * تمثل الحقول الإلزامية',
                      style: TextStyle(fontSize: 16)),
                ),
                //  TextFormField(
                //   // maxLength: 20,
                //   readOnly: true,
                //   textAlign: TextAlign.right,
                //   decoration: const InputDecoration(
                //     hintText: 'علامة * تمثل الحقول الإلزامية',
                //     contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                //     border: InputBorder.none,
                //   ),
                // )

                Container(
                    padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'اسم المنزل*',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: houseName,
                            maxLength: 20,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: 'اسم المنزل',
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء ادخال اسم للمنزل';
                              }
                              return null;
                            },
                          )
                        ])),
                Container(
                    padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'أعضاء المنزل',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          TextFormField(
                            // maxLength: 20,
                            maxLength: 20,
                            controller: membersNames[0],
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: ' الاسم ',
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
                            ),
                            validator: (value) {
                              if (membersPhones[0].text != '' && value == '') {
                                return 'اختر إسمًا للعضو ';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          TextFormField(
                            controller: membersPhones[0],
                            maxLength: 10,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: ' رقم الجوال ',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.length < 10) {
                                return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.020,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: ToggleSwitch(
                              minWidth: width * 0.45,
                              minHeight: 50.0,
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
                              cornerRadius: 100.0,
                              activeFgColor:
                                  const Color.fromARGB(255, 255, 255, 255),
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
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: addMembers.length,
                    itemBuilder: (context, index) {
                      return addMembers[index];
                    }),
                TextButton(
                  style: const ButtonStyle(
                    alignment: Alignment.centerRight,
                  ),
                  onPressed: () {
                    if (addMembers.length > 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                              'يمكنك إضافة المزيد لاحقًا من لوحة المعلومات',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Color.fromARGB(255, 241, 63, 63)),
                      );
                    } else {
                      createList();
                      addMemberWidget();
                    }
                  },
                  child: const Text(
                    ' إضافة عضو آخر',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
                    width: width * 0.9,
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                        } else {
                          print(houseName.text);
                          setData();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                  '  تم اضافة المنزل بنجاح',
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.green),
                          );
                          //navigate back when house added successfully
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const ListOfHouseAccounts(),
                          //     ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('إنشاء'),
                    )),
              ],
            ),
          )),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Future<void> setData() async {
    CollectionReference houses =
        FirebaseFirestore.instance.collection('houseAccount');

    String houseId = '', dashId = '';
    DocumentReference docReference = await houses.add({
      'OwnerID': '',
      'houseID': '',
      'houseName': houseName.text,
      'houseOwner': '',
      'isNotificationSent': false //to send warning notification only once
    });
    CollectionReference dashboard =
        FirebaseFirestore.instance.collection('dashboard');

    houseId = docReference.id;
    houses.doc(houseId).update({'houseID': houseId});

    DocumentReference docReference1 = await dashboard.add({
      'dashboardID': '',
      'houseID': houseId,
      'userGoal': '',
      'code': '',
    });
    dashId = docReference1.id;
    dashboard.doc(dashId).update({'dashboardID': dashId});
    houses.doc(houseId).update({'dashboardID': dashId});
    print('num $num');

    for (int i = 0; i <= num; i++) {
      if (membersPhones[i].text != '') {
        print('phone: ' + membersPhones[i].text);
        print('privilege: ' + roles[i]);
        houses.doc(houseId).collection('houseMember').add({
          'memberPhoneNumber': membersPhones[i].text,
          'privilege': roles[i],
          'nickName': membersNames[i].text
        });
      }
    }
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
}

class global {
  static var index = 1;
}
