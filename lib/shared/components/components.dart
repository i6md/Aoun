import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = const Color.fromARGB(255, 3, 50, 71),
  required VoidCallback? function,
  required String text,
  required bool IsUpperCase,
}) =>
    Container(
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
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                child: IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Color(0xFFFC0202),
                    size: 24,
                  ),
                  onPressed: () {},
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
                    color: Color.fromARGB(255, 3, 50, 71),
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.check_rounded,
                    color: Color.fromARGB(255, 3, 50, 71),
                    size: 24,
                  ),
                  onPressed: () {},
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
  required String? adName,
  required String? adResourceType,
  required DateTime? adDate,
  required String? adPlace,
  void Function()? onTapp,
  void Function()? onDelete,
  bool showAdminButtons = false,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTapp,
        child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(
                3, 2, 0.002) // This value controls the perspective effect
            ..rotateX(0.01) // These values control the rotation
            ..rotateY(0.01),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/AcetoFive.JPG/330px-AcetoFive.JPG'),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
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
                              onPressed: () {
                                if (onDelete != null) {
                                  onDelete();
                                }
                              },
                            ),
                          if (showAdminButtons) // replace 'showEditButton' with your actual condition
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                if (onDelete != null) {
                                  onDelete();
                                }
                              },
                            ),
                          IconButton(
                            onPressed: () {
                              // Add functionality here or replace with a non-interactive widget
                            },
                            icon: Icon(
                              Icons.thumb_up_alt_rounded,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: (showAdminButtons) ? 45 : 75,
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: //Image.asset('Aoun_LOGOBB.png');
                                NetworkImage(
                                    'https://aoun-item-pictures.s3.eu-north-1.amazonaws.com/i_102df067-f_1.jpg'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            timeDifference(adDate)!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(
                            height: 75,
                          ),
                          Text(
                            adName!,
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
                                color: Colors.white),
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
    );
String? timeDifference(DateTime? adDate) {
  final Duration timeDifference = DateTime.now().difference(adDate!);
  final String timeDiffString;
  if (timeDifference.inMinutes < 60) {
    if (timeDifference.inMinutes == 1) {
      timeDiffString = "${timeDifference.inMinutes} minute ago";
    } else {
      timeDiffString = "${timeDifference.inMinutes} minutes ago";
    }
  } else if (timeDifference.inHours < 24) {
    if (timeDifference.inHours == 1) {
      timeDiffString = "${timeDifference.inHours} hour ago";
    } else {
      timeDiffString = "${timeDifference.inHours} hours ago";
    }
  } else {
    if (timeDifference.inDays == 1) {
      timeDiffString = "${timeDifference.inDays} day ago";
    } else {
      timeDiffString = "${timeDifference.inDays} days ago";
    }
  }
  return timeDiffString;
}




Widget buildListItem2({
  required String? adName,
  required dynamic? adResourceType,
  String? category,
  required DateTime? adDate,
  required String? adPlace,
  void Function()? onTapp,
  void Function()? onDelete,
  List<dynamic>? adImages,
  bool showAdminButtons = false,

  required String? photoUrl,
}) {
  // Define a state variable to control the scale of the card
  bool isPressed = false;

  return GestureDetector(
    // When the card is pressed, set isPressed to true to increase the scale
    onTap: onTapp,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.1) // This value controls the perspective effect
          ..rotateX(-0.0) // These values control the rotation
          ..rotateY(0),
        child: Container(
          decoration: BoxDecoration(
            image: adImages != null
                ? DecorationImage(
                    image: NetworkImage(adImages.first),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.srcATop,
                    ),
                  )
                : null, // Set to null when adImages is null
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
                        adName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        adResourceType!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                      Text(
                        timeDifference(adDate)!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                      Text(
                        adPlace?.isNotEmpty ?? false
                            ? 'Building: $adPlace'
                            : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.white),
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


Widget buildListEvent({
  DateTime? created_at,
  String? event_type,
  String? owner_id,
  required String? title,
  String? description,
  void Function()? onDelete,
  bool showAdminButtons = false,
  DateTime? start_date_time,
  DateTime? end_date_time,
  String? building,
  String? room,
  int? participants_number,
  int? joined,
  bool? expired,
  required List<dynamic>? pictures,
  void Function()? onTapp,
  required String? photoUrl,
}) {
  // Define a state variable to control the scale of the card
  bool isPressed = false;

  return GestureDetector(
    // When the card is pressed, set isPressed to true to increase the scale
    onTap: onTapp,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.1) // This value controls the perspective effect
          ..rotateX(-0.0) // These values control the rotation
          ..rotateY(0),
        child: Container(
          decoration: BoxDecoration(
            image: pictures != null ? DecorationImage(
              image: NetworkImage(pictures.first),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcATop,
              ),
            )
                : null, // Set to null when adImages is null
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
                      Expanded(
                        child: Text(
                          title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          event_type!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          timeDifference(created_at)!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          building?.isNotEmpty ?? false
                              ? 'Building: $building'
                              : '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Participants: $joined / $participants_number',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.white),
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


Widget buildListRide({
  DateTime? created_at,
  // String? event_type,
  String? owner_id,
  required String? title,
  String? description,
  void Function()? onDelete,
  bool showAdminButtons = false,
  DateTime? start_date_time,
  String? start_loc,
  String? end_loc,
 // String? room,
  int? total_seats,
  int? joined,
  bool? expired,
  //required List<dynamic>? pictures,
  void Function()? onTapp,
  required String? photoUrl,
}) {
  // Define a state variable to control the scale of the card
  bool isPressed = false;

  return GestureDetector(
    // When the card is pressed, set isPressed to true to increase the scale
    onTap: onTapp,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.1) // This value controls the perspective effect
          ..rotateX(-0.0) // These values control the rotation
          ..rotateY(0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(photoUrl!),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcATop,
              ),
            )
                , // Set to null when adImages is null
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
                      Expanded(
                        child: Text(
                          title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'From $start_loc to $end_loc',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          timeDifference(created_at)!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Starts at: ${start_date_time!}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Travelers: $joined / $total_seats',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.white),
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
  required String? adName,
  dynamic? adResourceType,
  required DateTime? adDate,
  required String? adPlace,
  required String? photoUrl,
  List<dynamic>? adImages,
  void Function()? onTapp,
  void Function()? onDelete,
  bool showAdminButtons = false,
}) {
  // Define a state variable to control the scale of the card
  bool isPressed = false;

  return GestureDetector(
    // When the card is pressed, set isPressed to true to increase the scale
    onTap: onTapp,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
            image: adImages != null
                ? DecorationImage(
                    image: NetworkImage(adImages.first),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.srcATop,
                    ),
                  )
                : DecorationImage(
              image: NetworkImage(photoUrl!),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcATop,
              ),
            ), // Set to null when adImages is null
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
                        adName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        adPlace?.isNotEmpty ?? false
                            ? 'Building: $adPlace'
                            : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.white),
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


Widget buildListRides3({
  DateTime? created_at,
  // String? event_type,
  String? owner_id,
  required String? title,
  String? description,
  void Function()? onDelete,
  bool showAdminButtons = false,
  DateTime? start_date_time,
  String? start_loc,
  String? end_loc,
  // String? room,
  int? total_seats,
  int? joined,
  bool? expired,
  //required List<dynamic>? pictures,
  void Function()? onTapp,
  required String? photoUrl,
}) {
  // Define a state variable to control the scale of the card
  bool isPressed = false;

  return GestureDetector(
    // When the card is pressed, set isPressed to true to increase the scale
    onTap: onTapp,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
            image: DecorationImage(
              image: NetworkImage(photoUrl!),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcATop,
              ),
            ), // Set to null when adImages is null
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
                        title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'From : $start_loc to $end_loc'
                            ,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.white),
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
