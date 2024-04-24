import 'package:aoun_app/models/user/ads_model.dart';
import 'package:aoun_app/modules/post/post_details.dart';
import 'package:flutter/material.dart';

import '../shared/cubit/cubit.dart';

class DataSearch extends SearchDelegate<AdsModel> {
  final List<AdsModel> dataList;

  DataSearch(this.dataList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, AdsModel(adName: '', adResourceType: '', adDate: '', adPlace: ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = dataList.where((item) => item.adName.startsWith(query)).toList();

    // Emit a new state with the search results
    HomeCubit.get(context).updateSearchResults(suggestionList.map((item) => item.adName).toList());

    // Close the search page
    close(context, AdsModel(adName: '', adResourceType: '', adDate: '', adPlace: ''));

    return Container(); // Return an empty container as the search page is closed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = dataList.where((item) => item.adName.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index].adName),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetalis(
                suggestionList[index].adName,
                suggestionList[index].adResourceType,
                suggestionList[index].adDate,
                suggestionList[index].adPlace,
              ),
            ),
          );
        },
      ),
      itemCount: suggestionList.length,
    );
  }
}