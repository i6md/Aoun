import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class RatePost extends StatefulWidget {
  const RatePost({super.key});

  @override
  State<RatePost> createState() => _RatePostState();
}

class _RatePostState extends State<RatePost> {
  
  var rateIndex = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 50,
              ),
              // alignment: AlignmentDirectional(-1, 0),
              Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/Aoun_LOGOBB.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Meshal Aldajani',
                style: GoogleFonts.readexPro(fontSize: 20),
              ),
              const SizedBox(
                height: 70,
              ),

              RatingBar.builder(
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rateIndex = rating;
                  });
                },
              ),

              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: defaultButton(function: (rateIndex > 0)? (){} : null, text: 'Submit', IsUpperCase: false),
              ),
            ]),
      ),
    );
  }
}
