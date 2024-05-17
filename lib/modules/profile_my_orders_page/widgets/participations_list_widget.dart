import 'dart:convert';

import 'package:aoun_app/models/list_participations_model.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:http/http.dart' as http;

import '../../login/auth_service.dart';

// ignore: must_be_immutable
class ParticipationslistWidget extends StatelessWidget {
  final ListParticipationsModel participation;
  const ParticipationslistWidget({Key? key, required this.participation})
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
                "${participation.client_name}",
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 12.v),
              Text(
                "${participation.client_phone_number}",
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 12.v),
                Text(
                  "${participation.joined_at}",
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
