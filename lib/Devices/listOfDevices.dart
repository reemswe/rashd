import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class listOfDevices extends StatefulWidget {
  const listOfDevices({super.key});

  @override
  State<listOfDevices> createState() => listOfDevicesState();
}

class listOfDevicesState extends State<listOfDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' البيت',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    textAlign: TextAlign.left,
                  ),
                  content: const Text(
                    'رجاء ادخل رقم جوال لمشاركة لوحة المعلومات',
                    textAlign: TextAlign.left,
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
                    textAlign: TextAlign.left,
                  ),
                  content: const Text(
                    "هل أنت متأكد من حذف حساب المنزل ؟",
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
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        transformAlignment: Alignment.topRight,
        child: Column(
            //padding: const EdgeInsets.all(20),
            //shrinkWrap: true,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: Column(children: [
                    TextFormField(
                      readOnly: true,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: ' لوحة المعلومات',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        border: InputBorder.none,
                      ),
                    ),
                    TextFormField(
                      // maxLength: 20,
                      readOnly: true,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: ' شهر نوفمبر',
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ])),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 16),
                  child: InkWell(
                    onTap: () {},
                    // => showModalBottomSheet(
                    //     isScrollControlled:
                    //         true,
                    //     backgroundColor:
                    //         Colors
                    //             .transparent,
                    //     context: context,
                    //     builder: (context) =>
                    //         buildPlace(
                    //             data.docs[
                    //                     index]
                    //                 ['docId'],
                    //             isAdmin,
                    //             data.docs[
                    //                     index]
                    //                 [
                    //                 'status'])),
                    splashColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 32,
                                color: Colors.black45,
                                spreadRadius: -8)
                          ],
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  child: Text('hello world')
                                  //     AspectRatio(
                                  //   aspectRatio:
                                  //       2,
                                  //   child: Image
                                  //       .network(
                                  //     data.docs[index]
                                  //         [
                                  //         'img'],
                                  //     fit: BoxFit
                                  //         .cover,
                                  //     errorBuilder: (BuildContext context,
                                  //         Object
                                  //             exception,
                                  //         StackTrace?
                                  //             stackTrace) {
                                  //       return const Text(
                                  //           'Image could not be load');
                                  //     },
                                  //   ),
                                  // )),
                                  ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            13, 8, 0, 8),
                                        child: Text(
                                          'name',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          13, 0, 0, 15),
                                      child: Text(
                                        'category',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                      )),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ]),
      ),
      // bottomNavigationBar: buildBottomNavigation(),
    );
  }

  // int index = 0;
  // Widget buildBottomNavigation() {
  //   return BottomNavyBar(
  //     selectedIndex: global.index,
  //     onItemSelected: (index) {
  //       setState(
  //         () => global.index = index,
  //       );
  //       if (global.index == 0) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const devicesList()),
  //         );
  //       } else if (global.index == 1) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const dashboard()),
  //         );
  //       } else if (global.index == 2) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const ListOfHouseAccounts()),
  //         );
  //       }
  //     },
  //     items: <BottomNavyBarItem>[
  //       BottomNavyBarItem(
  //         icon: const Icon(Icons.electrical_services_rounded),
  //         // icon: IconButton(
  //         //     icon: const Icon(Icons.person_outline_rounded),
  //         //     onPressed: () {
  //         //       setState(
  //         //         () => this.index = index,
  //         //       );
  //         //       Navigator.push(
  //         //         context,
  //         //         MaterialPageRoute(
  //         //             builder: (context) => const CreateHouseAccount()),
  //         //       );
  //         //     }),
  //         title: const Text(
  //           ' اجهزتي',
  //           textAlign: TextAlign.center,
  //         ),
  //         activeColor: Colors.lightBlue,
  //       ),
  //       BottomNavyBarItem(
  //           icon: const Icon(Icons.auto_graph_outlined),
  //           // icon: IconButton(
  //           //     icon: const Icon(Icons.holiday_village_rounded),
  //           //     onPressed: () {

  //           //       setState(
  //           //         () => this.index = index,
  //           //       );
  //           //       Navigator.push(
  //           //         context,
  //           //         MaterialPageRoute(
  //           //             builder: (context) => const ListOfHouseAccounts()),
  //           //       );
  //           //     }),
  //           title: const Text(
  //             'لوحة المعلومات',
  //             textAlign: TextAlign.center,
  //           ),
  //           activeColor: Colors.lightBlue),
  //       BottomNavyBarItem(
  //           icon: const Icon(Icons.holiday_village_rounded),
  //           // icon: IconButton(
  //           //     icon: const Icon(Icons.holiday_village_rounded),
  //           //     onPressed: () {

  //           //       setState(
  //           //         () => this.index = index,
  //           //       );
  //           //       Navigator.push(
  //           //         context,
  //           //         MaterialPageRoute(
  //           //             builder: (context) => const ListOfHouseAccounts()),
  //           //       );
  //           //     }),
  //           title: const Text(
  //             'منازلي',
  //             textAlign: TextAlign.center,
  //           ),
  //           activeColor: Colors.lightBlue),
  //     ],
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   );
  // }

  Widget buildCard(List content) {
    return Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xff940D5A)),
          color: content[3],
          borderRadius: BorderRadius.circular(17.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 7.0),
              blurRadius: 7.0,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(6, 5, 2, 9),
        margin: const EdgeInsets.fromLTRB(15, 23, 10, 23),
        //color: content[3],
        child: GridTile(
          child: Center(
              child: Text(
            content[0],
            textAlign: TextAlign.center,
            style: TextStyle(color: content[4], fontWeight: FontWeight.w600),
          )),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
