import 'package:flutter/material.dart';
import 'package:muslim/dbHelper.dart';
import 'input.dart';
import 'theme.dart';

String name, email, pass;
bool emailValid = false, show = false;
bool isEmai() {
  emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    getThemeH();
    theme();
    Size s = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: bodyColor,
          appBar: null,
          body: ListView(
            children: [
              Container(
                  width: s.width,
                  height: s.height,
                  child: Center(
                      child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          Spacer(),
                          Text("انشاء حساب",
                              style: TextStyle(
                                  fontSize: 37,
                                  color: textColor,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -1)),
                          Spacer(),
                          Spacer(),
                          //user name
                          Input(Icons.person, "اسم المستخدم", false, (val) {
                            if (val.isEmpty) {
                              return "ادخل اسم المستخدم";
                            }
                            return null;
                          }, (val) {
                            setState(() {
                              name = val;
                            });
                          }),
                          Spacer(),
                          Input(Icons.mail, "البريد الالكتروني", false, (val) {
                            if (val.isEmpty) {
                              return "ادخل البريد الالكتروني";
                            } else if (emailValid == false) {
                              return "البريد الالكتروني غير صحيح";
                            }
                            return null;
                          }, (val) {
                            setState(() {
                              email = val;
                              isEmai();
                            });
                          }),
                          Spacer(),
                          Input(Icons.lock, " كلمة المرور", true, (val) {
                            if (val.isEmpty) {
                              return "ادخل كلمة المرور";
                            }
                            return null;
                          }, (val) {
                            setState(() {
                              pass = val;
                            });
                          }),
                          Spacer(),
                          //login button
                          ButtonContainer("تاكيد", () async {
                            if (formKey.currentState.validate()) {
                              int id = await addUser(name, email, pass);
                              print(id);
                              if (id != 0) {
                                setState(() {
                                  saveUserId(id);
                                });
                                print("user $id");
                                Navigator.of(context)
                                    .pushReplacementNamed("home");
                              } else {
                                print("insertion failed");
                              }
                            }
                          }, Colors.white),
                          Spacer(),
                          Spacer(),
                          Center(
                            child: FlatBtn("لديك حساب", " دخول ", () {
                              Navigator.pushNamed(context, "login");
                            }),
                          ),
                          Spacer(),
                        ]),
                  ))),
            ],
          )),
    );
  }

  Widget Input(IconData prefix, String hintTxt, bool suffix, Function validate,
      Function save) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 35,
      ),
      child: TextFormField(
        obscureText: suffix ? show : false,
        style: TextStyle(color: textColor, fontSize: 20),
        decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 15),
            fillColor: boxColor,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 3),
            prefixIcon: Icon(
              prefix,
              color: mainColor,
            ),
            hintText: hintTxt,
            hintStyle: TextStyle(color: textColor, fontSize: 20),
            suffixIcon: suffix
                ? IconButton(
                    icon: Icon(
                      show ? Icons.visibility : Icons.visibility_off,
                      color: textColor,
                    ),
                    onPressed: () {
                      setState(() {
                        show = !show;
                      });
                    },
                  )
                : null),
        validator: validate,
        onChanged: save,
      ),
    );
  }
}
