import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/models/user/ads_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../post/post_details.dart';
class RidesScreen extends StatelessWidget {
  //'KFUPM to Airport', 'Airport to KFUPM', 'Riyadh to KFUPM', 'KFUPM to Riyadh'
  List<AdsModel> ads = [
    AdsModel(
      adName: "KFUPM to Airport",
      adResourceType: "KFUPM to Airport",
      adDate: "2024-03-10",
      adPlace: "Online",
      photoUrl:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
    AdsModel(
      adName: "Airport to KFUPM",
      adResourceType: "Airport to KFUPM",
      adDate: "2024-03-15",
      adPlace: "Convention Center",
        photoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
    AdsModel(
      adName: "Riyadh to KFUPM",
      adResourceType: "Riyadh to KFUPM",
      adDate: "2024-03-18",
      adPlace: "Shopping Mall",
        photoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
    AdsModel(
      adName: "KFUPM to Riyadh",
      adResourceType: "KFUPM to Riyadh",
      adDate: "2024-03-20",
      adPlace: "Gym",
        photoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
    AdsModel(
      adName: "KFUPM to Airport",
      adResourceType: "KFUPM to Airport",
      adDate: "2024-03-25",
      adPlace: "City Park",
        photoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
    AdsModel(
      adName: "Airport to KFUPM",
      adResourceType: "Airport to KFUPM",
      adDate: "2024-03-28",
      adPlace: "Travel Agency",
        photoUrl:
'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
    AdsModel(
      adName: "Riyadh to KFUPM",
      adResourceType: "Riyadh to KFUPM",
      adDate: "2024-04-02",
      adPlace: "Esports Arena",
        photoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
    AdsModel(
      adName: "KFUPM to Riyadh",
      adResourceType: "KFUPM to Riyadh",
      adDate: "2024-04-05",
      adPlace: "Fashion District",
        photoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'
    ),
  ];
  void applyFilters(List<String> filters) {
    List<AdsModel> filteredAds = filters.isNotEmpty
        ? ads.where((ad) => filters.contains(ad.adResourceType)).toList()
        : ads;
    // Now use filteredAds to update the UI
  }
  @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<HomeCubit, HomeStates>(
  //     builder: (context, state) {
  //       List<String> filters;
  //       if (state is SearchResultsUpdatedState) {
  //         filters = state.results;
  //       } else {
  //         filters = HomeCubit.get(context).filters;
  //       }
  //       List<AdsModel> filteredAds = filters.isNotEmpty
  //           ? ads.where((ad) => filters.contains(ad.adResourceType)).toList()
  //           : ads;
  //       return ListView.separated(
  //           padding: EdgeInsets.only(top: 9),
  //           itemBuilder: (context, index) => buildListItem(
  //               adName: filteredAds[index].adName,
  //               adResourceType: filteredAds[index].adResourceType,
  //               adDate: filteredAds[index].adDate,
  //               adPlace: filteredAds[index].adPlace,
  //               onTapp: () {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => PostDetalis(
  //                             filteredAds[index].adName,
  //                             filteredAds[index].adResourceType,
  //                             filteredAds[index].adDate,
  //                             filteredAds[index].adPlace)));
  //               }),
  //           separatorBuilder: (context, index) => Padding(
  //             padding: const EdgeInsetsDirectional.only(start: 5.0, top: 8.0),
  //             child: Container(
  //               width: double.infinity,
  //               height: 1.0,
  //               color: Colors.grey[300],
  //             ),
  //           ),
  //           itemCount: filteredAds.length);
  //     },
  //   );
  // }
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " Newly Added Rides",
              textAlign: TextAlign.left,
              style: GoogleFonts.readexPro(
                  textStyle: TextStyle(
                    color: Colors.indigo,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,

                  )
              ),
            )
            ,
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
            Container(
              height : 90,
              child: Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal, // This makes the ListView scroll horizontally
                  itemCount: filteredAds.length,
                  itemBuilder: (context, index) {
                    return buildListItem3(
                        adName: filteredAds[index].adName,
                        adResourceType: filteredAds[index].adResourceType,
                        adDate: filteredAds[index].adDate,
                        adPlace: filteredAds[index].adPlace,
                        photoUrl: filteredAds[index].photoUrl,
                        onTapp: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostDetalis(
                                      filteredAds[index].adName,
                                      filteredAds[index].adResourceType,
                                      filteredAds[index].adDate,
                                      filteredAds[index].adPlace
                                  )
                              )
                          );
                        }
                    );
                  }, separatorBuilder: (BuildContext context, int index) { return Container(
                  width: 1.0,
                  height: double.infinity,
                  color: Colors.grey[300],
                );},
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              " All Rides",
              textAlign: TextAlign.left,
              style: GoogleFonts.readexPro(
                  textStyle: TextStyle(
                    color: Colors.indigo,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  )
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // This specifies the number of columns in the grid
                  childAspectRatio: 3 / 2, // Adjust according to your needs
                ),
                itemCount: filteredAds.length,
                itemBuilder: (context, index) => buildListItem2(
                    adName: filteredAds[index].adName,
                    adResourceType: filteredAds[index].adResourceType,
                    adDate: filteredAds[index].adDate,
                    adPlace: filteredAds[index].adPlace,
                    photoUrl: filteredAds[index].photoUrl,
                    onTapp: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetalis(
                                  filteredAds[index].adName,
                                  filteredAds[index].adResourceType,
                                  filteredAds[index].adDate,
                                  filteredAds[index].adPlace
                              )
                          )
                      );
                    }
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}