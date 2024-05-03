import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

Widget defaultButton({
  double width= double.infinity,
Color background = const Color.fromARGB(255, 3, 50, 71),
  required VoidCallback? function,
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
      IsUpperCase ? text.toUpperCase() : text,
      style: GoogleFonts.readexPro(
        fontSize: 15.0,
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
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10)
    ),
  ),
  style: TextStyle(height: height ?? 2),
  keyboardType: type,
  textInputAction: action,
  obscureText: secureText,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
);

Widget text_field({
  required TextEditingController? subjectController,
  String? label,
}) =>
    Align(
      alignment: AlignmentDirectional(-1, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 20, 0),
        child: Container(
          width: double.infinity,
          child: TextFormField(
            controller: subjectController,

            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.readexPro(fontSize: 12),
              hintStyle: GoogleFonts.readexPro(fontSize: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 224, 227, 231),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 224, 227, 231),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
            ),
            // style: FlutterFlowTheme.of(context).bodyMedium,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the subject';
              }
              return null;
            },
            maxLines: null,
          ),
        ),
      ),
    );

Widget notificationRequest(
    {required String name,
      required String place,
      required String rating}) =>
    Container(
      width: double.infinity,
      height: 100,
      // decoration: BoxDecoration(
      //   color: FlutterFlowTheme.of(context).secondaryBackground,
      // ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Container(
                width: 70,
                height: 70,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://picsum.photos/seed/413/600',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.readexPro(),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 70, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.grey,
                          size: 24,
                        ),
                        Text(
                          place,
                          style: GoogleFonts.readexPro(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 75, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber[300],
                          size: 24,
                        ),
                        Text(
                          rating,
                          style: GoogleFonts.readexPro(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // color: FlutterFlowTheme.of(context)
                  //     .secondaryBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFFC0202),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.clear_rounded,
                  color: Color(0xFFFC0202),
                  size: 24,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // color: FlutterFlowTheme.of(context)
                  //     .secondaryBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 57, 210, 192),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Color.fromARGB(255, 57, 210, 192),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget notificationOffer(
    {required String title,
      required String name,
      required String place,
      required String rating}) =>
    Container(
        width: double.infinity,
        height: 105,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    'https://picsum.photos/seed/413/600',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.readexPro(fontSize: 22),
                    ),
                    Text(
                      name,
                      style: GoogleFonts.readexPro(fontSize: 12),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber[300],
                          size: 14,
                        ),
                        Text(
                          rating,
                          style: GoogleFonts.readexPro(fontSize: 12),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                        ),
                        Text(
                          place,
                          style: GoogleFonts.readexPro(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '2 min',
                    style: GoogleFonts.readexPro(fontSize: 12),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ],
              )
            ])));

Widget reportText({required String label}) => Align(
  alignment: Alignment.centerLeft,
  child: Text(
    label,
    style: GoogleFonts.readexPro(
      color: Colors.black,
      fontSize: 15,
    ),
  ),
);

