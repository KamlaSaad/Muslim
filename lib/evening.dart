import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'input.dart';
import 'text.dart';
import 'theme.dart';
import 'dbHelper.dart';

AudioPlayer player = AudioPlayer();
AudioCache audioCache = AudioCache(fixedPlayer: player);

class Evening extends StatefulWidget {
  String table, title;
  Evening(String tbl, String til) {
    this.table = tbl;
    this.title = til;
  }
  @override
  _EveningState createState() => _EveningState();
}

String item, count, audio;
int length;
bool playing = false;

class _EveningState extends State<Evening> {
  getItemsFromDb() async {
    int num = await getCount(widget.table);
    setState(() {
      length = num;
    });
  }

  int i = 0, dataLength = 1;
  @override
  Widget build(BuildContext context) {
    getThemeH();
    theme();
    getItemsFromDb();
    Size size = MediaQuery.of(context).size;
    double w = size.width * 0.9;
    double w2 = size.width * 0.32;
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
              setState(() {
                playing = false;
              });
              player.stop();
            },
          ),
          backgroundColor: bodyColor,
          title: Txt(widget.title, textColor, FontWeight.w600, 23),
        ),
        body: FutureBuilder(
          future: retreiveItems(widget.table),
          builder: (context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snap.data.length < 1 ? 0 : 1,
                  itemBuilder: (context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: mainColor,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Txt((i + 1).toString(), Colors.white,
                              FontWeight.w600, 18),
                        ),
                        Box(snap.data[i]['ITEM'], boxColor, textColor, w,
                            () {}),
                        Box(snap.data[i]['COUNT'], mainColor, Colors.white, w,
                            () {}),
                        Row(
                          children: [
                            Box("الذكر السابق", boxColor, textColor, w2, () {
                              decrement();
                              setState(() {
                                playing = false;
                              });
                              player.stop();
                            }),
                            Box(null, mainColor, Colors.white, w / 4.5,
                                () async {
                              playing = !playing;
                              playing == false
                                  ? await player.stop()
                                  : await audioCache
                                      .play('${snap.data[i]['AUDIO']}.mp3');
                            }),
                            Box("الذكر التالي", boxColor, textColor, w2, () {
                              increment();
                              setState(() {
                                playing = false;
                              });
                              player.stop();
                            }),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    );
                  });
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: mainColor,
          onPressed: () {
            showDialog(context: context, builder: (context) => Dialog());
          },
        ),
      ),
    );
  }

  Widget Box(String text, Color boxcolor, Color txtcolor, double width,
      Function press) {
    return Container(
      width: width,
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: boxcolor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 5)]),
      child: FlatButton(
        child: text != null
            ? Txt(text, txtcolor, FontWeight.normal, 19)
            : Icon(
                playing ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
        onPressed: press,
      ),
    );
  }

  decrement() {
    setState(() {
      if (i > 0) {
        i--;
      }
    });
    print(i);
  }

  increment() {
    setState(() {
      if (i < length - 1) {
        i++;
      }
    });
    print(i);
  }

  Widget Dialog() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: bodyColor.withOpacity(0.9),
        title: Txt('اضافة ذكر جديد', textColor, FontWeight.w500, 19),
        content: Column(
          children: [
            Input(100, 'ادخل الذكر', (val) {
              setState(() {
                item = val;
              });
            }),
            Input(100, 'ادخل عدد التكرار', (val) {
              setState(() {
                count = val;
              });
            }),
            Input(100, 'ادخل عدد التكرار', (val) {
              setState(() {
                audio = val;
              });
            }),
          ],
        ),
        actions: [
          FlatButton(
            child: Txt('الغاء', mainColor, FontWeight.normal, 19),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Txt('تاكيد', mainColor, FontWeight.normal, 19),
            onPressed: () {
              item != "" && count != "" && audio != ""
                  ? insert(widget.table, item, count, audio)
                  : print("null");
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
