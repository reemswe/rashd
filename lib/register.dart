import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

import 'package:intl/intl.dart';

import 'list_of_house_accounts.dart';
import 'login.dart';

class register extends StatefulWidget {
  const register({
    Key? key,
  }) : super(key: key);
  _registerState createState() => _registerState();
}

TextEditingController emailController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController cofirmPasswordController = TextEditingController();
TextEditingController fullNameController = TextEditingController();
TextEditingController DOBController = TextEditingController();
TextEditingController PhoneNumController = TextEditingController();

String password = "";
String confirm_password = "";

bool invalidEmail = false;
String emailErrorMessage = '';
bool invalidPhone = false;
String phoneErrorMessage = '';

void clearForm() {
  emailController.text = "";
  usernameController.text = '';
  passwordController.text = '';
  fullNameController.text = '';
  DOBController.text = '';
  PhoneNumController.text = '';

  invalidEmail = false;
  emailErrorMessage = '';
  bool invalidPhone = false;
  String phoneErrorMessage = '';
}

class _registerState extends State<register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'تسجيل جديد',
        ),
        leading: //Icon(Icons.more_vert)
            Text(''),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
            onPressed: () {
              clearForm();
              Navigator.of(context).pop();
            },
          ),
        ],
        // elevation: 15,
      ),
      body: registerForm(),
    );
  }
}

class registerForm extends StatefulWidget {
  registerFormState createState() {
    return registerFormState();
  }
}

String bDay = "";

class registerFormState extends State<registerForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  DateTime selectedDate = DateTime.now();
  bool showDate = false;
  ScrollController _scrollController = ScrollController();

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

  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 20.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
        child: ListView(children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Image.asset(
            'assets/images/logo.jpg',
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 20,
          ),
          //Email
          TextFormField(
            textAlign: TextAlign.right,
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'البريد الالكتروني',
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) {
              if (email != null &&
                  !EmailValidator.validate(email) &&
                  (email.trim()).isEmpty) {
                return "الرجاء ادخال البريد الالكتروني";
              } else if (invalidEmail) {
                return emailErrorMessage;
              }
            },
          ),
          // Container(
          //     padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
          //     child: TextFormField(
          //       // maxLength: 20,
          //       textAlign: TextAlign.right,
          //       controller: usernameController,
          //       decoration: InputDecoration(
          //         hintText: 'اسم المستخدم',
          //         contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          //         focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(100.0),
          //             borderSide: const BorderSide(color: Colors.grey)),
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(100.0),
          //             borderSide: BorderSide(color: Colors.grey.shade400)),
          //         errorBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(100.0),
          //             borderSide:
          //                 const BorderSide(color: Colors.red, width: 2.0)),
          //         focusedErrorBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(100.0),
          //             borderSide:
          //                 const BorderSide(color: Colors.red, width: 2.0)),
          //       ),
          //       validator: (value) {
          //         if (value == null ||
          //             value.isEmpty ||
          //             (value.trim()).isEmpty) {
          //           return 'الرجاء ادخال اسم المستخدم';
          //         }
          //         return null;
          //       },
          //     )),
          Container(
              padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
              child: TextFormField(
                textAlign: TextAlign.right,
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  hintText: ' كلمة السر',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  prefixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color.fromRGBO(53, 152, 219, 1),
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  // Wedd's Code for password
                  password = value.toString();
                  RegExp Upper = RegExp(r"(?=.*[A-Z])");
                  RegExp digit = RegExp(r"(?=.*[0-9])");
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال كلمة المرور";
                  } else if (value.length < 7) {
                    return "كلمة المرور يجب أن تكون ٨ احرف على الاقل"; //ود موجودة ؟
                  } else if (!Upper.hasMatch(value)) {
                    return "Password should contain an Upper case";
                  } else if (!digit.hasMatch(value)) {
                    return " كلمة المرور يجب أن تحتوي على رقم";
                  } else {
                    return null;
                  }
                },
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
              child: TextFormField(
                // maxLength: 20,
                textAlign: TextAlign.right,
                controller: fullNameController,
                decoration: InputDecoration(
                  hintText: 'الاسم الكامل',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      (value.trim()).isEmpty) {
                    return 'الرجاء ادخال الاسم الكامل';
                  }
                  return null;
                },
              )),
          Container(
            padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
            child: TextFormField(
              textAlign: TextAlign.right,
              readOnly: true,
              controller: DOBController,
              onTap: () {
                _selectDate(context);
                showDate = false;
                bDay = getDate();
                // DOBController.text = globals.bDay;
              },
              decoration: InputDecoration(
                hintText: 'تاريخ الميلاد',
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
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Color.fromRGBO(53, 152, 219, 1),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || (value.trim()).isEmpty) {
                  return 'الرجاء اختيار تاريخ الميلاد';
                }
              },
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 10,
                textAlign: TextAlign.right,
                controller: PhoneNumController,
                decoration: InputDecoration(
                  // hintText: 'رقم الجوال',
                  labelText: 'رقم الجوال', hintText: '05XXXXXXXX',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: Color.fromRGBO(53, 152, 219, 1),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      (value.trim()).isEmpty) {
                    return 'الرجاء ادخال رقم الجوال';
                  } else {
                    if (value.length > 10 || value.length < 3) {
                      return 'الرجاء ادخال رقم جوال ';
                    }
                    if (invalidPhone) return phoneErrorMessage;
                  }
                  return null;
                },
              )),
          //button
          Container(
              child: ElevatedButton(
            onPressed: () async {
              await checkEmail();
              //  await checkPhoneNum();
              await isDuplicatePhoneNum();
              if ((_formKey.currentState!.validate())) {
                if (await checkEmail() && await isDuplicatePhoneNum()) {
                  await signUp();
                  // if (await checkPhoneNum()) {
                  //   //   await signUp();
                  // }
                }
              }

              // if (await checkPhoneNum()) {
              //   if ((_formKey.currentState!.validate())) {
              //     if (await checkEmail()) await signUp();
              //   }
              // }
            },
            child: Text('تسجيل'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          )),
          Center(
              child: RichText(
            text: TextSpan(
              style: defaultStyle,
              children: <TextSpan>[
                TextSpan(text: ' لديك حساب بالفعل؟ '),
                TextSpan(
                    text: 'تسجيل الدخول',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => login(),
                            ));
                      }),
              ],
            ),
          )),
        ]),
      ),
    );
  }

