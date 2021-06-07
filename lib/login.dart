import 'package:flutter/material.dart';
import 'input.dart';
import 'dbHelper.dart';
import 'text.dart';
import 'theme.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String name, password;
  bool show = true;
  @override
  Widget build(BuildContext context) {
    getThemeH();
    theme();
    Size s = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: bodyColor,
          //resizeToAvoidBottomPadding: false,
          body: ListView(children: [
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
                            //SvgPicture.asset("imgs/myLogo.svg",height: 80,width: 100,),
                            Image(
                              image: AssetImage("imgs/logo.png"),
                              height: s.height * 0.2,
                              width: s.width * 0.3,
                            ),
                            Text("مرحبا بعودتك",
                                style: TextStyle(
                                    fontSize: 37,
                                    fontFamily: "Cairo",
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -2.6)),
                            Spacer(),
                            //user name
                            Input(Icons.person, "ادخل اسم المستخدم", false,
                                (val) {
                              setState(() {
                                name = val;
                              });
                            }),
                            Spacer(),
                            //password
                            Input(Icons.lock, "ادخل كلمة المرور", true, (val) {
                              setState(() {
                                password = val;
                              });
                            }),
                            Spacer(),
                            //login button
                            ButtonContainer("تاكيد", () async {
                              if (formKey.currentState.validate()) {
                                var data = await login(name, password);
                                if (data.length == 1) {
                                  setState(() {
                                    saveUserId(data.last['ID']);
                                  });
                                  print("user id${data.last['ID']}");
                                  Navigator.of(context)
                                      .pushReplacementNamed("home");
                                } else {
                                  scaffoldKey.currentState
                                      .showSnackBar(showMsg());
                                  print("login failed");
                                }
                              }
                            }, Colors.white),

                            Spacer(),
                            Spacer(),
                            Spacer(),
                            //sign up button
                            FlatBtn(
                              "ليس لديك حساب ",
                              " انشاء حساب",
                              () {
                                Navigator.pushNamed(context, "signup");
                              },
                            ),
                            Spacer(),
                          ])),
                ))
          ])),
    );
  }

  Widget Input(IconData prefix, String hintTxt, bool suffix, Function save) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: TextFormField(
        obscureText: suffix ? show : false,
        style: TextStyle(color: textColor, fontSize: 20),
        decoration: InputDecoration(
            fillColor: boxColor,
            filled: true,
            errorStyle: TextStyle(fontSize: 15),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            prefixIcon: Icon(
              prefix,
              color: mainColor,
            ),
            hintText: hintTxt,
            hintStyle: TextStyle(color: textColor, fontSize: 20),
            contentPadding: EdgeInsets.symmetric(vertical: 3),
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
        validator: (value) {
          if (value.isEmpty) {
            return hintTxt;
          }
          return null;
        },
        onChanged: save,
      ),
    );
  }

  Widget showMsg() {
    return SnackBar(
      backgroundColor: boxColor,
      content: Txt(
          "فشل تسجيل الدخول تاكد من بياناتك", textColor, FontWeight.normal, 16),
    );
  }
}
