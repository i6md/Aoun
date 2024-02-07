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
  TextInputType? type,
  void Function(String?)? onSubmit,
  required String? Function(String?)? validate,
  required String label,
  double? height,
  TextInputAction? action,

  void Function(String?)? onChange,
  IconData? prefix,
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
  style: TextStyle(height: height ?? 2),
  keyboardType: type,
  textInputAction: action,
  obscureText: secureText,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
);

Widget buildListItem({
  required String adName,
  required String adDescription,
  required String adDate,
})=> Row(
  children: [
    CircleAvatar(
      radius: 32,
      backgroundImage: NetworkImage('https://cdn.dribbble.com/users/60729/screenshots/3717055/media/d1a7ac75a5a9720fa0b924168e2be0b8.gif'),
    ),
    Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: 5.0,
        end: 5.0,
      ),
    ),
    SizedBox(width: 18.0,),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(adName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 7.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text(adDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0
                ),
                child: Container(
                  width: 7.0,
                  height: 7.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle
                  ),
                ),
              ),
              Text(
                  adDate
              )

            ],
          )
        ],
      ),
    )

  ],
);