// // bool docExists = await checkIfDocExists('document_id');
// // print("Document exists in Firestore? " + docExists.toString());
//   /// Check If Document Exists
//   Future<bool> checkIfDocExists(String docId) async {
//     try {
//       // Get reference to Firestore collection
//       var collectionRef = FirebaseFirestore.instance.collection('houseMember');

//       var doc = await collectionRef
//           .where('phone_number', isEqualTo: PhoneNumController.text)
//           .get();
//       return doc.exists;
//     } catch (e) {
//       throw e;
//     }
//   }

// this function checks if uniqueName already exists
//Returns true if phone number is not in use.
  Future<bool> isDuplicatePhoneNum() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('userAccount')
        .where('phone_number', isEqualTo: PhoneNumController.text)
        .get();
    if (query.docs.isNotEmpty) {
      invalidPhone = true;
      phoneErrorMessage = 'رقم الجوال قد سجل به، الرجاء ادخال رقم آخر';
    } else
      invalidPhone = false;

    return query.docs.isEmpty;
  }

// Returns false if email address is in use.
  Future<bool> checkEmail() async {
    try {
      print("try");

      final list = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailController.text.trim());

      if (list.isNotEmpty) {
        setState(() {
          invalidEmail = true;
          emailErrorMessage = 'البريد الالكتروني مستعمل، الرجاء تسجيل الدخول';
        });
        print("empty");
        return false;
      } else {
        setState(() {
          invalidEmail = false;
        });
        print("else");

        // Return true because email adress is not in use
        return true;
      }
    } catch (error) {
      setState(() {
        invalidEmail = true;
        emailErrorMessage = 'The email address is badly formatted.';
      });
      // Handle error
      print('Handle error');

      print(error);
      // ...
      return false;
    }
  }

//check phone num
//create user
  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // await FirebaseAuth.instance.createUserWithPhone
      await saveUser();

      clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مرحبًا بك لرشد')),
      );
      // Navigator.pushNamed(context, "/homePage");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListOfHouseAccounts(),
          ));
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('error'),
          backgroundColor: Colors.red.shade400,
          margin: const EdgeInsets.fromLTRB(6, 0, 3, 0),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: Colors.white,
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  //save to db
  FirebaseFirestore db = FirebaseFirestore.instance;
  saveUser() async {
    String email = emailController.text;
    //String username = usernameController.text;
    String fullname = fullNameController.text;
    String dob = DOBController.text;
    String number = PhoneNumController.text;

    final user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;
    final userRef = db.collection("userAccount").doc(user.uid);
    if (!((await userRef.get()).exists)) {
      await userRef.set({
        //   "user_name": username,
        "email": email,
        "userId": userId,
        "full_name": fullname,
        "DOB": dob,
        "phone_number": number
      });
    }
  }
}
