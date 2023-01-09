import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

import 'package:intl/intl.dart';
import 'package:rashd/Registration/profile.dart';

import '../HouseAccount/list_of_house_accounts.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class register extends StatefulWidget {
  const register({
    Key? key,
  }) : super(key: key);
  @override
  _registerState createState() => _registerState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController cofirmPasswordController = TextEditingController();
TextEditingController fullNameController = TextEditingController();
TextEditingController DOBController = TextEditingController();
TextEditingController PhoneNumController = TextEditingController();
TextEditingController _codeController = TextEditingController();

String password = "";
String confirm_password = "";

bool invalidEmail = false;
String emailErrorMessage = '';
bool invalidPhone = false;
String phoneErrorMessage = '';

String otpPin = '';
String countryDial = '+966';

void clearForm() {
  emailController.text = "";
  usernameController.text = '';
  passwordController.text = '';
  fullNameController.text = '';
  DOBController.text = '';
  PhoneNumController.text = '';
  _codeController.text = '';

  invalidEmail = false;
  emailErrorMessage = '';
  bool invalidPhone = false;
  String phoneErrorMessage = '';
}

class _registerState extends State<register> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: height * 0.22,
            width: width * 0.75,
            child: Stack(children: [
              Positioned(
                bottom: height * 0,
                top: height * -0.22,
                left: width * 0.08,
                child: Container(
                  width: width * 0.8,
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
                top: height * 0.08,
                right: width * 0.00,
                bottom: 0,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          color: Colors.white,
                          Icons.arrow_back_ios,
                        ),
                        onPressed: () {
                          clearForm();
                          Navigator.of(context).pop();
                        },
                      ),
                      const Text(
                        "إنشاء حساب",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800), // Textstyle
                      ),
                    ]),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.05),
            child: Opacity(
              opacity: 0.8,
              child: (Image.asset(
                'assets/images/logo.jpg',
                height: height * 0.09,
                width: width * 0.2,
              )),
            ),
          ),
        ]),
        registerForm(),
      ]),
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final key = new GlobalKey();

    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 17.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue, fontSize: 17.0);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
            top: 0, left: width * 0.08, right: width * 0.08, bottom: 0),
        child: Column(children: [
          SizedBox(height: height * 0.02),
          //Email
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                suffixIcon: Icon(
                  Icons.mail,
                  color: Color.fromRGBO(53, 152, 219, 1),
                )),
            validator: (email) {
              if (email != null && (email.trim()).isEmpty) {
                return "الرجاء إدخال البريد الإلكتروني.";
              } else if (invalidEmail) {
                return emailErrorMessage;
              }
            },
          ),
          SizedBox(height: height * 0.02),
          //Password
          Stack(
            children: [
              Positioned(
                right: width * 0.450,
                top: height * 0.035,
                child: Tooltip(
                  key: key,
                  message:
                      'كلمة المرور يجب أن تكون من ٨ خانات على الاقل، وتحتوي على:\n- حرف صغير باللغة الانجليزية.\n- حرف كبير باللغة الانجليزية.\n- رقم.',
                  triggerMode: TooltipTriggerMode.manual,
                ),
              ),
              TextFormField(
                onTap: () {
                  final dynamic tooltip = key.currentState;
                  tooltip.ensureTooltipVisible();
                },
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color.fromRGBO(53, 152, 219, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  password = value.toString();
                  RegExp Upper = RegExp(r"(?=.*[A-Z])");
                  RegExp Lower = RegExp(r"(?=.*[a-z])");
                  RegExp digit = RegExp(r"(?=.*[0-9])");
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال كلمة المرور.";
                  } else if (value.length < 7) {
                    return "كلمة المرور يجب أن تكون من ٨ خانات على الاقل."; //ود موجودة ؟
                  } else if (!Upper.hasMatch(value)) {
                    return "حرف كبير باللغة الانجليزية.";
                  } else if (!Lower.hasMatch(value)) {
                    return "حرف صغير باللغة الانجليزية.";
                  } else if (!digit.hasMatch(value)) {
                    return "كلمة المرور يجب أن تحتوي على رقم.";
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          TextFormField(
            controller: fullNameController,
            decoration: const InputDecoration(
                labelText: 'الاسم الكامل',
                suffixIcon: Icon(
                  Icons.person,
                  color: Color.fromRGBO(53, 152, 219, 1),
                )),
            validator: (value) {
              if (value == null || value.isEmpty || (value.trim()).isEmpty) {
                return 'الرجاء إدخال الاسم الكامل.';
              }
              return null;
            },
          ),
          SizedBox(height: height * 0.02),
          TextFormField(
            readOnly: true,
            controller: DOBController,
            onTap: () {
              _selectDate(context);
              showDate = false;
              bDay = getDate();
              // DOBController.text = globals.bDay;
            },
            decoration: const InputDecoration(
              labelText: 'تاريخ الميلاد',
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Color.fromRGBO(53, 152, 219, 1),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || (value.trim()).isEmpty) {
                return 'الرجاء اختيار تاريخ الميلاد.';
              }
            },
          ),
          SizedBox(height: height * 0.02),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: 10,
            controller: PhoneNumController,
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف',
              hintText: '05XXXXXXXX',
              suffixIcon: Icon(
                Icons.phone_android,
                color: Color.fromRGBO(53, 152, 219, 1),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || (value.trim()).isEmpty) {
                return 'الرجاء إدخال رقم الهاتف.';
              } else {
                if (value.length != 10) {
                  return 'الرجاء إدخال رقم هاتف صالح.';
                }
                if (invalidPhone) return phoneErrorMessage;
              }
              return null;
            },
          ),
          SizedBox(height: height * 0.05),
          //button
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
                onPressed: () async {
                  await checkEmail();
                  //  await checkPhoneNum();
                  await isDuplicatePhoneNum();
                  if ((_formKey.currentState!.validate())) {
                    if (await checkEmail() && await isDuplicatePhoneNum()) {
                      // FirebaseAuth.instance.verifyPhoneNumber(
                      //     phoneNumber: "+966 55 119 0202",
                      //     timeout: Duration(seconds: 60),
                      //     verificationCompleted: await signUp(),
                      //     verificationFailed:
                      //         (FirebaseAuthException authException) {
                      //       print(authException.message);
                      //     },
                      //     codeSent: (String verificationId,
                      //         [int? forceResendingToken]) {
                      //       //show dialog to take input from the user
                      //       showDialog(
                      //           context: context,
                      //           barrierDismissible: false,
                      //           builder: (context) => AlertDialog(
                      //                 title: Text("Enter SMS Code"),
                      //                 content: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: <Widget>[
                      //                     TextField(
                      //                       controller: _codeController,
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 actions: <Widget>[
                      //                   ElevatedButton(
                      //                     child: Text("Done"),
                      //                     //     textColor: Colors.white,
                      //                     //     color: Colors.redAccent,
                      //                     onPressed: () {
                      //                       FirebaseAuth auth =
                      //                           FirebaseAuth.instance;

                      //                       final smsCode =
                      //                           _codeController.text.trim();

                      //                       AuthCredential _credential =
                      //                           PhoneAuthProvider.credential(
                      //                               verificationId:
                      //                                   verificationId,
                      //                               smsCode: smsCode);
                      //                       auth
                      //                           .signInWithCredential(
                      //                               _credential)
                      //                           .then((AuthResult result) {
                      //                         Navigator.pushReplacement(
                      //                             context,
                      //                             MaterialPageRoute(
                      //                                 builder: (context) =>
                      //                                     HomeScreen(
                      //                                         result.user)));
                      //                       }).catchError((e) {
                      //                         print(e);
                      //                       });
                      //                     },
                      //                   )
                      //                 ],
                      //               ));
                      //     },
                      //     codeAutoRetrievalTimeout: null);
                      await signUp();
                    }
                  }
                },
                child: const Text('تسجيل'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )),
          SizedBox(height: height * 0.02),
          Center(
              child: RichText(
            text: TextSpan(
              style: defaultStyle,
              children: <TextSpan>[
                const TextSpan(text: ' لديك حساب بالفعل؟ '),
                TextSpan(
                    text: 'تسجيل الدخول',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ));
                      }),
              ],
            ),
          )),
        ]),
      ),
    );
  }

//this function checks if phone number already exists
//Returns true if phone number is not in use.
  Future<bool> isDuplicatePhoneNum() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('userAccount')
        .where('phone_number', isEqualTo: PhoneNumController.text)
        .get();
    if (query.docs.isNotEmpty) {
      invalidPhone = true;
      phoneErrorMessage =
          'رقم الهاتف تم التسجيل به سابقًا، الرجاء إدخال رقم آخر.';
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
          emailErrorMessage =
              ' البريد الإلكتروني مستخدم ، يرجى محاولة تسجيل الدخول.';
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
        emailErrorMessage = 'الرجاء إدخال بريد إلكتروني صالح.';
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
      await saveUser();

      clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مرحبًا بك لرشد')),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ListOfHouseAccounts(),
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
    String fullname = fullNameController.text;
    String dob = DOBController.text;
    String number = PhoneNumController.text;

    final user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;
    final userRef = db.collection("userAccount").doc(user.uid);
    if (!((await userRef.get()).exists)) {
      await userRef.set({
        "email": email,
        "userId": userId,
        "full_name": fullname,
        "DOB": dob,
        "phone_number": number
      });
    }
  }
}
