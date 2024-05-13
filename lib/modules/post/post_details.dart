import 'dart:convert';
import 'package:aoun_app/layout/home_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:aoun_app/modules/rate/rate_post.dart';
import 'package:aoun_app/modules/report/report_post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user/user_model.dart';
import '../login/auth_service.dart';

class PostDetalis extends StatefulWidget {
  const PostDetalis(this.ad, {super.key});

  // final String? adId;
  // final String? adName;
  // final dynamic? adResourceType;
  // final DateTime? adDate;
  // final String? adPlace;
  // final String? adDescription;
  // final String? adtype;
  // final List<dynamic>? adPictures;
  // final DateTime? start_date;
  // final DateTime? end_date;
  // final String? start_location;
  // final String? end_location;
  // final String? owner_id;
  // final int? joined;
  // final bool? expired;
  // final int? total_seats;
  // final DateTime? created_at;
  // final int? participants;
  final dynamic ad;
  @override
  State<PostDetalis> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetalis> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  var follow = 'Follow';
  var heart = Icons.favorite_border_rounded;
  String formatPhoneNumber(String phoneNumber) {
    // Remove any leading '+' or '0'
    String formattedNumber = phoneNumber.replaceFirst(RegExp(r'^\+?0?'), '');

    // Ensure the number starts with '9665'
    if (!formattedNumber.startsWith('9665')) {
      formattedNumber = '9665' + formattedNumber;
    }

    // Add the leading '+'
    formattedNumber = '+' + formattedNumber;

    return formattedNumber;
  }

