abstract class HomeStates {}

class HomeInitialState extends HomeStates{}

class HomeChangeBottomNabBarState extends HomeStates {}

class FiltersUpdatedState extends HomeStates {}

class SearchResultsUpdatedState extends HomeStates {
  final List<String> results;

  SearchResultsUpdatedState(this.results);
}