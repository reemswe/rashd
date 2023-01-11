import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'create_house_account.dart';
import 'dashboard.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HouseMembers extends StatefulWidget {
  final String houseId;
  const HouseMembers({super.key, required this.houseId});

  @override
  State<HouseMembers> createState() => _houseMembersState();
}

class _houseMembersState extends State<HouseMembers> {
  Future? data;
  List? membersList = [];
  @override
  void initState() {
    data = getData();
    membersList!.clear();
    super.initState();
  }

  Future getData() async {
    var collection = await FirebaseFirestore.instance
        .collection('houseAccount')
        .doc(widget.houseId)
        .collection('houseMember');

    // to get data from all documents sequentially
    collection.snapshots().listen((querySnapshot) {
      membersList!.clear();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data(); // <-- Retrieving the value.
        setState(() {
          membersList!.add([
            {
              'nickName': data['nickName'],
              'privilege': data['privilege'],
              'memberID': data['memberID']
            }
          ]);
        });
      }
    });
    // print(membersList);
    return membersList;
  }

  List dataList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' الأعضاء',
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
                value: 'share',
                child: Text("مشاركة لوحة المعلومات "),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text("حذف حساب المنرل",
                    style: TextStyle(color: Color.fromARGB(255, 167, 32, 32))),
              ),
            ];
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body:
          //  ListView(children: [
          //   Container(
          //       padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
          //       child: Column(children: [
          //         TextFormField(
          //           readOnly: true,
          //           textAlign: TextAlign.right,
          //           decoration: const InputDecoration(
          //             hintText: ' لوحة المعلومات',
          //             hintStyle: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20,
          //                 color: Colors.black),
          //             contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          //             border: InputBorder.none,
          //           ),
          //         ),
          //       ])),
          FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dataList = snapshot.data as List;
            print(dataList);
            return buildItems(dataList);
          }
          return const Center(child: CircularProgressIndicator());
          // membersList.removeAt(0);
          // print(membersList);
          // return buildItems(membersList);
        },
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  // builds the list to show house members
  Widget buildItems(dataList) => ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: dataList.length,
      // separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        Widget icon = const Icon(PhosphorIcons.binoculars);
        if (dataList[index][0]["privilege"] == 'editor') {
          icon = Icon(Icons.edit_note_outlined);
        }

        return Container(
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            decoration: BoxDecoration(
              // border: Border.all(color: Color(0xff940D5A)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(13.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 6.0),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: ListTile(
                trailing: Text(
                  dataList[index][0]["nickName"],
                ),
                title: SizedBox(
                  width: 1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            //wedd
                            FirebaseFirestore.instance
                                .collection('houseAccount')
                                .doc(widget.houseId)
                                .collection('houseMember')
                                .doc(dataList[index][2]["memberID"])
                                .delete()
                                .then((_) {
                              print("success!, member deleted");
                            });
                          },
                        ),
                        icon,
                      ]),
                )));
      });
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
            MaterialPageRoute(
                builder: (context) => HouseMembers(
                      houseId: widget.houseId,
                    )),
          );
        } else if (global.index == 1) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => const dashboard(
          //             dashId: 'fIgVgfieeVqGRB9oRne1',
          //           )),
          // );
        } else if (global.index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const dashboard(
                      dashId: 'fIgVgfieeVqGRB9oRne1',
                    )),
          );
        } else if (global.index == 3) {}
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.people_alt_rounded),
          title: const Text(
            ' الأعضاء',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.electrical_services_rounded),
          title: const Text(
            ' اجهزتي',
            textAlign: TextAlign.center,
          ),
          activeColor: Colors.lightBlue,
        ),
        BottomNavyBarItem(
            icon: const Icon(Icons.auto_graph_outlined),
            title: const Text(
              'لوحة المعلومات',
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.lightBlue),
        BottomNavyBarItem(
            icon: const Icon(Icons.holiday_village_rounded),
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
