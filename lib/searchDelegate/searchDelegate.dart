import 'package:aoun_app/models/user/ads_model.dart';
import 'package:aoun_app/modules/post/post_details.dart';
import 'package:flutter/material.dart';

import '../shared/cubit/cubit.dart';

class DataSearch extends SearchDelegate<dynamic> {
  final Future<List<dynamic>> dataList;

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
        close(
            context,
            null); // Close the search page and return null as the result
      },
    );
  }

  @override
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final suggestionList = snapshot.data
              ?.where((item) => item.adName!.startsWith(query))
              .toList();
          // Emit a new state with the search results
          HomeCubit.get(context).updateSearchResults(
              suggestionList!.map((item) => item.adName!.toString()).toList());
          // Close the search page
          close(
              context,
              null);
          return Container(); // Return an empty container as the search page is closed
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final suggestionList = snapshot.data!
              .where((item) => item.adName!.startsWith(query))
              .toList();
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(suggestionList[index].adName!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetalis(
                         suggestionList[index],
                    ),
                  ),
                );
              },
            ),
            itemCount: suggestionList.length,
          );
        }
      },
    );
  }
}
