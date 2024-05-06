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
        return FutureBuilder<List<AdsModel>>(
          future: fetchAds(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              List<AdsModel> ads = snapshot.data ?? [];
              List<AdsModel> filteredAds = filters.isNotEmpty
                  ? ads
                      .where((ad) => filters.contains(ad.adResourceType))
                      .toList()
                  : ads;

              // Sort thefilteredAds by adDate (newest first)
              filteredAds.sort((a, b) => b.adDate!.compareTo(a.adDate!));

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
                          filteredAds[index].adId,
                          filteredAds[index].adName!,
                          filteredAds[index].adResourceType!,
                          filteredAds[index].adDate!,
                          filteredAds[index].adPlace!,
                          filteredAds[index].adDescription!,
                          adPictures: filteredAds[index].adImages,
                        ),
                      ),
                    );
                  },
                ),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 5.0,
                    top: 8.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
                itemCount: filteredAds.length,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
