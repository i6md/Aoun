class RidesModel {
  final String? ride_id;
  final DateTime? created_at;
  final String? owner_id;
  final String? adName;
  final String? description;
  final String? start_loc;
  final String? end_loc;
  final DateTime? start_date_time;
  final int? total_seats;
  final int? joined;
  final bool? expired;
  final String? adtype;
  final String photoUrl;

  // final Boolean expired;
  // final String owner_Id;
  RidesModel({
    // this.owner_Id,
    required this.ride_id,
    this.created_at,
    this.owner_id,
    this.adName,
    this.description,
    this.start_loc,
    this.end_loc,
    this.start_date_time,
    this.joined,
    this.total_seats,
    this.expired,
    this.adtype = 'Ride',
    this.photoUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ22Tv1E3gjmg72p1QMkm3vmCwpX30ye9lDpGqS4TYbhA&s',
  });

  factory RidesModel.fromJson(Map<String, dynamic> json) {
    // String start_date_time_string = json['start_date_time'];
    // start_date_time_string =
    //     start_date_time_string.substring(0, start_date_time_string.length - 4);
    // String end_date_time_string = json['end_date_time'];
    // end_date_time_string =
    //     end_date_time_string.substring(0, end_date_time_string.length - 4);
    return RidesModel(
      ride_id: json['ride_id'],
      created_at: DateTime.parse(json['created_at']),
      owner_id: json['owner_id'],
      adName: json['title'],
      description: json['description'],
      start_loc: json['start_location'],
      end_loc: json['end_location'],
      start_date_time: DateTime.parse(json['start_date_time']),
      joined: int.parse(json['joined']),
      expired: json['expired'],
      total_seats: int.parse(json['available_seats']),
    );
  }
}
