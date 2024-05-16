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

class EventsScreen extends StatelessWidget {
  Future<List<EventsModel>> fetchEvents() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    print('we reached here Events');
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
            'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_events'),
        headers: requestHeaders,
        body: json.encode(requestBody));
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('State8798');
    //print('requestHeader: $requestHeaders\n\n\n requestBody: $requestBody');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var events = data['events'] as List;
      print(events);
      return events.map((event) => EventsModel.fromJson(event)).toList();
    } else {
      print(
          'Error viewing events. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to load ads');
    }
  }

  void applyFilters(List<String> filters, List<EventsModel> ads) {
    List<EventsModel> filteredAds = filters.isNotEmpty
        ? ads.where((ad) => filters.contains(ad.category)).toList()
        : ads;
    // Update the state of the HomeCubit with the new filters
    HomeCubit.get(context).updateFilters(filters);
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
        return FutureBuilder<List<EventsModel>>(
          future: fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              List<EventsModel> ads = snapshot.data ?? [];
              List<EventsModel> filteredAds = filters.isNotEmpty
                  ? ads
                  .where((ad) => filters.contains(ad.category))
                  .toList()
                  : ads;
              var sortedAds = filteredAds;
              sortedAds.sort((a, b) => b.created_at!.compareTo(a.created_at!));

              return RefreshIndicator(
                onRefresh: () async {
                  await fetchEvents();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Newly Added Events",
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
                          itemCount: sortedAds.length,
                          itemBuilder: (context, index) {
                            return buildListItem3(
                                adName: sortedAds[index].adName,
                                adResourceType: sortedAds[index].expired,
                                adDate: sortedAds[index].created_at,
                                adImages: sortedAds[index].pictures,
                                adPlace: sortedAds[index].building,
                                photoUrl: sortedAds[index].photoUrl,
                                onTapp: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetalis(sortedAds[index])));
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
                      " All Events",
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
                          childAspectRatio:
                              3 / 2, // Adjust according to your needs
                        ),
                        itemCount: filteredAds.length,
                        itemBuilder: (context, index) => buildListEvent(
                          title: filteredAds[index].adName,
                          event_type: 'Event',
                          created_at: filteredAds[index].created_at,
                          building: filteredAds[index].building,
                          pictures: filteredAds[index].pictures,
                          photoUrl: filteredAds[index].photoUrl,
                          joined: filteredAds[index].joined,
                          participants_number:
                              filteredAds[index].participants_number,
                          onTapp: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostDetalis(filteredAds[index])));
                          },
                        ),
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
      },
    );
  }
}
