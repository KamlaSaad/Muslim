import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'input.dart';
import 'dbHelper.dart';
import 'theme.dart';

class UpdatePass extends StatefulWidget {
  @override
  _UpdatePassState createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String oldPass, newPass;
  bool show1 = true, show2 = true;
  var c1 = TextEditingController(), c2 = TextEditingController();
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
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "تغيير كلمة المرور",
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w600,
                  color: textColor),
            ),
            backgroundColor: bodyColor,
          ),
          body: ListView(
            children: [
              Form(
                  key: formKey,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: s.height * 0.1,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage("imgs/logo.png"),
                      backgroundColor: Colors.transparent,
                      radius: 80,
                    ),
                    SizedBox(
                      height: s.height * 0.05,
                    ),
                    //user old pass
                    Input(c1, Icons.lock_open, "كلمة المرور القديمة",
                        "ادخل كلمة المرور القديمة", true, (val) {
                      setState(() {
                        oldPass = val;
                      });
                    }),
                    SizedBox(
                      height: 16,
                    ),
                    //user new pass
                    Input(c2, Icons.lock, "كلمة المرور الحديثة",
                        "ادخل كلمة المرور الحديثة", false, (val) {
                      setState(() {
                        newPass = val;
                      });
                    }),
                    SizedBox(
                      height: 16,
                    ),
                    //login button
                    ButtonContainer("تاكيد", () async {
                      var id = await getId(oldPass).then((value) => value);
                      if (formKey.currentState.validate()) {
                        if (id.length != 0) {
                          scaffoldKey.currentState
                              .showSnackBar(showMsg("تم التحديث بنجاح"));
                          updateUser(newPass, id.last['ID']);
                          c1.clear();
                          c2.clear();
                        } else {
                          scaffoldKey.currentState.showSnackBar(
                              showMsg(" فشل التحديث تاكد من كلمة المرور"));
                          print("failed!");
                        }
                      }
                    }, Colors.white),
                  ]))
            ],
          )),
    );
  }

  Widget Input(TextEditingController controller, IconData prefix,
      String hintTxt, String wrong, bool oldPass, Function save) {
    Icon icon1 = Icon(
          show1 ? Icons.visibility : Icons.visibility_off,
          color: textColor,
        ),
        icon2 = Icon(
          show2 ? Icons.visibility : Icons.visibility_off,
          color: textColor,
        );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: TextFormField(
        obscureText: oldPass ? show1 : show2,
        controller: controller,
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
            suffixIcon: IconButton(
              icon: oldPass ? icon1 : icon2,
              onPressed: () {
                setState(() {
                  oldPass ? show1 = !show1 : show2 = !show2;
                  print('$show1 and $show2');
                });
              },
            )),
        validator: (value) {
          if (value.isEmpty) {
            return wrong;
          }
          return null;
        },
        onChanged: save,
      ),
    );
  }

  Widget showMsg(String txt) {
    return SnackBar(
        backgroundColor: boxColor,
        content: Text(
          txt,
          style: TextStyle(color: textColor, fontSize: 20, fontFamily: "Cairo"),
        ));
  }
}
