import 'package:aoun_app/models/user/ads_model.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';

class RidesScreen extends StatelessWidget {
  List<AdsModel> ads = [
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    AdsModel(
      adName: "Car Loan",
      adDescription: "Get a loan to finance your dream car.",
      adDate: "2024-02-09",
    ),
    AdsModel(
      adName: "Home Mortgage",
      adDescription: "Own your dream home with our mortgage solutions.",
      adDate: "2024-02-10",
    ),
    AdsModel(
      adName: "Personal Loan",
      adDescription: "Need some extra cash? Apply for a personal loan today.",
      adDate: "2024-02-11",
    ),
    // Add more ads as needed
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.only(top: 8),
        itemBuilder: (context,index)=> buildListItem(
            adName: ads[index].adName,
            adDescription: ads[index].adDescription,
            adDate: ads[index].adDate
        ),
        separatorBuilder: (context,index)=>
            Padding(
              padding: const EdgeInsetsDirectional.only(start:20.0,  top: 6.0),
              child: Container(
                width: double.infinity,
                height: 3.0,
                color: Colors.grey[300],
              ),
            ),
        itemCount: ads.length
    );
  }

}