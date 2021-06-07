import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'theme.dart';

class Bearish extends StatefulWidget {
  @override
  _BearishState createState() => _BearishState();
}

class _BearishState extends State<Bearish> {
  void startServiceInPlatform() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("lightacademy/channel");
      String data = await methodChannel.invokeMethod("playMusic");
      debugPrint(data);
    }
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Size s = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
          backgroundColor: bodyColor,
          title: Text('السبحة الالكترونية',
              style: TextStyle(
                  color: textColor, fontSize: 24, fontFamily: "Cairo")),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(counter.toString(),
                  style: TextStyle(
                      color: textColor,
                      fontSize: 40,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: s.height * 0.04,
              ),
              CircleAvatar(
                  radius: Portrait(media) ? s.width * 0.25 : s.width * 0.14,
                  backgroundColor: Colors.blueGrey.withOpacity(0.75),
                  child: Button(
                    Portrait(media) ? s.width * 0.3 : s.width * 0.17,
                    Colors.blueGrey,
                    () {
                      startServiceInPlatform();
                      setState(() {
                        counter++;
                      });
                    },
                  )),
              Spacer(),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //SizedBox(width: 6,),
                  Button(
                    26,
                    Colors.red,
                    () {
                      setState(() {
                        counter = 0;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Button(double size, Color color, Function press) {
    return Container(
      height: size,
      width: size,
      decoration: dec(size, color),
      child: FlatButton(
        onPressed: press,
      ),
    );
  }

  BoxDecoration dec(double size, Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
          )
        ]);
  }
}
