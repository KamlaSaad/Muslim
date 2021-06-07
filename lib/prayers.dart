import 'package:flutter/material.dart';
import 'dbHelper.dart';
import 'text.dart';
import 'input.dart';
import 'theme.dart';

class Prayers extends StatefulWidget {
  @override
  _PrayersState createState() => _PrayersState();
}

class _PrayersState extends State<Prayers> {
  String item;
  List list = [];
  getItemsFromDb() async {
    List Items = await getId('kox123');
    setState(() {
      list = Items;
    });
  }

  @override
  Widget build(BuildContext context) {
    theme();
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
          title: Txt("ادعية", textColor, FontWeight.w500, 24),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 6),
          child: Body(),
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

  Widget Body() {
    return FutureBuilder(
      future: retreiveItems("PRAYERS"),
      builder: (context, AsyncSnapshot snap) {
        if (!snap.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, int index) {
                return Container(
                  color: boxColor,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Container(
                        width: 28,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Txt((snap.data[index]['ID']).toString(),
                              Colors.white, FontWeight.normal, 20),
                        )),
                    title: RichText(
                      text: TextSpan(
                          text: snap.data[index]['ITEM'].toString(),
                          style: TextStyle(fontSize: 24, color: textColor)),
                    ),
                  ),
                );
              });
        }
      },
    );
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
              addPrayers(item);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
