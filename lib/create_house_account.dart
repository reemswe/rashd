import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class CreateHouseAccount extends StatefulWidget {
  const CreateHouseAccount({super.key});

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

    return Column(children: <Widget>[
      Text('عضو المنزل $place ', textAlign: TextAlign.right),
      TextFormField(
        maxLength: 20,
        controller: membersNames[num],
        decoration: InputDecoration(
          hintText: ' الاسم ',
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
        decoration: InputDecoration(
          hintText: ' رقم الجوال ',
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
            } else {
              privilege_index2 = 1;
              privilege_edit2 = 'viewer';
              setState(() {
                privilege2 = 'viewer';
                roles[num] = 'viewer';
              });
            }
          },
        ),
      ),
    ]);
  }

  void clearText() {
    membersPhoneNumber1.clear();
    membersPhoneNumber2.clear();
    membersPhoneNumber3.clear();
    membersPhoneNumber4.clear();
    membersPhoneNumber5.clear();
  }

  @override
  void initState() {
    super.initState();
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
  }

  Future<void> setData() async {
    CollectionReference houses =
        FirebaseFirestore.instance.collection('houseAccount');

    String houseId = '', dashId = '';
    DocumentReference docReference = await houses.add({
      'OwnerID': '',
      'dashboardID': '',
      'houseID': '',
      'houseName': houseName.text,
      'houseOwner': '',
      'isNotificationSent': false
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

  Future<bool> exists(String number) async {
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    createList();
    return

        //   Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     ' إنشاء حساب للمنزل',
        //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   leading: const Text(''),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.arrow_forward_ios),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //   ],
        // ),
        // body:
        DraggableScrollableSheet(
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
                      bottom: height * -1.4,
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
                    SingleChildScrollView(
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
                                            hintText: 'اسم المنزل',
                                            suffixIcon: Icon(
                                              Icons.house,
                                              color: Color.fromRGBO(
                                                  53, 152, 219, 1),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                        TextFormField(
                                          maxLength: 20,
                                          controller: membersNames[0],
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
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
                                          decoration: InputDecoration(
                                            hintText: ' رقم الجوال ',
                                            suffixIcon: Icon(
                                              Icons.phone,
                                              color: Color.fromRGBO(
                                                  53, 152, 219, 1),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (membersNames[0].text != '' &&
                                                (value == null ||
                                                    value.isNotEmpty ||
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
                                              icons: [
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
                                            physics: ClampingScrollPhysics(),
                                            controller: list,
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
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                      'يمكنك إضافة المزيد لاحقًا من لوحة المعلومات',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 241, 63, 63)),
                                              );
                                            } else {
                                              createList();
                                              addMemberWidget();
                                            }
                                          },
                                          child: Text(
                                            ' إضافة عضو آخر',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.blue.shade600,
                                                decoration:
                                                    TextDecoration.underline),
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
                                                  bool flag = true;
                                                  for (int i = 0;
                                                      i <= num;
                                                      i++) {
                                                    if (membersPhones[i]
                                                            .text
                                                            .isNotEmpty &&
                                                        await exists(
                                                            membersPhones[i]
                                                                .text)) {
                                                      duplicates[i] = true;
                                                      print('true-->' +
                                                          membersPhones[i]
                                                              .text);
                                                    } else {
                                                      duplicates[i] = false;
                                                      print('false-->' +
                                                          membersPhones[i]
                                                              .text);
                                                    }
                                                  }
                                                  for (int i = 0;
                                                      i <= num;
                                                      i++) {
                                                    if (!duplicates[i] &&
                                                        membersPhones[i]
                                                            .text
                                                            .isNotEmpty) {
                                                      String place = indexes[i];
                                                      existing +=
                                                          'العضو $place ,  ';
                                                      singular++;
                                                    }
                                                  }
                                                  if (singular == 0) {
                                                    setData();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                  '  تم اضافة المنزل بنجاح',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green));
                                                  } else {
                                                    if (singular > 1) {
                                                      existing +=
                                                          ' غير موجودين بالنظام';
                                                    } else {
                                                      existing +=
                                                          ' غير موجود بالنظام';
                                                    }
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                              existing,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent));
                                                  }
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
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text('إنشاء'),
                                            )),
                                      ])
                                ]),
                          ),
                        ))
                  ]),
                ));
    // );

    SingleChildScrollView(
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
                      padding: const EdgeInsets.fromLTRB(6, 12, 0, 12),
                      child: TextFormField(
                        // maxLength: 20,
                        readOnly: true,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          hintText: 'علامة * تمثل الحقول الإلزامية',
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                          border: InputBorder.none,
                        ),
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text('*اسم المنزل', textAlign: TextAlign.right),
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
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                              child: Column(children: <Widget>[
                                const Text('اعضاء المنزل ',
                                    textAlign: TextAlign.right),
                                TextFormField(
                                  // maxLength: 20,
                                  maxLength: 20,
                                  controller: membersNames[0],
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    hintText: ' الاسم ',
                                    contentPadding: const EdgeInsets.fromLTRB(
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
                                            color: Colors.red, width: 2.0)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2.0)),
                                  ),
                                  validator: (value) {
                                    if (membersPhones[0].text != '' &&
                                        value == '') {
                                      return 'اختر إسمًا للعضو ';
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
                                    hintText: ' رقم الجوال ',
                                    contentPadding: const EdgeInsets.fromLTRB(
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
                                            color: Colors.red, width: 2.0)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2.0)),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isNotEmpty &&
                                        value.length < 10) {
                                      return 'ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام';
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                      backgroundColor:
                                          Color.fromARGB(255, 241, 63, 63)),
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
                              child: ElevatedButton(
                                onPressed: () async {
                                  int singular = 0;
                                  existing = '';
                                  if (!_formKey.currentState!.validate()) {
                                  } else {
                                    print(houseName.text);
                                    bool flag = true;
                                    for (int i = 0; i <= num; i++) {
                                      if (membersPhones[i].text.isNotEmpty &&
                                          await exists(membersPhones[i].text)) {
                                        duplicates[i] = true;
                                        print(
                                            'true-->' + membersPhones[i].text);
                                      } else {
                                        duplicates[i] = false;
                                        print(
                                            'false-->' + membersPhones[i].text);
                                      }
                                    }
                                    for (int i = 0; i <= num; i++) {
                                      if (!duplicates[i] &&
                                          membersPhones[i].text.isNotEmpty) {
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
                                                '  تم اضافة المنزل بنجاح',
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor: Colors.green));
                                    } else {
                                      if (singular > 1) {
                                        existing += ' غير موجودين بالنظام';
                                      } else {
                                        existing += ' غير موجود بالنظام';
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                existing,
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor:
                                                  Colors.redAccent));
                                    }

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
                      )),
                ]),
          )),
    );

    DraggableScrollableSheet(
        maxChildSize: 0.9,
        minChildSize: 0.9,
        initialChildSize: 0.9,
        builder: (_, controller) => Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
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
                bottom: height * -1.4,
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
              Positioned(
                  width: width,
                  height: height,
                  top: height * 0.07,
                  child: SingleChildScrollView(
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
                                          hintText: 'اسم المنزل',
                                          suffixIcon: Icon(
                                            Icons.house,
                                            color:
                                                Color.fromRGBO(53, 152, 219, 1),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
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
                                      TextFormField(
                                        maxLength: 20,
                                        controller: membersNames[0],
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          hintText: 'الاسم ',
                                          suffixIcon: Icon(
                                            Icons.person,
                                            color:
                                                Color.fromRGBO(53, 152, 219, 1),
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
                                        decoration: InputDecoration(
                                          hintText: ' رقم الجوال ',
                                          suffixIcon: Icon(
                                            Icons.phone,
                                            color:
                                                Color.fromRGBO(53, 152, 219, 1),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (membersNames[0].text != '' &&
                                              (value == null ||
                                                  value.isNotEmpty ||
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
                                            icons: [
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
                                          physics: ClampingScrollPhysics(),
                                          controller: list,
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
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                    'يمكنك إضافة المزيد لاحقًا من لوحة المعلومات',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 241, 63, 63)),
                                            );
                                          } else {
                                            createList();
                                            addMemberWidget();
                                          }
                                        },
                                        child: Text(
                                          ' إضافة عضو آخر',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.blue.shade600,
                                              decoration:
                                                  TextDecoration.underline),
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
                                                bool flag = true;
                                                for (int i = 0; i <= num; i++) {
                                                  if (membersPhones[i]
                                                          .text
                                                          .isNotEmpty &&
                                                      await exists(
                                                          membersPhones[i]
                                                              .text)) {
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
                                                    existing +=
                                                        'العضو $place ,  ';
                                                    singular++;
                                                  }
                                                }
                                                if (singular == 0) {
                                                  setData();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                '  تم اضافة المنزل بنجاح',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              backgroundColor:
                                                                  Colors
                                                                      .green));
                                                } else {
                                                  if (singular > 1) {
                                                    existing +=
                                                        ' غير موجودين بالنظام';
                                                  } else {
                                                    existing +=
                                                        ' غير موجود بالنظام';
                                                  }
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                            existing,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .redAccent));
                                                }
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text('إنشاء'),
                                          )),
                                    ])
                              ]),
                        ),
                      )))
            ])));
  }
}
