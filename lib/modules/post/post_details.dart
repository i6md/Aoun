import 'package:aoun_app/modules/rate/rate_post.dart';
import 'package:aoun_app/modules/report/report_post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetalis extends StatefulWidget {
  const PostDetalis(this.adName, this.adResourceType, this.adDate, this.adPlace, {super.key});

  final String adName;
  final String adResourceType;
  final String adDate;
  final String adPlace;

  @override
  State<PostDetalis> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetalis> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  var follow = 'Follow';
  var heart = Icons.favorite_border_rounded;
  void sendWhatsappM(){
    String url = "whatsapp://send?+966555555555";
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
              const PopupMenuItem(
                value: 2,
                // row with two children
                child: Row(
                  children: [
                    Icon(Icons.star_border_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Rate")
                  ],
                ),
              ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RatePost()));
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
                  Text(
                    widget.adName,
                    style: GoogleFonts.readexPro(
                      fontSize: 25,
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
                            backgroundColor: MaterialStateProperty.all(Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(1, 0),
                    child: IconButton(
                      color: Colors.red,

                      onPressed: () {setState(() {
                        if (heart == Icons.favorite_rounded) {
                          heart = Icons.favorite_border_rounded;
                        }
                        else {
                          heart = Icons.favorite_rounded;
                        }

                      });},
                      icon: Icon(
                        heart,
                      ),
                      style: ButtonStyle(
                          iconSize: MaterialStatePropertyAll(32),
                          backgroundColor: MaterialStateProperty.all(Colors.white)
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                widget.adResourceType,
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
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      widget.adPlace,
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
                    Text(
                      widget.adDate,
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
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Meshal Aldajani',
                          style: GoogleFonts.readexPro(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_sharp,
                              color: Colors.black,
                              size: 24,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: Text(
                                '4.6',
                                style: GoogleFonts.readexPro(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (follow == 'Follow') {
                        setState(() {
                          follow = 'Unfollow';
                        });
                      } else {
                        setState(() {
                          follow = 'Follow';
                        });
                      }
                    },
                    child: Text(
                      follow,
                    ),
                    style: ElevatedButton.styleFrom(
                      // height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      // iconPadding:
                      //     EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      textStyle: GoogleFonts.readexPro(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
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
                'lhdsflhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh.',
                style: GoogleFonts.readexPro(
                  fontSize: 14,
                ),
              ),
            ),
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
            Expanded(
              child: GridView(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                scrollDirection: Axis.vertical,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'assets/images/Aoun_LOGOWB.png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/Aoun_LOGOBB.png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: defaultButton(function: () {}, text: 'Reserve', IsUpperCase: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
