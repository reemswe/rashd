import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateHouseAccount extends StatefulWidget {
  const CreateHouseAccount({super.key});

  @override
  State<CreateHouseAccount> createState() => _CreateHouseAccountState();
}

class _CreateHouseAccountState extends State<CreateHouseAccount> {
  TextEditingController houseName = TextEditingController();
  TextEditingController phone = TextEditingController();
  String memberRole1 = "role";

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
      body: Container(
        transformAlignment: Alignment.topRight,
        child: ListView(
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
                              borderSide: const BorderSide(color: Colors.grey)),
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
                      )
                    ])),
            Container(
                padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text('اعضاء المنزل ', textAlign: TextAlign.right),
                      TextFormField(
                        // maxLength: 20,
                        maxLength: 20,

                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: ' الاسم ',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: const BorderSide(color: Colors.grey)),
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        // maxLength: 20,
                        maxLength: 10,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: ' رقم الجوال ',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              borderSide: const BorderSide(color: Colors.grey)),
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
                        keyboardType: TextInputType.number,
                      ),
                    ])),
            Row(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(
                  child: Text(
                    '  محرر',
                    textAlign: TextAlign.right,
                  ),
                ),
                Radio(
                  value: "editor",
                  groupValue: memberRole1,
                  onChanged: (str) {
                    setState(() {
                      memberRole1 = str!;
                    });
                  },
                ),
                const Expanded(
                    child: Text(
                  ' مشاهد',
                  textAlign: TextAlign.right,
                )),
                Radio(
                  value: "viewer",
                  groupValue: memberRole1,
                  onChanged: (str) {
                    //print(T);
                    setState(() {
                      memberRole1 = str!;
                    });
                  },
                ),
              ],
            ),
            Container(
                //padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
                padding: const EdgeInsets.fromLTRB(6, 12, 0, 12),
                child: TextFormField(
                  // add another house member
                  // onTap: ,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                      hintText: '  إضافة عضو آخر ',
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (houseName.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                              '  الرجاء إدخال اسم للمنزل',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.redAccent),
                      );
                    } else {
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
      ),
    );
  }

  void setData() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;

    FirebaseFirestore.instance.collection('houseAccount').add({
      'OwnerID': userId,
      'dashboardID': '',
      'houseID': '',
      'houseName': houseName,
      'houseOwner': '',
    });
    //FirebaseFirestore.instance.collection('userAccount').snapshots(
  }
}
