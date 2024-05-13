import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:http/http.dart' as http;

import '../../login/auth_service.dart';

// ignore: must_be_immutable
class OrderslistItemWidget extends StatelessWidget {
  final dynamic ad;
  const OrderslistItemWidget({Key? key, required this.ad})
      : super(key: key);

  Future<void> deleteItem() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      "item_id": ad.adId,
    };

    final response = await http.post(
        Uri.parse('https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/delete_item'),
        headers: requestHeaders,
        body: json.encode(requestBody)
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print('Item Deleted successfully: $message');

    } else {
      final errorResponse = json.decode(response.body);
      final error = errorResponse['error'];
      print('$error');
    }

  }
  Future<void> deleteEvent() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      "event_id": ad.event_id,
    };

    final response = await http.post(
        Uri.parse('https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/delete_event'),
        headers: requestHeaders,
        body: json.encode(requestBody)
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print('Event deleted successfully: $message');

    } else {
      final errorResponse = json.decode(response.body);
      final error = errorResponse['error'];
      print('$error');
    }

  }
  Future<void> deleteRide() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      "ride_id": ad.ride_id,
    };

    final response = await http.post(
        Uri.parse('https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/delete_ride'),
        headers: requestHeaders,
        body: json.encode(requestBody)
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print('Ride deleted successfully: $message');

    } else {
      final errorResponse = json.decode(response.body);
      final error = errorResponse['error'];
      print('$error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16.h,
            top: 2.v,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ad.adName.toString(),
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 12.v),
              if(ad.adtype=='Item')
                Text(
                  ad.adDate.toString(),
                  style: theme.textTheme.bodyMedium,
                ),
              if(ad.adtype=='Event')
                Text(
                  ad.created_at.toString(),
                  style: theme.textTheme.bodyMedium,
                ),
              if(ad.adtype=='Ride')
                Text(
                  ad.created_at.toString(),
                  style: theme.textTheme.bodyMedium,
                ),
              SizedBox(height: 38.v),
            ],
          ),
        ),
        // Add a delete button
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
              if(ad.adtype == 'Item'){
                deleteItem();
              }
              else if (ad.adtype=="Event"){
                deleteEvent();
              }
              else if (ad.adtype=="Ride"){
                deleteRide();
              }
              else{
                print('No such ad type');
              }
          },
        ),
      ],
    );
  }
}
