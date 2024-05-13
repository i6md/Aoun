import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import '../../models/rides_model.dart';
import '../../models/user/ads_model.dart';
import '../../models/user/events_model.dart';
import '../../models/user/user_model.dart';
import '../login/auth_service.dart';
import 'widgets/orderslist_item_widget.dart';

// ignore_for_file: must_be_immutable
class ProfileMyOrdersPage extends StatefulWidget {
  final UserModel user;

  const ProfileMyOrdersPage({Key? key, required this.user})
      : super(key: key);

  @override
  ProfileMyOrdersPageState createState() => ProfileMyOrdersPageState();
}

class ProfileMyOrdersPageState extends State<ProfileMyOrdersPage>
    with AutomaticKeepAliveClientMixin<ProfileMyOrdersPage> {
  @override
  bool get wantKeepAlive => true;
  Future<List<dynamic>>? ads;

  Future<List<AdsModel>> fetchAds(UserModel user) async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    print('we reached here');

    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'list_type': 'by_owner',
      'owner_id': user.id
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

  Future<List<EventsModel>> fetchEvents(UserModel user) async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    print('we reached here Events');
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'list_type': 'by_owner',
      'owner_id': user.id
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

  //'KFUPM to Airport', 'Airport to KFUPM', 'Riyadh to KFUPM', 'KFUPM to Riyadh'
  Future<List<RidesModel>> fetchRides(UserModel user) async {
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
      'list_type': 'by_owner',
      'owner_id': user.id,
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

  Future<List> fetchAllData(UserModel user) async {
    List<dynamic> ads = await fetchAds(user);
    List<dynamic> events = await fetchEvents(user);
    List<dynamic> rides = await fetchRides(user);
    List<dynamic> allData = [];
    allData.addAll(ads);
    allData.addAll(events);
    allData.addAll(rides);
    return allData;
    // Now you have the user info, ads, events, and rides data
    // You can use these data as per your requirements
  }

  void initState() {
    super.initState();

    ads = fetchAllData(widget.user);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.white,
          child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 38.v),
                _buildOrdersList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildOrdersList(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ads,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          var adsData = snapshot.data ?? [];
          List<dynamic> activeAds = adsData.where((ad) => ad.expired == false).toList();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Orders",
                  style: CustomTextStyles.titleSmallOnPrimarySemiBold,
                ),
                SizedBox(height: 20.v),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (
                      context,
                      index,
                      ) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.5.v),
                      child: SizedBox(
                        width: 358.h,
                        child: Divider(
                          height: 1.v,
                          thickness: 1.v,
                          color: appTheme.gray300,
                        ),
                      ),
                    );
                  },

                  itemCount: activeAds.length,

                  itemBuilder: (context, index) {

                    return OrderslistItemWidget(ad: activeAds[index]);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}



