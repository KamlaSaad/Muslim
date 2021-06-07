import 'package:flutter/material.dart';
import 'theme.dart';
Widget Input(double h,String hint,Function save){
  return SizedBox(width: 290,height: h,
    child: TextFormField(keyboardType: TextInputType.multiline,
      style: TextStyle(color: textColor, fontSize: 20),
      decoration: InputDecoration(fillColor: bodyColor.withOpacity(.9),filled: true,
        hintText: hint,
        hintStyle: TextStyle(color: textColor,fontSize: 19),
        contentPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 6),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: mainColor,width: 2)),
      ),
      onChanged: save,
    ),
  );
}
Widget ButtonContainer(String buttonTxt,Function press,Color btnColor){
  return Container(
    width: 340,
    height: 44,
    decoration: BoxDecoration(color: mainColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 12)]),
    child: FlatButton(
        child: Text(buttonTxt, style: TextStyle(color: Colors.white, fontSize: 20),),
        onPressed: press),
  );
}
Widget FlatBtn(String txt1,String txt2,Function route){
  return FlatButton(
    color: Colors.transparent,
    child: RichText(text: TextSpan(children: [
      TextSpan(text: txt1,style: TextStyle(color: textColor,fontSize: 18)),
      TextSpan(text: txt2,style: TextStyle(color: mainColor,fontSize: 20))
    ]),),
    onPressed: route
  );
}