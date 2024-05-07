import 'package:aoun_app/modules/events_screen/events_screen.dart';
import 'package:aoun_app/modules/items_screen/items_screen.dart';
import 'package:aoun_app/modules/rides_screen/rides_screen.dart';
import 'package:aoun_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user/ads_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  printToken() {
    // TODO: implement print
  }

  int counter = 0;
  ItemsScreen itemsScreen = ItemsScreen();
  EventsScreen eventsScreen = EventsScreen();
  RidesScreen ridesScreen = RidesScreen();
  List<String> filters = [];
  List<Widget> screens = [ItemsScreen(), EventsScreen(), RidesScreen()];
  List<String> titles = ['Items', 'Events', 'Rides'];

  void changeIndex(int index) {
    counter = index;
    filters.clear(); // Clear the filters
    updateFilters(filters); // Update the screens with the cleared filters
    emit(HomeChangeBottomNabBarState());
  }

  void updateFilters(List<String> newFilters) async {
    filters = newFilters;
    // Apply the filters to the screens
    // itemsScreen.applyFilters(filters, await itemsScreen.fetchAds());
    // eventsScreen.applyFilters(filters, await eventsScreen.fetchEvents());
    // ridesScreen.applyFilters(filters);
    emit(FiltersUpdatedState());
  }

  void updateSearchResults(List<String> results) {
    emit(SearchResultsUpdatedState(results));
  }

  Future<List<dynamic>> get ads async {
    switch (counter) {
      case 0:
        return await itemsScreen.fetchAds();
      case 1:
        return await eventsScreen.fetchEvents(); // Assuming eventsScreen and ridesScreen also have fetchAds method
      case 2:
        return await ridesScreen
            .ads; // Assuming eventsScreen and ridesScreen also have fetchAds method
      default:
        return [];
    }
  }
}
