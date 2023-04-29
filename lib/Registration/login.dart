// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import '../Mocks.dart';
import '../functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(children: [
              Expanded(
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
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
                                      "تسجيل الدخول",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.0,
                                          fontWeight:
                                              FontWeight.w800), // Textstyle
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
                  LoginForm(),
                ]),
              ),
            ])),
      ]),
    );
  }
}

void clearForm() {
  emailController.text = "";
  passwordController.text = '';
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  bool _isMounted = false;

  bool invalidData = false;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 17.0);
    TextStyle linkStyle = const TextStyle(
        color: Colors.blue, decoration: TextDecoration.underline);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
            top: 0, left: width * 0.08, right: width * 0.08, bottom: 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "مرحبًا بك مجددًا، \nسجل الدخول للوصول إلى منزلك",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: height * 0.045),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  suffixIcon: Icon(
                    Icons.mail,
                    color: Color.fromRGBO(53, 152, 219, 1),
                  ),
                ),
                validator: (value) {
                  if (invalidData) {
                    return '';
                  } else if (value == null ||
                      value.isEmpty ||
                      (value.trim()).isEmpty) {
                    return 'الرجاء ادخال البريد الإلكتروني';
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
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
                validator: (value) {
                  if (invalidData) {
                    return '';
                  } else if (value == null ||
                      value.isEmpty ||
                      (value.trim()).isEmpty) {
                    return 'الرجاء إدخال كلمة المرور.';
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              Visibility(
                  visible: invalidData,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                        'البريد إلكتروني/ كلمة المرور غير صالحة، يرجى المحاولة مرة أخرى.',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  )),
              SizedBox(height: height * 0.03),
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
                      stops: const [0.1, 1.0],
                      colors: [
                        Colors.blue.shade200,
                        Colors.blue.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (TestWidgetsFlutterBinding.ensureInitialized()
                            .inTest) {
                          await login(emailController.text,
                              passwordController.text, MockFirebaseAuth());
                        } else {
                          await login(emailController.text,
                              passwordController.text, FirebaseAuth.instance);
                        }
                        showToast('valid', 'تم تسجيل دخولك بنجاح');

                        clearForm();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ListOfHouseAccounts(),
                            ));
                      }
                    },
                    child: const Text('تسجيل الدخول'),
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
                    const TextSpan(
                      text: ' ليس لديك حساب؟ ',
                      style: TextStyle(fontSize: 17),
                    ),
                    TextSpan(
                        text: 'تسجيل جديد',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            clearForm();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const register(),
                                ));
                          }),
                  ],
                ),
              )),
            ]),
      ),
    );
  }

  Future<void> login(String email, String password, auth) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (!_isMounted) {
        invalidData = true;
      } else {
        if (email.isNotEmpty && password.isNotEmpty) {
          setState(() {
            invalidData = true;
          });
        }
      }
    }
  }
}
