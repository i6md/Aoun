class EventsModel {
  final String? event_id;
  final DateTime? created_at;
  final String? category;
  final String? owner_id;
  final String? owner_name;
  final String? owner_phone;
  final String? adName;
  final String? description;
  final DateTime? start_date_time;
  final DateTime? end_date_time;
  final String? building;
  final String? room;
  final int? participants_number;
  final int? joined;
  final bool? expired;
  final adtype;
  final List<dynamic>? pictures;
  final String photoUrl;

  // final Boolean expired;
  // final String owner_Id;
  EventsModel({
    // this.owner_Id,
    required this.event_id,
    this.created_at,
    this.category,
    this.owner_id,
    this.adName,
    this.description,
    this.start_date_time,
    this.end_date_time,
    this.building,
    this.room,
    this.owner_name,
    this.owner_phone,
    this.joined,
    this.participants_number,
    this.adtype = 'Event',
    this.expired,
    this.pictures,
    this.photoUrl =
        'https://drive.google.com/file/d/1uOX8EaE59dW_bLBx5oC5jpNxNCZn3qxo/view?usp=drive_link',
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    // String start_date_time_string = json['start_date_time'];
    // start_date_time_string =
    //     start_date_time_string.substring(0, start_date_time_string.length - 4);
    // String end_date_time_string = json['end_date_time'];
    // end_date_time_string =
    //     end_date_time_string.substring(0, end_date_time_string.length - 4);
    return EventsModel(
      event_id: json['event_id'],
      created_at: DateTime.parse(json['created_at']),
      owner_id: json['owner_id'],
      owner_name: json['owner_name'],
      owner_phone: json['owner_phone_number'],
      category: json['category'],
      adName: json['title'],
      description: json['description'],
      start_date_time: DateTime.parse(json['start_date_time']),
      end_date_time: DateTime.parse(json['end_date_time']),
      building: json['building'],
      room: json['room'],
      joined: int.parse(json['joined']),
      expired: json['expired'],
      participants_number: int.parse(json['participants_number']),
      pictures: json['pictures'],
    );
  }
}
