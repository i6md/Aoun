class RidesModel {
  final String? ride_id;
  final String? title;
  final String? description;
  final String? category;
  final String? strat_location;
  final String? end_location;
  final DateTime? start_date_time;
  final DateTime? available_seats;
  final String? joined;
  final bool? expired;
  final DateTime? created_at;
  final String? owner_id;

  RidesModel({
    required this.ride_id,
    this.title,
    this.description,
    this.category,
    this.strat_location,
    this.end_location,
    this.start_date_time,
    this.available_seats,
    this.joined,
    this.expired,
    this.created_at,
    this.owner_id,
  });

  factory RidesModel.fromJson(Map<String, dynamic> json) {
    return RidesModel(
        ride_id: json['ride_id'],
        title: json['title'],
        description: json['description'],
        category: json['category'],
        strat_location: json['strat_location'],
        end_location: json['end_location'],
        start_date_time: DateTime.parse(json['start_date_time']),
        available_seats: json['available_seats'],
        joined: json['joined'],
        expired: json['expired'],
        created_at: DateTime.parse(json['created_at']),
        owner_id: json['owner_id']

    );
  }
}
