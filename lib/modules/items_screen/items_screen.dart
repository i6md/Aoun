import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/models/user/ads_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../post/post_details.dart';
class ItemsScreen extends StatelessWidget {
  List<AdsModel> ads = [
    AdsModel(
      adName: "Vacuum Cleaner",
      adResourceType: "Image",
      adDate: "2024-03-10",
      adPlace: "Online",
      photoUrl: 'https://cdn.salla.sa/zRABG/7AnnbZo4Zqn1Q2yVhn7G4gSp6sqjGQn2blvGWhwN.jpg'

    ),
    AdsModel(
      adName: "Screwdriver Set",
      adResourceType: "Video",
      adDate: "2024-03-15",
      adPlace: "Convention Center",
photoUrl: 'https://img.kwcdn.com/product/and-screwdrivers/d69d2f15w98k18-eb3690be/Fancyalgo/VirtualModelMatting/7e235573cf7ba940ee0ce90c5b6d908d.jpg?imageView2/2/w/500/q/60/format/webp'
    ),
    AdsModel(
      adName: "Tape Measure",
      adResourceType: "Banner",
      adDate: "2024-03-18",
      adPlace: "Shopping Mall",
      photoUrl: 'https://media.istockphoto.com/id/174798452/photo/tape-measure.jpg?s=612x612&w=0&k=20&c=iiJES37j8pSl_-7rhqiz-S4h8l9hpzXzcCwhxblrUyY='
    ),
    AdsModel(
      adName: "Car Jack",
      adResourceType: "Image",
      adDate: "2024-03-20",
      adPlace: "Gym",
      photoUrl: 'https://image.doba.com/dg7-AIFeYyTFQKbL/3t-low-profile-jack-red-and-black-ultra-low-floor-jack-with-dual-pistons-quick-lift-pump-car-jack-hydraulic-autolifts-for-home-garage-truck-jack-hydraulic-lifting-range-33-197.webp'
    ),
    AdsModel(
        adName: "Vacuum Cleaner",
        adResourceType: "Image",
        adDate: "2024-03-10",
        adPlace: "Online",
        photoUrl: 'https://cdn.salla.sa/zRABG/7AnnbZo4Zqn1Q2yVhn7G4gSp6sqjGQn2blvGWhwN.jpg'

    ),
    AdsModel(
        adName: "Screwdriver Set",
        adResourceType: "Video",
        adDate: "2024-03-15",
        adPlace: "Convention Center",
        photoUrl: 'https://img.kwcdn.com/product/and-screwdrivers/d69d2f15w98k18-eb3690be/Fancyalgo/VirtualModelMatting/7e235573cf7ba940ee0ce90c5b6d908d.jpg?imageView2/2/w/500/q/60/format/webp'
    ),
    AdsModel(
        adName: "Tape Measure",
        adResourceType: "Banner",
        adDate: "2024-03-18",
        adPlace: "Shopping Mall",
        photoUrl: 'https://media.istockphoto.com/id/174798452/photo/tape-measure.jpg?s=612x612&w=0&k=20&c=iiJES37j8pSl_-7rhqiz-S4h8l9hpzXzcCwhxblrUyY='
    ),
    AdsModel(
        adName: "Car Jack",
        adResourceType: "Image",
        adDate: "2024-03-20",
        adPlace: "Gym",
        photoUrl: 'https://image.doba.com/dg7-AIFeYyTFQKbL/3t-low-profile-jack-red-and-black-ultra-low-floor-jack-with-dual-pistons-quick-lift-pump-car-jack-hydraulic-autolifts-for-home-garage-truck-jack-hydraulic-lifting-range-33-197.webp'
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " Newly Added Items",
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
                " All Items",
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
                    },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}