import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:workmanager/workmanager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cron/cron.dart';
import 'dart:async';
import 'evening.dart';
import 'bearish.dart';
import 'prayers.dart';
import 'signUp.dart';
import 'login.dart';
import 'settings.dart';
import 'text.dart';
import 'updatePass.dart';
import 'dbHelper.dart';
import 'theme.dart';

Workmanager workmanager = Workmanager();
AudioPlayer player = AudioPlayer();
AudioCache audioCache = AudioCache(fixedPlayer: player);

void callbackDispatcher() {
  workmanager.executeTask((task1, inputdata1) async {
    await audioCache.play('mhmd.mp3');
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //salat notifications
  final cron = Cron();
  cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    var now = "${DateTime.now().hour}:${DateTime.now().minute}";
    if (now == "11:43" ||
        now == "12:0" ||
        now == "15:35" ||
        now == "18:43" ||
        now == "20:5") {
      await audioCache.play("azan.mp3");
    }
  });
  //saly 3ly mhmd
  await workmanager.initialize(callbackDispatcher);
  await workmanager.registerPeriodicTask("test_workertask1", "test_workertask1",
      inputData: {"data1": "value1", "data2": "value2"},
      frequency: Duration(minutes: 30),
      initialDelay: Duration(minutes: 1));

  //await backgroundTask(workmanager2, notify, 15);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getUserId();
    getThemeH();
    theme();
    return DynamicTheme(
        defaultBrightness: bright.value,
        data: (brightness) {
          if (brightness == Brightness.light) {
            return ThemeData(accentColor: Colors.blue);
          } else {
            return ThemeData(accentColor: Colors.blue);
          }
        },
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: userId == 0 ? Login() : MyHomePage(),
            routes: {
              'home': (context) => MyHomePage(),
              'morning': (context) => Evening("MORNING", "اذكار الصباح"),
              'evening': (context) => Evening("EVENING", "اذكار المساء"),
              'waking': (context) => Evening("WAKING", "اذكار الاستيقاظ"),
              'sleeping': (context) => Evening("SLEEPING", "اذكار النوم"),
              'prayers': (context) => Prayers(),
              'bearish': (context) => Bearish(),
              'login': (context) => Login(),
              'signup': (context) => SignUp(),
              'settings': (context) => Setting(),
              'updatePass': (context) => UpdatePass()
            },
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double boxW, boxH;
  var flutterLN;
  DbHelper db;
  @override
  void initState() {
    super.initState();
    db = DbHelper();
    var androidSetting = AndroidInitializationSettings('logo');
    var IOSSetting = IOSInitializationSettings();
    var settings =
        InitializationSettings(android: androidSetting, iOS: IOSSetting);
    flutterLN = FlutterLocalNotificationsPlugin()..initialize(settings);
    listenNotify();
  }

  listenNotify() {
    notify();
    Timer(Duration(seconds: 40), () => notify());
  }

  Future notification(String msg) async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.high);
    var iosDetails = IOSNotificationDetails();
    var notDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    flutterLN.show(0, "اذكار المسلم", msg, notDetails);
  }

  bool sent = false;
  notify() async {
    var now = "${DateTime.now().hour}:${DateTime.now().minute}";
    if (now == "11:44") {
      int result = await notification(" سيحين اذان الفجر بعد خمس دقائق");
    } else if (now == "11:55") {
      int result = await notification("سيحين اذان الظهر بعد خمس دقائق ");
    } else if (now == "15:30") {
      int result = await notification("سيحين اذان العصر بعد خمس دقائق");
    } else if (now == "18:40") {
      int result = await notification(" سيحين اذان المغرب بعد خمس دقائق");
    } else if (now == "20:0") {
      int result = await notification(" سيحين العشاء بعد خمس دقائق ");
    }
  }

  @override
  Widget build(BuildContext context) {
    theme();
    MediaQueryData media = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    boxW = Portrait(media) ? size.width * 0.4 : size.width * 0.28;
    boxH = Portrait(media) ? size.height * 0.18 : size.height * 0.25;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: bodyColor,
          appBar: AppBar(
            backgroundColor: bodyColor,
            leading: CircleAvatar(
              backgroundImage: AssetImage("imgs/logo.png"),
              backgroundColor: Colors.transparent,
              radius: 16,
            ),
            title: Txt('اذكار المسلم', textColor, FontWeight.w500, 25),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: textColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("settings");
                },
              )
            ],
          ),
          body: Center(
            child: Portrait(media)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Box("sun.jpg", "اذكار الصباح", () {
                            print(
                                "${DateTime.now().hour}:${DateTime.now().minute}");
                            Push(context, "morning");
                          }, boxH, boxW),
                          Box("", "اذكار المساء", () {
                            Push(context, "evening");
                          }, boxH, boxW),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Box("morning.jpg", "اذكار الاستيقاظ", () {
                            Push(context, "waking");
                          }, boxH, boxW),
                          Box("sleep1.jpg", "اذكار النوم", () {
                            Push(context, "sleeping");
                          }, boxH, boxW),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Box("pray.jpg", "ادعية", () {
                            Push(context, "prayers");
                          }, boxH, boxW),
                          Box("bearish.jpg", "السبحة الالكترونية", () {
                            Push(context, "bearish");
                          }, boxH, boxW),
                        ],
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Box("sun.jpg", "اذكار الصباح", () async {
                            Push(context, "morning");
                          }, boxH, boxW),
                          Box("moon1.jpg", "اذكار المساء", () {
                            Push(context, "evening");
                          }, boxH, boxW),
                          Box("morning.jpg", "اذكار الاستيقاظ", () {
                            Push(context, "waking");
                          }, boxH, boxW),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Box("sleep1.jpg", "اذكار النوم", () {
                            Push(context, "sleeping");
                          }, boxH, boxW),
                          Box("pray.jpg", "ادعية", () {
                            Push(context, "prayers");
                          }, boxH, boxW),
                          Box("bearish.jpg", "السبحة الالكترونية", () {
                            Push(context, "bearish");
                          }, boxH, boxW),
                        ],
                      ),
                    ],
                  ),
          ),
        ));
  }

  Widget Box(String img, String text, Function press, double h, double w) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            height: h,
            width: w,
            decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: img != ""
                ? CircleAvatar(
                    backgroundImage: AssetImage("imgs/" + img),
                    backgroundColor: Colors.transparent,
                    radius: 50,
                  )
                : CircleAvatar(
                    child: Icon(Icons.nightlight_round,
                        size: 100, color: textColor),
                    backgroundColor: bodyColor,
                    radius: 50,
                  ),
          ),
          Container(
              height: 35,
              width: w,
              color: Colors.blueGrey,
              child: Center(
                child: Txt(text, Colors.white, FontWeight.normal, 16),
              )),
        ],
      ),
      onPressed: press,
    );
  }

  Push(BuildContext context, String page) {
    Navigator.of(context).pushNamed(page);
  }
}
