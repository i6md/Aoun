import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/models/user/ads_model.dart';

import '../post/post_details.dart';
class EventsScreen extends StatelessWidget {
  List<AdsModel> ads = [
    AdsModel(
      adName: "Summer Sale",
      adResourceType: "Image",
      adDate: "2024-03-10",
      adPlace: "Online",
    ),
    AdsModel(
      adName: "Tech Expo",
      adResourceType: "Video",
      adDate: "2024-03-15",
      adPlace: "Convention Center",
    ),
    AdsModel(
      adName: "Flash Deal",
      adResourceType: "Banner",
      adDate: "2024-03-18",
      adPlace: "Shopping Mall",
    ),
    AdsModel(
      adName: "Fitness Challenge",
      adResourceType: "Image",
      adDate: "2024-03-20",
      adPlace: "Gym",
    ),
    AdsModel(
      adName: "Food Festival",
      adResourceType: "Video",
      adDate: "2024-03-25",
      adPlace: "City Park",
    ),
    AdsModel(
      adName: "Travel Discounts",
      adResourceType: "Banner",
      adDate: "2024-03-28",
      adPlace: "Travel Agency",
    ),
    AdsModel(
      adName: "Gaming Tournament",
      adResourceType: "Image",
      adDate: "2024-04-02",
      adPlace: "Esports Arena",
    ),
    AdsModel(
      adName: "Fashion Show",
      adResourceType: "Video",
      adDate: "2024-04-05",
      adPlace: "Fashion District",
    ),
    AdsModel(
      adName: "Home Decor Expo",
      adResourceType: "Banner",
      adDate: "2024-04-10",
      adPlace: "Exhibition Hall",
    ),
    AdsModel(
      adName: "Health and Wellness Fair",
      adResourceType: "Image",
      adDate: "2024-04-15",
      adPlace: "Community Center",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.only(top: 9),
        itemBuilder: (context,index)=> buildListItem(
            adName: ads[index].adName,
            adResourceType: ads[index].adResourceType,
            adDate: ads[index].adDate,
            adPlace: ads[index].adPlace,
            onTapp: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PostDetalis(ads[index].adName, ads[index].adResourceType, ads[index].adDate, ads[index].adPlace)));
            }
        ),
        separatorBuilder: (context,index)=>
            Padding(
              padding: const EdgeInsetsDirectional.only(start:5.0, top: 8.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
        itemCount: ads.length
    );

  }

}