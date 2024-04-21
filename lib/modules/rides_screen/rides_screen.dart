import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/models/user/ads_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../post/post_details.dart';
class RidesScreen extends StatelessWidget {
  //'KFUPM to Airport', 'Airport to KFUPM', 'Riyadh to KFUPM', 'KFUPM to Riyadh'
  List<AdsModel> ads = [
    AdsModel(
      adName: "Summer Sale",
      adResourceType: "KFUPM to Airport",
      adDate: "2024-03-10",
      adPlace: "Online",
    ),
    AdsModel(
      adName: "Tech Expo",
      adResourceType: "Airport to KFUPM",
      adDate: "2024-03-15",
      adPlace: "Convention Center",
    ),
    AdsModel(
      adName: "Flash Deal",
      adResourceType: "Riyadh to KFUPM",
      adDate: "2024-03-18",
      adPlace: "Shopping Mall",
    ),
    AdsModel(
      adName: "Fitness Challenge",
      adResourceType: "KFUPM to Riyadh",
      adDate: "2024-03-20",
      adPlace: "Gym",
    ),
    AdsModel(
      adName: "Food Festival",
      adResourceType: "KFUPM to Airport",
      adDate: "2024-03-25",
      adPlace: "City Park",
    ),
    AdsModel(
      adName: "Travel Discounts",
      adResourceType: "Airport to KFUPM",
      adDate: "2024-03-28",
      adPlace: "Travel Agency",
    ),
    AdsModel(
      adName: "Gaming Tournament",
      adResourceType: "Riyadh to KFUPM",
      adDate: "2024-04-02",
      adPlace: "Esports Arena",
    ),
    AdsModel(
      adName: "Fashion Show",
      adResourceType: "KFUPM to Riyadh",
      adDate: "2024-04-05",
      adPlace: "Fashion District",
    ),
  ];
  void applyFilters(List<String> filters) {
    List<AdsModel> filteredAds = filters.isNotEmpty
        ? ads.where((ad) => filters.contains(ad.adResourceType)).toList()
        : ads;
    // Now use filteredAds to update the UI
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        List<String> filters;
        if (state is SearchResultsUpdatedState) {
          filters = state.results;
        } else {
          filters = HomeCubit.get(context).filters;
        }
        List<AdsModel> filteredAds = filters.isNotEmpty
            ? ads.where((ad) => filters.contains(ad.adResourceType)).toList()
            : ads;
        return ListView.separated(
            padding: EdgeInsets.only(top: 9),
            itemBuilder: (context, index) => buildListItem(
                adName: filteredAds[index].adName,
                adResourceType: filteredAds[index].adResourceType,
                adDate: filteredAds[index].adDate,
                adPlace: filteredAds[index].adPlace,
                onTapp: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostDetalis(
                              filteredAds[index].adName,
                              filteredAds[index].adResourceType,
                              filteredAds[index].adDate,
                              filteredAds[index].adPlace)));
                }),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 5.0, top: 8.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            itemCount: filteredAds.length);
      },
    );
  }

}