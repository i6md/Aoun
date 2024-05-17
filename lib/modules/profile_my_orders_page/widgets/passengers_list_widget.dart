import 'dart:convert';


import 'package:aoun_app/models/list_passengers_model.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:http/http.dart' as http;

import '../../login/auth_service.dart';

// ignore: must_be_immutable
class PassengerslistWidget extends StatelessWidget {
  final ListPassengersModel passenger;
  const PassengerslistWidget({Key? key, required this.passenger})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
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
                "${passenger.client_name}",
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 12.v),
              Text(
                "${passenger.client_phone_number}",
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 12.v),
              Text(
                "${passenger.joined_at}",
                style: theme.textTheme.bodyMedium,
              ),

            ],

          ),

        ),

        // Add a delete button
      ],
    );
  }
}
