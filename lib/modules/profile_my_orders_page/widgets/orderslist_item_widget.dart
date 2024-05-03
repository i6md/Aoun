import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';

// ignore: must_be_immutable
class OrderslistItemWidget extends StatelessWidget {
  const OrderslistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          // CustomImageView(
          //   imagePath: ,
          //   height: 110.v,
          //   width: 109.h,
          // ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.h,
              top: 2.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "12.50",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 12.v),
                Text(
                  "shorts in Yellow",
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 38.v),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1.v),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Qty:",
                              style: CustomTextStyles.bodyMediumff6d747c,
                            ),
                            TextSpan(
                              text: " ",
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Text(
                        "1",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
