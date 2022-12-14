import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../HouseAccount/list_of_house_accounts.dart';
import 'register.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

TextEditingController usernameController = TextEditingController();

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool inProgress = false;

void clearForm() {
  emailController.text = "";
  usernameController.text = '';
  passwordController.text = '';
  inProgress = false;
}

class _loginPageState extends State<login> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        /*inProgress*/ false
            ? Center(child: CircularProgressIndicator())
            : SizedBox(),
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: inProgress && false ? 0.2 : 1,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(children: [
                Expanded(
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        "?????????? ????????????",
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
                    loginForm(),
                  ]),
                ),
              ])),
        ),
      ]),
    );
  }
}

class loginForm extends StatefulWidget {
  const loginForm({super.key});

  @override
  loginFormState createState() {
    return loginFormState();
  }
}

bool _passwordVisible = false;

class loginFormState extends State<loginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool invalidData = false;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 17.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);

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
                  "???????????? ???? ?????????????? \n?????? ???????????? ???????????? ?????? ??????????",
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
                  labelText: '???????????? ????????????????????',
                  suffixIcon: Icon(
                    Icons.mail,
                    color: Color.fromRGBO(53, 152, 219, 1),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      (value.trim()).isEmpty) {
                    return '???????????? ?????????? ?????? ????????????????';
                  } else if (invalidData) {
                    return '';
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: passwordController,
                obscureText: !_passwordVisible,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: '???????? ????????????',
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
                  if (value == null ||
                      value.isEmpty ||
                      (value.trim()).isEmpty) {
                    return '???????????? ?????????? ???????? ????????????.';
                  } else if (invalidData) {
                    return '';
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
                        '???????????? ????????????????/ ???????? ???????????? ?????? ???????????? ???????? ???????????????? ?????? ????????.',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  )),
              SizedBox(height: height * 0.03),

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
                      if (_formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            inProgress = true;
                          });
                          final newUser = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              )
                              .then((value) => {
                                    setState(() {
                                      inProgress = false;
                                    })
                                  });
                          clearForm();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ListOfHouseAccounts(),
                              ));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                    '???? ?????????? ?????????? ??????????',
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.green));
                        } on FirebaseAuthException catch (e) {
                          print(e);
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            setState(() {
                              invalidData = true;
                            });
                          }
                        }
                      }
                    },
                    child: const Text('?????????? ????????????'),
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
                      text: ' ?????? ???????? ?????????? ',
                      style: TextStyle(fontSize: 17),
                    ),
                    TextSpan(
                        text: '?????????? ????????',
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
}