Widget buildListItem({
  required String adName,
  required String adResourceType,
  required String adDate,
  required String adPlace,
  void Function()? onTapp,
  void Function()? onDelete,
  bool showAdminButtons=false,

})=> Padding(
  padding: const EdgeInsets.all(8.0),
  child: InkWell(
    onTap: onTapp,
    child: Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002) // This value controls the perspective effect
        ..rotateX(0.01) // These values control the rotation
        ..rotateY(0.01),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage( image:
              NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/AcetoFive.JPG/330px-AcetoFive.JPG'
              ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
          borderRadius: BorderRadius.circular(9.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15.0,
                spreadRadius: 5.0,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (showAdminButtons) // replace 'showDeleteButton' with your actual condition
                        IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: (){
                          if (onDelete != null) {
                            onDelete();
                          }

                        },
                        ),
                      if (showAdminButtons) // replace 'showEditButton' with your actual condition
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: (){
                            if (onDelete != null) {
                              onDelete();
                            }

                          },
                        ),

                      IconButton(
                        onPressed: () {
                          // Add functionality here or replace with a non-interactive widget
                        },
                        icon: Icon(Icons.thumb_up_alt_rounded,
                        color: Colors.white,),
                      ),
                      SizedBox(
                          height: (showAdminButtons) ? 45 : 75,
                      ),
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage('https://aoun-item-pictures.s3.eu-north-1.amazonaws.com/i_769af3ac-d_1.jpg'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:
                    [
                      Text(
                        adDate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),

                      SizedBox(
                        height: 75,
                      ),
                      Text(
                        adName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Turki",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${adPlace}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  ),
)


;


//Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//   child: Row(
//     children: [
//       CircleAvatar(
//         radius: 25,
//         backgroundImage: NetworkImage('https://cdn.dribbble.com/users/60729/screenshots/3717055/media/d1a7ac75a5a9720fa0b924168e2be0b8.gif'),
//       ),
//       Padding(
//         padding: const EdgeInsetsDirectional.only(
//           bottom: 5.0,
//           end: 5.0,
//         ),
//       ),
//       SizedBox(width: 18.0,),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(adName,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style:TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//             SizedBox(
//               height: 5.0,
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Resource Type: ${adResourceType}',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 15,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 3.0,
//                     ),
//
//                     Text(
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         'Resource Place: ${adPlace}'
//                     ),
//                   ],
//                 ),
//                 Column(
//                   // mainAxisSize: MainAxisSize.max,
//                   crossAxisAlignment:CrossAxisAlignment.end,
//
//                   children: [
//                     Text(
//                         adDate,
//                     ),
//                   ],
//                 ),
//               ],
//             )
//           ],
//         ),
//       )
//
//     ],
//   ),
// );
Widget buildListItem1({
  required String adName,
  required String adResourceType,
  required String adDate,
  required String adPlace,
  void Function()? onTapp,
  void Function()? onDelete,
  bool showAdminButtons=false,
}) => Padding(
  padding: const EdgeInsets.symmetric(vertical : 15.0, horizontal: 15.0),
  child: Transform(
    alignment: FractionalOffset.center,
    transform: Matrix4.identity()
      ..setEntry(3, 2, 0.045) // This value controls the perspective effect
      ..rotateX(-0.015) // These values control the rotation
      ..rotateY(0),
    child: Container(

      decoration: BoxDecoration(
        image: DecorationImage( image:
        NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/AcetoFive.JPG/330px-AcetoFive.JPG'
        ),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcATop,
          ),
        ),
        borderRadius: BorderRadius.circular(9.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 19,
            spreadRadius: 5.0,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Card(
        color: Colors.transparent, // make the card transparent
        elevation: 9.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19.0),
        ),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19.0),
          ),
          title: Text(adName ,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(adDate,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
          children: <Widget>[ Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showAdminButtons) // replace 'showDeleteButton' with your actual condition
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: (){
                        if (onDelete != null) {
                          onDelete();
                        }

                      },
                    ),
                  if (showAdminButtons) // replace 'showEditButton' with your actual condition
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: (){
                        if (onDelete != null) {
                          onDelete();
                        }

                      },
                    ),

                  IconButton(
                    onPressed: () {
                      // Add functionality here or replace with a non-interactive widget
                    },
                    icon: Icon(Icons.thumb_up_alt_rounded,
                      color: Colors.white,),
                  ),
                  SizedBox(
                    height: (showAdminButtons) ? 25 : 50,
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage('https://aoun-item-pictures.s3.eu-north-1.amazonaws.com/i_769af3ac-d_1.jpg'),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:
                [
                  Text(
                    "Owner name : Turki",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: (showAdminButtons) ? 35 : 65,
                  ),
                  Text(
                    'Place: ${adPlace}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    'Type: ${adResourceType}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ],
              )
            ],
          ),
          ],
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.white,),
            onPressed: onTapp,
          ),
        ),
      ),
    ),
  ),
);

Widget buildListItem2({
  required String adName,
  required String adResourceType,
  required String adDate,
  required String adPlace,
  required String photoUrl,
  void Function()? onTapp,
  void Function()? onDelete,
  bool showAdminButtons=false,
}) {
  // Define a state variable to control the scale of the card
  bool isPressed = false;

  return GestureDetector(
    // When the card is pressed, set isPressed to true to increase the scale
    onTap: onTapp,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical : 15.0, horizontal: 20.0),
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.1) // This value controls the perspective effect
          ..rotateX(-0.0) // These values control the rotation
          ..rotateY(0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage( image:
            NetworkImage(
                photoUrl
            ),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcATop,
              ),
            ),
            borderRadius: BorderRadius.circular(9.0),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.5),
            //     blurRadius: 19,
            //     spreadRadius: 5.0,
            //     offset: Offset(5, 5),
            //   ),
            // ],
          ),
          child: Card(
            color: Colors.transparent, // make the card transparent
            elevation: 9.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        adResourceType,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        adDate,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        adPlace,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                if (showAdminButtons)
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Edit logic here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
Widget buildListItem3({
  required String adName,
  required String adResourceType,
  required String adDate,
  required String adPlace,
  required String photoUrl,
  void Function()? onTapp,
  void Function()? onDelete,
  bool showAdminButtons=false,
}) {
  // Define a state variable to control the scale of the card
  bool isPressed = false;

  return GestureDetector(
    // When the card is pressed, set isPressed to true to increase the scale
    onTap: onTapp,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical : 10.0, horizontal: 10),
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.1) // This value controls the perspective effect
          ..rotateX(-0.0000) // These values control the rotation
          ..rotateY(0),
        child: Container(
          width: 150,
          height: 10,
          decoration: BoxDecoration(
            image: DecorationImage( image:
            NetworkImage(
                photoUrl
            ),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcATop,
              ),
            ),
            borderRadius: BorderRadius.circular(9.0),
          ),
          child: Card(
            color: Colors.transparent, // make the card transparent
            elevation: 9.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        adPlace,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    ),
  );
}