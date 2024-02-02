import 'package:flutter/material.dart';

Widget defaultButton({
  double width= double.infinity,
  Color background=Colors.blue,
  required VoidCallback function,
  required String text,
  required bool IsUpperCase,
})=> Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: background,
  ),
  height: 50.0,
  width: width,

  child: MaterialButton(
    onPressed: function,
    child: Text(
      IsUpperCase? text.toUpperCase(): text,
      style: const TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    ),
  ),
);