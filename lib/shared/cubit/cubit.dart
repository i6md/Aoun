import 'package:aoun_app/modules/events_screen/events_screen.dart';
import 'package:aoun_app/modules/items_screen/items_screen.dart';
import 'package:aoun_app/modules/rides_screen/rides_screen.dart';
import 'package:aoun_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeCubit extends Cubit <HomeStates>
{
  HomeCubit(): super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);
  int counter = 0;
  List<Widget> screens = [
    ItemsScreen(),EventsScreen(),RidesScreen()
  ];
  List<String> titles = [
    'Items',
    'Events',
    'Rides'
  ];

  void changeIndex (int index){
    counter=index;
    emit(HomeChangeBottomNabBarState());
  }

}