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

class ItemsScreen extends StatelessWidget {
  Future<List<AdsModel>> fetchAds() async {
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
            'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_items'),
        headers: requestHeaders,
        body: json.encode(requestBody));
    //print('requestHeader: $requestHeaders\n\n\n requestBody: $requestBody');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var items = data['items'] as List;
      print(items);
      return items.map((item) => AdsModel.fromJson(item)).toList();
    } else {
      print(
          'Error viewing items. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to load ads');
    }
  }

  void applyFilters(List<String> filters, List<AdsModel> ads) {
    List<AdsModel> filteredAds = filters.isNotEmpty
        ? ads.where((ad) => filters.contains(ad.adResourceType)).toList()
        : ads;
    // Update the state of the HomeCubit with the new filters
    HomeCubit.get(context).updateFilters(filters);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        List<String> filters = HomeCubit.get(context).filters;
        return FutureBuilder<List<AdsModel>>(
          future: fetchAds(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              List<AdsModel> ads = snapshot.data ?? [];
              List<AdsModel> filteredAds = filters.isNotEmpty
                  ? ads.where((ad) => filters.contains(ad.adResourceType)).toList()
                  : ads;

              // Sort thefilteredAds by adDate (newest first)
              filteredAds.sort((a, b) => b.adDate!.compareTo(a.adDate!));

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
                          return buildListItem3(
                              adName: filteredAds[index].adName,
                              adResourceType: filteredAds[index].adResourceType,
                              adDate: filteredAds[index].adDate,
                              adPlace: filteredAds[index].adPlace,
                              adImages: filteredAds[index].adImages,
                              photoUrl: filteredAds[index].photoUrl,
                              onTapp: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostDetalis(
                                          filteredAds[index].adId,
                                          filteredAds[index].adName!,
                                          filteredAds[index].adResourceType!,
                                          filteredAds[index].adDate!,
                                          filteredAds[index].adPlace!,
                                          filteredAds[index].adDescription!,
                                          adPictures: filteredAds[index].adImages,
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
                    " All Items",
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
                        crossAxisCount:2, // This specifies the number of columns in the grid
                        childAspectRatio: 3 / 2, // Adjust according to your needs
                      ),
                      itemCount: filteredAds.length,
                      itemBuilder: (context, index) => buildListItem2(
                        adName: filteredAds[index].adName,
                        adResourceType: filteredAds[index].adResourceType,
                        adDate: filteredAds[index].adDate,
                        adPlace: filteredAds[index].adPlace,
                        adImages: filteredAds[index].adImages,
                        photoUrl: filteredAds[index].photoUrl,
                        onTapp: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostDetalis(
                                    filteredAds[index].adId,
                                    filteredAds[index].adName!,
                                    filteredAds[index].adResourceType!,
                                    filteredAds[index].adDate!,
                                    filteredAds[index].adPlace!,
                                    filteredAds[index].adDescription!,
                                    adPictures: filteredAds[index].adImages,

                                  )));
                        },
                      ),
                    ),
                  ),
                ],
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
