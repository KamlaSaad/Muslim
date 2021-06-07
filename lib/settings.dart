import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'text.dart';
import 'theme.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    getThemeH();
    theme();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: bodyColor,
          appBar: AppBar(
              backgroundColor: bodyColor,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Txt("الاعدادت", textColor, FontWeight.w600, 22)),
          body: Column(
            children: <Widget>[
              SizedBox(
                height: h * 0.03,
              ),
              //theme
              ListTile(
                  leading: Icon(Icons.brightness_3, color: mainColor, size: 30),
                  title: Text("الوضع الليلي",
                      style: TextStyle(
                          color: textColor, fontSize: 22, fontFamily: "Cairo")),
                  trailing: SizedBox(
                    width: Portrait(media) ? w * 0.15 : w * 0.1,
                    child: Switch(
                        focusColor: mainColor,
                        value: themeVal.value != null ? themeVal.value : false,
                        onChanged: (val) {
                          DynamicTheme.of(context).setBrightness(
                              val == true ? Brightness.dark : Brightness.light);
                          setState(() {
                            switchVal = val;
                            themeVal.value = val;
                          });
                          //saveTheme(val);
                          saveThemeH(val);
                          theme();
                        }),
                  ),
                  onTap: () {}),

              //change password
              ListItem(Icons.lock, "تغيير كلمة المرور", () {
                Navigator.of(context).pushNamed("updatePass");
              }),

              //logout

              ListItem(Icons.exit_to_app, "تسجيل الخروج", () {
                saveUserId(0);
                SystemNavigator.pop();
              })
            ],
          )),
    );
  }

  Route(Widget page, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  Widget ListItem(IconData icon, String txt, Function tap) {
    return ListTile(
        leading: Icon(icon, color: mainColor, size: 30),
        title: Text(txt,
            style:
                TextStyle(color: textColor, fontSize: 19, fontFamily: "Cairo")),
        onTap: tap);
  }
}
