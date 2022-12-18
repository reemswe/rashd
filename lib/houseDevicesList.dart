import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'addDevice.dart';
import 'create_house_account.dart';

import 'dashboard.dart';
import 'list_of_house_accounts.dart';
import 'register.dart';

class devicesList extends StatefulWidget {
  const devicesList({
    Key? key,
  }) : super(key: key);
  _devicesListState createState() => _devicesListState();
}

class _devicesListState extends State<devicesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البيت',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: //Icon(Icons.more_vert)
            PopupMenuButton(
          onSelected: (value) {
            if (value == 'share') {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    "مشاركة لوحة المعلومات",
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    'رجاء ادخل رقم جوال لمشاركة لوحة المعلومات',
                    textAlign: TextAlign.right,
                  ),
                  actions: <Widget>[
                    TextFormField(
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: " رقم الهاتف",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '  رجاء ادخل رقم هاتف';
                        }
                        if (value.length < 10) {
                          return '  رجاء ادخل رقم هاتف صحيح';
                        }
                        return null;
                      },
                    ),
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
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("مشاركة",
                            style: TextStyle(
                                color: Color.fromARGB(255, 35, 129, 6))),
                      ),
                    ),
                  ],
                ),
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Share()),
              // );
            }
            if (value == 'delete') {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    "حذف المنزل",
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    "هل أنت متأكد من حذف حساب المنزل ؟",
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
                    //log in ok button
                    TextButton(
                      onPressed: () {
                        // pop out
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("حذف",
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
                child: Text("مشاركة لوحة المعلومات "),
                value: 'share',
              ),
              PopupMenuItem(
                child: Text("حذف حساب المنرل",
                    style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
                value: 'delete',
              ),
            ];
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              clearForm();
              Navigator.of(context).pop();
            },
          ),
        ],
        //elevation: 35,
      ),
      //  clearForm();
      //       Navigator.of(context).pop();
      //       setState(() {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(
      //               content: Text('الانتقال الى الصفحة السابقة')),
      //         );
      //       });
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(6, 12, 0, 12),
              child: TextFormField(
                // maxLength: 20,
                readOnly: true,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'قائمة الأجهزة',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => add_device(),
                          ));
                    },
                  ),
                ),
              )),
          Expanded(
            child: loginForm(),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigation(),
      // loginForm(),
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
            MaterialPageRoute(builder: (context) => const devicesList()),
          );
        } else if (global.index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const dashboard()),
          );
        } else if (global.index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListOfHouseAccounts()),
          );
        }
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.electrical_services_rounded),
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
            ' اجهزتي',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
        BottomNavyBarItem(
            icon: const Icon(Icons.auto_graph_outlined),
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
              'لوحة المعلومات',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
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

class loginForm extends StatefulWidget {
  loginFormState createState() {
    return loginFormState();
  }
}

bool _passwordVisible = false;

class loginFormState extends State<loginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  ScrollController _scrollController = ScrollController();
  List devices = ['المكيف', 'الثلاجة', 'المايكرويف', 'التلفاز', 'الفريزر'];
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (context, index) {
        final item = devices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // What do i do here?
                },
                child: Container(
                  // margin: EdgeInsets.all(0),
                  height: 150,
                  width: 160,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Color(0xff940D5A)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 7.0),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 10.0, left: 30.0, bottom: 3.0),
                        child: Text(
                          "${devices[index]}",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                          // textAlign: TextAlign.center,
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                      //   child: LiteRollingSwitch(
                      //     //initial value
                      //     value: true,
                      //     textOn: 'On',
                      //     textOff: 'Off',
                      //     colorOn: Colors.greenAccent,
                      //     colorOff: Colors.redAccent,
                      //     iconOn: Icons.done,
                      //     iconOff: Icons.remove_circle_outline,
                      //     textSize: 15.0,
                      //     onChanged: (bool state) {
                      //       //Use it to manage the different states
                      //       print('Current State of SWITCH IS: $state');
                      //     },
                      //     onTap: () {}, onSwipe: () {}, onDoubleTap: () {},
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    // return Padding(
    //   padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
    //   child: ListView(children: <Widget>[
    //     Container(
    //         padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
    //         child: TextFormField(
    //           // maxLength: 20,
    //           textAlign: TextAlign.right,
    //           controller: usernameController,
    //           decoration: InputDecoration(
    //             hintText: 'الرمز',
    //             contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    //             focusedBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(100.0),
    //                 borderSide: const BorderSide(color: Colors.grey)),
    //             enabledBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(100.0),
    //                 borderSide: BorderSide(color: Colors.grey.shade400)),
    //             errorBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(100.0),
    //                 borderSide:
    //                     const BorderSide(color: Colors.red, width: 2.0)),
    //             focusedErrorBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(100.0),
    //                 borderSide:
    //                     const BorderSide(color: Colors.red, width: 2.0)),
    //           ),
    //           validator: (value) {
    //             if (value == null || value.isEmpty || (value.trim()).isEmpty) {
    //               return 'Please enter a title.';
    //             }
    //             return null;
    //           },
    //         )),

    //     //button
    //     Container(
    //         child: ElevatedButton(
    //       onPressed: () {
    //         if (_formKey.currentState!.validate())
    //           //       Navigator.push(
    //           // context,
    //           // MaterialPageRoute(
    //           //   builder: (context) => homePage(),
    //           // ));
    //           clearForm();
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(
    //               content: Text('تم تسجيل دخولك بنجاح'),
    //               backgroundColor: Colors.green),
    //         );
    //       },
    //       child: Text('تحقق من الرمز'),
    //       style: ElevatedButton.styleFrom(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(30),
    //         ),
    //       ),
    //     )),
    //   ]),
    // );
  }
}
