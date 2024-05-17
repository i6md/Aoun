import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:http/http.dart' as http;

import '../../../models/list_passengers_model.dart';
import '../../../models/user/events_model.dart';
import '../../login/auth_service.dart';
import 'participations_list_widget.dart';
import 'passengers_list_widget.dart';

// ignore: must_be_immutable
class ListPassengers extends StatelessWidget {
  final String? ride_id;
  const ListPassengers({Key? key, required this.ride_id})
      : super(key: key);

  Future<List<ListPassengersModel>> listP() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    print(token);
    print('we reached here Events');
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'list_type': 'all',
      'ride_id': ride_id
    };
    final response = await http.post(
        Uri.parse(
            'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_passengers'),
        headers: requestHeaders,
        body: json.encode(requestBody));
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('State8798');
    //print('requestHeader: $requestHeaders\n\n\n requestBody: $requestBody');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var passengers = data['passengers'] as List;
      print(passengers);
      return passengers.map((passenger) => ListPassengersModel.fromJson(passenger)).toList();
    } else {
      print(
          'Error viewing events. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('No Passengers yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Ride Passengers",
            style: TextStyle(
              color: Colors.indigo,
              fontSize: 20,
              fontWeight: FontWeight.w500,

            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.indigo,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
    return FutureBuilder<List<ListPassengersModel>>(
      future: listP(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          var passengers = snapshot.data ?? [];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Passengers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
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
                          thickness: 2.v,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },

                  itemCount: passengers.length,

                  itemBuilder: (context, index) {

                    return passengers.length == 0
                        ? Text("No passengers available")
                        : PassengerslistWidget(passenger: passengers[index]);
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


