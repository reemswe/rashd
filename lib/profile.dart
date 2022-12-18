import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'create_house_account.dart';
import 'list_of_house_accounts.dart';
import 'login.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class profile extends StatefulWidget {
  // final String userId;
  const profile({super.key});
  @override
  profileState createState() => profileState();
}

TextEditingController DOBController = TextEditingController();

// ignore: camel_case_types
class profileState extends State<profile> {
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();
  String bDay = "";
  bool showDate = false;

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // firstDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        DOBController.text =
            DateFormat('yyyy-MM-dd').format(selected).toString();
      });
    }
    return selectedDate;
  }

  String getDate() {
    if (selectedDate == null) {
      return 'select date';
    } else {
      bDay = DateFormat('yyyy-MM-dd').format(selectedDate);
      return DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' حسابي  ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: //Icon(Icons.more_vert)
            PopupMenuButton(
          onSelected: (value) {
            if (value == 'delete') {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    " تسجيل خروج",
                    textAlign: TextAlign.left,
                  ),
                  content: const Text(
                    "هل أنت متأكد من تسجيل الخروج؟  ؟",
                    textAlign: TextAlign.left,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("الغاء"),
                      ),
                    ),
                    //log in ok button
                    TextButton(
                      onPressed: () {
                        // pop out
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const login()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("خروج",
                            style: TextStyle(
                                color: Color.fromARGB(255, 164, 10, 10))),
                      ),
                    ),
                  ],
                ),
              );
            }
            // your logic
          },
          itemBuilder: (BuildContext bc) {
            return const [
              PopupMenuItem(
                child: Text("  تسجيل الخروج",
                    style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
                value: 'delete',
              ),
            ];
          },
        ),
        actions: [],
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Icon(
                  Icons.person_pin,
                  color: Color.fromARGB(255, 100, 96, 98),
                  size: 140,
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //name
                      const Text(
                        ':الاسم الكامل',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        initialValue: 'هيفاء بن عوين',
                        //controller:
                        //onChanged: (text) => {controller = text},
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF06283D)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if ((value != null && value.length < 2) ||
                              value == null ||
                              value.isEmpty ||
                              (value.trim()).isEmpty) {
                            return "ادخل اسم صحيح";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      //DOB
                      Text(
                        ':اسم المستخدم',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        initialValue: 'هيفاءـ٣٣',
                        //controller:
                        //onChanged: (text) => {controller = text},
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF06283D)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if ((value != null && value.length < 2) ||
                              value == null ||
                              value.isEmpty ||
                              (value.trim()).isEmpty) {
                            return "ادخل اسم صحيح";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      //name
                      const Text(
                        ':تاريخ الميلاد',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        readOnly: true,
                        initialValue: '2000/12/23',
                        //controller: DOBController,
                        // onTap: () {
                        //   _selectDate(context);
                        //   showDate = false;
                        //   bDay = getDate();
                        //   // DOBController.text = globals.bDay;
                        // },
                        //onChanged: (text) => {controller = text},
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF06283D)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (value) {
                        //   if (value == null ||
                        //       value.isEmpty ||
                        //       (value.trim()).isEmpty) {
                        //     return 'الرجاء اختيار تاريخ الميلاد';
                        //   }
                        // },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        ':رقم الهاتف',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        enabled: false,
                        initialValue: '0569204145',
                        //controller:
                        //onChanged: (text) => {controller = text},
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF06283D)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if ((value != null && value.length < 2) ||
                              value == null ||
                              value.isEmpty ||
                              (value.trim()).isEmpty) {
                            return "ادخل اسم صحيح";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),

                //*
                const SizedBox(
                  height: 75,
                ),
                //*
                Visibility(
                  visible: false,
                  child: Container(
                      margin: const EdgeInsets.all(30),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('تمت مشاركة لوحة معلومات المنزل')),
                              );
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ))),
                          child: const Padding(
                              padding: EdgeInsets.fromLTRB(90, 15, 90, 15),
                              child: Text(
                                'تحرير',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )))),
                )
              ],
            ),
          )),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  int index = 0;
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
            MaterialPageRoute(builder: (context) => const profile()),
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
