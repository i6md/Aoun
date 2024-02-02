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


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String?)? onSubmit,
  required String? Function(String?)? validate,
  required String label,
  void Function(String?)? onChange,
  required IconData prefix,
  bool secureText = false,
  IconData? suffix,
  VoidCallback? suffixPressed,



})=>TextFormField(
  controller: controller,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon:suffix != null ? IconButton(
        icon: Icon(suffix),
        onPressed: suffixPressed,
    ) : null,
    border: OutlineInputBorder(),
  ),
  keyboardType: type,
  obscureText: secureText,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
);
