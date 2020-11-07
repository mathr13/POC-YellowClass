import 'package:flutter/material.dart';
import 'constants.dart';

Color parseColor(String colourHexCode) {
  String hex = colourHexCode.replaceAll("#", "");
  if (hex.isEmpty) hex = "ffffff";
  if (hex.length == 3) {
    hex =
        '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
  }
  Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
  return col;
}

BoxDecoration genericTextFieldDecoration({Color colour}) {
  if (colour == null) colour = parseColor(BORDERCOLOUR);
  return BoxDecoration(
    border: Border.all(width: 1.75, color: colour),
    borderRadius: BorderRadius.all(Radius.circular(GENERICBORDERRADIUS)),
    color: parseColor(FILLCOLOUR),
    boxShadow: [
      BoxShadow(
        color: parseColor(FILLCOLOUR),
        blurRadius: 0.25,
        spreadRadius: 0.0,
        offset: Offset(0.0, 1),
      )
    ],
  );
}

BoxDecoration genericButtonDecoration({double radius, Color colour}) {
  if (colour == null) colour = parseColor("#29467F");
  if (radius == null) radius = GENERICBORDERRADIUS;
  return BoxDecoration(
    border: Border.all(width: 1, color: parseColor(BORDERCOLOUR)),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    color: colour,
  );
}

TextStyle genericTextDecoration(
    {Color colour,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration textDecoration}) {
  if (fontSize == null) fontSize = 20;
  if (textDecoration == null) textDecoration = TextDecoration.none;
  if (fontWeight == null) fontWeight = FontWeight.bold;
  if (colour == null) colour = parseColor(PRIMARYCOLOUR);
  return TextStyle(
      fontFamily: "Helvetiva Neue",
      fontWeight: fontWeight,
      decoration: textDecoration,
      fontSize: fontSize,
      color: colour);
}

PreferredSizeWidget genericAppBar({double height}) {
  if (height == null) height = 7;
  return PreferredSize(
    preferredSize: Size.fromHeight(height),
    child: AppBar(
      brightness: Brightness.dark,
      backgroundColor: parseColor(FILLCOLOUR),
      elevation: 0,
    ),
  );
}

BoxDecoration genericCustomIconView({Color colour}) {
  if (colour == null) colour = parseColor(BORDERCOLOUR);
  return BoxDecoration(
    border: Border.all(width: 1, color: colour),
    borderRadius: BorderRadius.all(Radius.circular(40)),
  );
}

/*
Padding(
  padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
  child: Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 35,
          width: 35,
          decoration: genericCustomIconView(
              colour: parseColor(EDITCOLOUR)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
            child: Image.asset("Assets/Images/edit.png"),
          ),
        ),
        SizedBox(
          width: 7,
        ),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(
                width: 4, color: parseColor(BORDERCOLOUR)),
            color: parseColor(PRIMARYCOLOUR),
            borderRadius: BorderRadius.all(Radius.circular(60)),
          ),
        ),
        SizedBox(
          width: 7,
        ),
        Container(
          height: 35,
          width: 35,
          decoration: genericCustomIconView(
              colour: parseColor(DELETECOLOUR)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
            child: Image.asset("Assets/Images/delete.png"),
          ),
        ),
      ],
    ),
  ),
),
*/