  void sendWhatsappM() {
    String url =
        "whatsapp://send?phone=${formatPhoneNumber(widget.ad.owner_phone)}";
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF0F1113),
            size: 32,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.more_vert,
          //   ),
          // ),
          PopupMenuButton(
            itemBuilder: (context) => [
              // PopupMenuItem 1
              const PopupMenuItem(
                value: 1,
                // row with 2 children
                child: Row(
                  children: [
                    Icon(Icons.report_problem_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Report Post")
                  ],
                ),
              ),
              // PopupMenuItem 2
            ],
            offset: const Offset(0, 50),
            color: Colors.white,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportPostScreen()));
                // if value 2 show dialog
              } else if (value == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RatePost()));
              }
            },
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      widget.ad.adName!,
                      style: GoogleFonts.readexPro(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional(1, 0),
                      child: IconButton(
                        color: Colors.green,
                        onPressed: () {
                          sendWhatsappM();
                        },
                        icon: Icon(
                          Icons.chat,
                        ),
                        style: ButtonStyle(
                            iconSize: MaterialStatePropertyAll(32),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(1, 0),
                    child: IconButton(
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          if (heart == Icons.favorite_rounded) {
                            heart = Icons.favorite_border_rounded;
                          } else {
                            heart = Icons.favorite_rounded;
                          }
                        });
                      },
                      icon: Icon(
                        heart,
                      ),
                      style: ButtonStyle(
                          iconSize: MaterialStatePropertyAll(32),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                widget.ad.adtype!,
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (widget.ad.adtype != "Ride")
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 20,
                      ),
                    if (widget.ad.adtype != "Ride")
                      Text(
                        widget.ad.building ?? "",
                        style: GoogleFonts.readexPro(
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.timer_sharp,
                      color: Colors.black,
                      size: 20,
                    ),
                    if (widget.ad.adtype == 'Item')
                      Text(
                        timeDifference(widget.ad.adDate)!,
                        style: GoogleFonts.readexPro(
                          fontSize: 12,
                        ),
                      ),
                    if (widget.ad.adtype == 'Events')
                      Text(
                        timeDifference(widget.ad.created_at)!,
                        style: GoogleFonts.readexPro(
                          fontSize: 12,
                        ),
                      ),
                    if (widget.ad.adtype == 'Ride')
                      Text(
                        timeDifference(widget.ad.created_at)!,
                        style: GoogleFonts.readexPro(
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/Aoun_LOGOBB.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          '${widget.ad.owner_name}',
                          style: GoogleFonts.readexPro(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.phone,
                              color: Colors.black,
                              size: 24,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                              child: Text(
                                '${formatPhoneNumber(widget.ad.owner_phone)}',
                                style: GoogleFonts.readexPro(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
            if (widget.ad.adtype == 'Ride')
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Text(
                    'Details',
                    style: GoogleFonts.readexPro(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            if (widget.ad.adtype == 'Ride')
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Text(
                  'From ${widget.ad.start_loc} to ${widget.ad.end_loc}.\nAt ${DateFormat('yyyy-MM-dd HH:mm').format(widget.ad.start_date_time)}.\n${widget.ad.total_seats} seats available.\n${widget.ad.joined} joined.',
                  style: GoogleFonts.readexPro(
                    fontSize: 14,
                  ),
                ),
              ),
            if (widget.ad.adtype == 'Event')
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Text(
                    'Details',
                    style: GoogleFonts.readexPro(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            if (widget.ad.adtype == 'Event')
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Text(
                  'In Building ${widget.ad.building}, room number ${widget.ad.room}.\nFrom ${DateFormat('yyyy-MM-dd HH:mm').format(widget.ad.start_date_time)} to ${DateFormat('yyyy-MM-dd HH:mm').format(widget.ad.end_date_time)}.\n${widget.ad.participants_number} participants needed.\n${widget.ad.joined} joined.',
                  style: GoogleFonts.readexPro(
                    fontSize: 14,
                  ),
                ),
              ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: Text(
                  'Description',
                  style: GoogleFonts.readexPro(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                widget.ad.description!,
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                ),
              ),
            ),
            if (widget.ad.adtype != 'Ride')
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 10),
                  child: Text(
                    'Pictures',
                    style: GoogleFonts.readexPro(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            if (widget.ad.adtype != 'Ride')
              Expanded(
                  child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                scrollDirection: Axis.vertical,
                itemCount:
                    widget.ad.pictures?.length ?? 0, // Use null-aware operator
                itemBuilder: (context, index) {
                  if (widget.ad.pictures == null) {
                    // Render a blank grid cell
                    return Container(); // You can customize this to show any placeholder
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.ad.pictures![index],
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              )),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: defaultButton(
                      function: () {
                        if (widget.ad.adtype == 'Event') {
                          print(widget.ad.event_id!);
                          joinEvent(widget.ad.event_id!);
                        } else if (widget.ad.adtype == 'Item') {
                          orderItem(widget.ad.adId!);
                        } else if (widget.ad.adtype == 'Ride') {
                          print(widget.ad.ride_id);
                          joinRide(widget.ad.ride_id!);
                        }
                      },
                      text: 'Reserve',
                      IsUpperCase: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> orderItem(String itemId) async {
    const String apiUrl =
        'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/order_item';
    AuthService authService = AuthService();
    var token = await authService.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'item_id': itemId,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: requestHeaders,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print('Item ordered successfully: $message');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item ordered successfully!'),
        ),
      );

      // Navigate to items screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      final errorResponse = json.decode(response.body);
      final error = errorResponse['error'];
      print('Error ordering item: $error');
      if (error == 'You cannot order your own item') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You cannot order your own item!'),
          ),
        );
      }
    }
  }

  Future<void> joinEvent(String eventId) async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    const String apiUrl =
        'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/join_event';
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'event_id': eventId,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: requestHeaders,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event joined successfully: $message'),
        ),
      );
      // print('Event joined successfully: $message');
    } else {
      final errorResponse = json.decode(response.body);
      final error = errorResponse['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
        ),
      );
    }
  }

  Future<void> joinRide(String rideId) async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    const String apiUrl =
        'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/join_ride';
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'ride_id': rideId,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: requestHeaders,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Rides joined successfully: $message'),
      ));
    } else {
      final errorResponse = json.decode(response.body);
      final error = errorResponse['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
        ),
      );
    }
  }
}

Future<List<UserModel>> fetchUserInfo() async {
  AuthService authService = AuthService();
  var token = await authService.getToken();
  final requestHeaders = {
    "Authorization": "Bearer $token",
  };

  final response = await http.get(
      Uri.parse(
          'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_user_info'),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var user = jsonResponse['user'] as Map<String, dynamic>? ?? {};
    // print(jsonResponse); // Logs the whole response
    // print("name: ${user['name']}"); // Correctly access the 'name'
    // print("building: ${user['building']}"); // Correctly access the 'building'

    // var body = jsonDecode(jsonResponse['body'] as String) as Map<String, dynamic>;
    //
    // print("user info is here");
    // print(user);
    // print(body);
    return [UserModel.fromJson(user)];

    // Assuming UserModel.fromJson can parse the user object directly
  } else {
    print(
        'Error viewing userinfo. Status code: ${response.statusCode}, Response: ${response.body}');
    throw Exception('Failed to load user info: ${response.body}');
  }
}

//https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/join_event
