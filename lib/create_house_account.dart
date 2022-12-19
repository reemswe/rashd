import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreateHouseAccount extends StatefulWidget {
  const CreateHouseAccount({super.key});

  @override
  State<CreateHouseAccount> createState() => _CreateHouseAccountState();
}

class _CreateHouseAccountState extends State<CreateHouseAccount> {
  TextEditingController houseName = TextEditingController();
  String memberRole1 = "role";
  List<Widget> addMembers = [];
  TextEditingController membersPhoneNumber1 = TextEditingController();
  TextEditingController membersPhoneNumber2 = TextEditingController();
  TextEditingController membersPhoneNumber3 = TextEditingController();
  TextEditingController membersPhoneNumber4 = TextEditingController();
  TextEditingController membersPhoneNumber5 = TextEditingController();
  List<TextEditingController> membersPhones = [];
  ScrollController list = ScrollController();

  //toggle swithc
  String privilege_edit = 'viewer', privilege = '';
  var privilege_index = 1;
  String privilege_edit2 = 'viewer', privilege2 = '';
  var privilege_index2 = 1;
  //toggle switch

  List roles = ['role', 'role', 'role', 'role', 'role'];
  String role1 = "role";
  String role2 = "role";
  String role3 = "role";

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
    });
  }

  Widget members() {
    num++;

    String place = indexes[num];
    privilege_edit2 = 'viewer';
    privilege2 = 'viewer';
    return Container(
        padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
          Text('  عضو المنزل $place ', textAlign: TextAlign.right),
          TextFormField(
            // maxLength: 20,
            maxLength: 20,

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
          ),
          // Row(
          //   children: [
          //     const Expanded(
          //       child: Text(
          //         '  محرر',
          //         textAlign: TextAlign.right,
          //       ),
          //     ),
          //     Radio(
          //       value: "editor",
          //       groupValue: roles[num],
          //       onChanged: (T) {
          //         setState(() {
          //           //memberRole1 = T!;
          //           roles[num] = T;
          //           print(roles[num]);
          //         });
          //       },
          //     ),
          //     const Expanded(
          //         child: Text(
          //       ' مشاهد',
          //       textAlign: TextAlign.right,
          //     )),
          //     Radio(
          //       value: "viewer",
          //       groupValue: roles[num],
          //       onChanged: (T) {
          //         //print(T);
          //         setState(() {
          //           // memberRole1 = T!;
          //           roles[num] = T;
          //           print(roles[num]);
          //         });
          //       },
          //     ),
          //   ],
          // ),
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
              initialLabelIndex: privilege_index,
              cornerRadius: 10.0,
              activeFgColor: const Color.fromARGB(255, 255, 255, 255),
              inactiveBgColor: Colors.white,
              inactiveFgColor: Colors.black,
              totalSwitches: 2,
              labels: const ['محرر', 'مشاهد'],
              activeBgColors: const [
                [Color.fromARGB(255, 160, 189, 166)],
                [Color.fromARGB(255, 160, 189, 166)]
              ],
              onToggle: (index) {
                if (index == 0) {
                  privilege_index2 = 0;
                  privilege_edit2 = 'editor';
                  setState(() {
                    privilege2 = 'editor';
                  });
                  print('switched to: editor');
                  print(privilege2);
                } else {
                  privilege_index2 = 1;
                  privilege_edit2 = 'viewer';
                  setState(() {
                    privilege2 = 'viewer';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            ' إنشاء حساب للمنزل',
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
                          padding: const EdgeInsets.fromLTRB(6, 12, 0, 12),
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
                                const Text('*اسم المنزل',
                                    textAlign: TextAlign.right),
                                TextFormField(
                                  controller: houseName,
                                  maxLength: 20,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    hintText: 'اسم المنزل',
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const Text('اعضاء المنزل ',
                                    textAlign: TextAlign.right),
                                TextFormField(
                                  // maxLength: 20,
                                  maxLength: 20,

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
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  // maxLength: 20,
                                  controller: membersPhoneNumber1,
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
                                ),
                                // Row(
                                //   //mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     const Expanded(
                                //       child: Text(
                                //         '  محرر',
                                //         textAlign: TextAlign.right,
                                //       ),
                                //     ),
                                //     Radio(
                                //       value: "editor",
                                //       groupValue: role1,
                                //       onChanged: (T) {
                                //         setState(() {
                                //           // memberRole1 = T!;
                                //           role1 = T!;
                                //           print(role1);
                                //         });
                                //       },
                                //     ),
                                //     const Expanded(
                                //         child: Text(
                                //       ' مشاهد',
                                //       textAlign: TextAlign.right,
                                //     )),
                                //     Radio(
                                //       value: "viewer",
                                //       groupValue: role1,
                                //       onChanged: (T) {
                                //         //print(T);
                                //         setState(() {
                                //           // memberRole1 = T!;
                                //           role1 = T!;
                                //           print(role1);
                                //         });
                                //       },
                                //     ),
                                //   ],
                                // ),
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
                                      [Color.fromARGB(255, 160, 189, 166)],
                                      [Color.fromARGB(255, 160, 189, 166)]
                                    ],
                                    onToggle: (index) {
                                      if (index == 0) {
                                        privilege_index = 0;
                                        privilege_edit = 'editor';
                                        setState(() {
                                          privilege = 'editor';
                                        });
                                        print('switched to: editor');
                                        print(privilege);
                                      } else {
                                        privilege_index = 1;
                                        privilege_edit = 'viewer';
                                        setState(() {
                                          privilege = 'viewer';
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
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //       content: Text(
                                //         '  الرجاء إدخال اسم للمنزل',
                                //         textAlign: TextAlign.center,
                                //       ),
                                //       backgroundColor: Colors.redAccent),
                                // );
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
                  )),
            )));
  }

  Future<void> setData() async {
    CollectionReference houses =
        FirebaseFirestore.instance.collection('houseAccount');

    String houseId = '';
    DocumentReference docReference = await houses.add({
      'OwnerID': '',
      'dashboardID': '',
      'houseID': '',
      'houseName': houseName.text,
      'houseOwner': '',
    });

    houseId = docReference.id;
    houses.doc(houseId).update({'houseID': houseId});
    print('0' + membersPhones[0].text);
    print('num $num');
    for (int i = 0; i <= num; i++) {
      print('phone' + membersPhones[i].text);
      print('privilege' + roles[i]);
      houses
          .doc(houseId)
          .collection('houseMember')
          .add({'memberID': membersPhones[i].text, 'privilege': roles[i]});
    }
  }
}
