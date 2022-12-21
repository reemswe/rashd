import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rashd/list_of_house_accounts.dart';

import 'welcomePage.dart';

class profile extends StatefulWidget {
  const profile({super.key});
  @override
  profileState createState() => profileState();
}

String name_edit = '', phone_edit = '', DOB = '', DOB_edit = '', userName = '';
TextEditingController DOBController = new TextEditingController();
TextEditingController nameController = new TextEditingController();
TextEditingController EmailContrller = new TextEditingController();
TextEditingController phoneController = new TextEditingController();

bool Editing = false;
bool Viewing = true;

class profileState extends State<profile> {
  var _formKey;

  @override
  initState() {
    super.initState();
    print("++++++++++++ initState! ++++++++++++");
    FirebaseFirestore.instance
        .collection("userAccount")
        .doc('uoInwRTOLtM4eph0LwgPI1ULzc12')
        .get()
        .then((value) {
      nameController.text = value.data()!["full_name"];
      EmailContrller.text = value.data()!["email"];
      phoneController.text = value.data()!["phone_number"];
      DOBController.text = value.data()!["DOB"];
      print("++++++++++++ Document! ++++++++++++");
    });
    print(nameController.text);
    print(phoneController.text);
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    var userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' حسابي  ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          iconSize: 30,
          color: Color.fromARGB(255, 149, 37, 37),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text(
                  " تسجيل خروج",
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  "هل أنت متأكد من تسجيل الخروج ؟",
                  textAlign: TextAlign.right,
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const welcomePage()));
                      Future.delayed(const Duration(seconds: 1),
                          () async => await FirebaseAuth.instance.signOut());
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
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),

            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.person_pin,
                color: Colors.lightBlue,
                size: 140,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Text('البريد الإلكتروني'),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: TextFormField(
                enabled: false,
                textAlign: TextAlign.right,
                controller: EmailContrller,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 3),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //name field
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Text('الاسم الكامل'),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: Column(children: [
                //Name
                TextFormField(
                  enabled: Editing,
                  textAlign: TextAlign.right,
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'الاسم',
                    alignLabelWithHint: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blue),
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
              ]),
            ),

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Text(
                'تاريخ الميلاد',
                textAlign: TextAlign.right,
              ),
            ),
            //DOB field
            Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Column(
                  children: [
                    TextFormField(
                      textAlign: TextAlign.right,
                      enabled: Editing,
                      controller: DOBController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(DOBController.text),
                          firstDate: DateTime(1922),
                          lastDate: DateTime.now(),
                        );
                        if (newDate != null) {
                          setState(() {
                            DOBController.text =
                                DateFormat('yyyy-MM-dd').format(newDate);
                            print(newDate);
                            print('controller :' + DOBController.text);
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.lightBlue),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.blue),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 3),
                        hintText: DOBController.text,
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Text('رقم الهاتف'),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Column(
                  children: [
                    //phone number field
                    TextFormField(
                      textAlign: TextAlign.right,
                      enabled: Editing,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      maxLength: 10,
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'رقم الهاتف',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.lightBlue,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.blue),
                        ),
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null) {
                          return "الرجاء ادخال رقم هاتف";
                        } else if (value.length != 10) {
                          return "الرجاء ادخال رقم هاتف صحيح";
                        }
                      },
                    ),
                  ],
                )),

            const SizedBox(
              height: 10,
            ),
            //Editing buttons :
            Visibility(
              visible: Viewing,
              // child: Padding(
              //     padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //  mainAxisSize: MainAxisSize.spaceAround,
                //  crossAxisAlignment: CrossAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: width * 0.01,
                  ),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Editing = true;
                          Viewing = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 253, 253, 253),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      child: const Text('تحرير'),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.015,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    iconSize: 55,
                    color: Color.fromARGB(255, 149, 37, 37),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text(
                            "هل أنت متأكد ؟",
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            "هل أنت متأكد من حدف حسابك ؟ لا يمكنك استرجاع الحساب بعد الحذف",
                            // textAlign: TextAlign.end,
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
                              onPressed: () {
                                // FirebaseFirestore.instance
                                //     .collection("users")
                                //     .doc(userData['id'])
                                //     .delete()
                                //     .then((_) {
                                //   print(
                                //       "success!, user deleted");
                                // });
                                // Navigator.of(ctx).pop();
                                print("success!, user deleted");
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
                  SizedBox(
                    width: width * 0.01,
                  ),
                ],
                // )
              )),
            ), //Save and cancel buttons
            Visibility(
                visible: Editing,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text(
                                    "هل أنت متأكد ؟",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: const Text(
                                    "هل أنت متأكد من أنك تريد حفظ التغييرات؟",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("إلغاء",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 194, 98, 98))),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('! تم حفظ التغييرات')),
                                        );
                                        UpdateDB();
                                        setState(() {
                                          Editing = false;
                                          Viewing = true;
                                        });
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: const Text(
                                          "حفظ",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            //*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Color.fromARGB(255, 253, 253, 253),
                              side: const BorderSide(
                                  width: 1, // the thickness
                                  color: Color.fromARGB(255, 253, 253,
                                      253) // the color of the border
                                  ),
                              padding:
                                  const EdgeInsets.fromLTRB(70, 10, 70, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          child: const Text('حفظ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 11, 9, 9),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // Cancel changes
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text(
                                  "هل أنت متأكد ؟",
                                  textAlign: TextAlign.center,
                                ),
                                content: const Text(
                                  "هل أنت متأكد من أنك تريد إلغاء التغييرات؟",
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection("userAccount")
                                            .doc('uoInwRTOLtM4eph0LwgPI1ULzc12')
                                            .get()
                                            .then((value) {
                                          nameController.text =
                                              value.data()!["full_name"];
                                          EmailContrller.text =
                                              value.data()!["email"];
                                          phoneController.text =
                                              value.data()!["phone_number"];
                                          DOBController.text =
                                              value.data()!["DOB"];
                                          print(
                                              "++++++++++++ Cancel changes! ++++++++++++");
                                        });
                                        Editing = false;
                                        Viewing = true;
                                      });
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("نعم",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 194, 98, 98))),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("لا",
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Color.fromARGB(255, 253, 253, 253),
                              side: const BorderSide(
                                  width: 1, // the thickness
                                  color: Color.fromARGB(255, 253, 253,
                                      253) // the color of the border
                                  ),
                              padding:
                                  const EdgeInsets.fromLTRB(70, 10, 70, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          child: const Text('إلغاء',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 15, 12, 12))),
                        ),
                      ],
                    ))),
          ],
        ),
      )),
      bottomNavigationBar: buildBottomNavigation(height),
    );
  }

  int index = 1;
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
            MaterialPageRoute(builder: (context) => profile()),
          );
        } else if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListOfHouseAccounts()),
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

Future<void> UpdateDB() async {
  print('will be added to db');
  var Edit_info = FirebaseFirestore.instance
      .collection('userAccount')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  Edit_info.update({
    'full_name': nameController.text,
    'phone_number': phoneController.text,
    'DOB': DOBController.text,
  });
  print('profile edited');
}

class global {
  static var index = 0;
}
