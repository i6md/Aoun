import 'package:aoun_app/models/rides_model.dart';
import 'package:aoun_app/models/user/events_model.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/models/user/ads_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../login/auth_service.dart';
import '../post/post_details.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/models/user/ads_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/modules/login/auth_service.dart';
import 'package:path/path.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../post/post_details.dart';

class RidesScreen extends StatelessWidget {
  //'KFUPM to Airport', 'Airport to KFUPM', 'Riyadh to KFUPM', 'KFUPM to Riyadh'
    Future<List<RidesModel>> fetchRides() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    print('we reached here');
    //print(token);
    //_LoginScreenState.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'list_type': 'available',
    };
    final response = await http.post(
        Uri.parse(
            'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_rides'),
        headers: requestHeaders,
        body: json.encode(requestBody));
    //print('requestHeader: $requestHeaders\n\n\n requestBody: $requestBody');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('this is aseem 1');
      var rides = data['rides'] as List;
      print(rides);
      print('this is aseem 2');
      return rides.map((ride) => RidesModel.fromJson(ride)).toList();
    } else {
      print('this is aseem 3');
      print(
          'Error viewing rides. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to load ads');
    }
  }

 // List<AdsModel> ads = [
    /*
    AdsModel(
        adName: "KFUPM to Airport",
        adResourceType: "KFUPM to Airport",
        adDate: "2024-03-10",
        adPlace: "Online",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),
    AdsModel(
        adName: "Airport to KFUPM",
        adResourceType: "Airport to KFUPM",
        adDate: "2024-03-15",
        adPlace: "Convention Center",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),
    AdsModel(
        adName: "Riyadh to KFUPM",
        adResourceType: "Riyadh to KFUPM",
        adDate: "2024-03-18",
        adPlace: "Shopping Mall",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),
    AdsModel(
        adName: "KFUPM to Riyadh",
        adResourceType: "KFUPM to Riyadh",
        adDate: "2024-03-20",
        adPlace: "Gym",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),
    AdsModel(
        adName: "KFUPM to Airport",
        adResourceType: "KFUPM to Airport",
        adDate: "2024-03-25",
        adPlace: "City Park",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),
    AdsModel(
        adName: "Airport to KFUPM",
        adResourceType: "Airport to KFUPM",
        adDate: "2024-03-28",
        adPlace: "Travel Agency",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),
    AdsModel(
        adName: "Riyadh to KFUPM",
        adResourceType: "Riyadh to KFUPM",
        adDate: "2024-04-02",
        adPlace: "Esports Arena",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),
    AdsModel(
        adName: "KFUPM to Riyadh",
        adResourceType: "KFUPM to Riyadh",
        adDate: "2024-04-05",
        adPlace: "Fashion District",
        photoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s'),*/
  //];
  void applyFilters(List<String> filters,List<RidesModel> ads) {
    List<RidesModel> filteredAds = filters.isNotEmpty
        ? ads.where((ad) => filters.contains(ad.start_loc)).toList()
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
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      List<String> filters;
      if (state is SearchResultsUpdatedState) {
        filters = state.results;
      } else {
        filters = HomeCubit.get(context).filters;
      }
      return FutureBuilder<List<RidesModel>>(
        future: fetchRides(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<RidesModel> ads = snapshot.data ?? [];
            List<RidesModel> filteredAds = filters.isNotEmpty
                ? ads.where((ad) => filters.contains(ad.ride_id)).toList()
                : ads;

            // Sort thefilteredAds by adDate (newest first)
            //filteredAds.sort((a, b) => b.adDate!.compareTo(a.adDate!));
            // Sort thefilteredAds by adDate (newest first)
            var sortedAds = filteredAds;
            sortedAds.sort((a, b) => b.created_at!.compareTo(a.created_at!));

            // List<AdsModel> filteredAds = filters.isNotEmpty
            //     ? ads.where((ad) => filters.contains(ad.adResourceType)).toList()
            //     : ads;
            return RefreshIndicator(
              onRefresh: fetchRides,
              child: Column(
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
                    )),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 90,
                    child: Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis
                            .horizontal, // This makes the ListView scroll horizontally
                        itemCount: filteredAds.length,
                        itemBuilder: (context, index) {
                          return buildListRides3(
                              title: filteredAds[index].adName!,
                              start_date_time: filteredAds[index].start_date_time!,
                              created_at: filteredAds[index].created_at,
                              end_loc: filteredAds[index].end_loc!,
                              start_loc: filteredAds[index].start_loc!,
                              total_seats: filteredAds[index].total_seats!,
                              joined: filteredAds[index].joined!,
                              photoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s',     onTapp: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostDetalis(
                                              filteredAds[index]
                                        )));
                              });
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 1.0,
                            height: double.infinity,
                            color: Colors.grey[300],
                          );
                        },
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
                    )),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            2, // This specifies the number of columns in the grid
                        childAspectRatio: 3 / 2, // Adjust according to your needs
                      ),
                      itemCount: filteredAds.length,
                      itemBuilder: (context, index) => buildListRide(
                         title: filteredAds[index].adName!,
                          start_date_time: filteredAds[index].start_date_time!,
                          created_at: filteredAds[index].created_at,
                          end_loc: filteredAds[index].end_loc!,
                          start_loc: filteredAds[index].start_loc!,
                          total_seats: filteredAds[index].total_seats!,
                          joined: filteredAds[index].joined!,
                          photoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s',
                          onTapp: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostDetalis(
                                      filteredAds[index]
                                    )));
                          }),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    });
  }
}
