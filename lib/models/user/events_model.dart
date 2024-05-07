class EventsModel {
  final String? event_id;
  final DateTime? created_at;
  final String? event_type;
  final String? owner_id;
  final String? title;
  final String? description;
  final DateTime? start_date_time;
  final DateTime? end_date_time;
  final String? building;
  final String? room;
  final int? participants_number;
  final int? joined;
  final bool? expired;
  final List<dynamic>? pictures;
  final String photoUrl;

  // final Boolean expired;
  // final String owner_Id;
  EventsModel({
    // this.owner_Id,
    required this.event_id,
    this.created_at,
    this.event_type,
    this.owner_id,
    this.title,
    this.description,
    this.start_date_time,
    this.end_date_time,
    this.building,
    this.room,
    this.joined,
    this.participants_number,
    this.expired,
    this.pictures,
    this.photoUrl =
    'https://drive.google.com/file/d/1uOX8EaE59dW_bLBx5oC5jpNxNCZn3qxo/view?usp=drive_link',
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      event_id: json['event_id'],
      created_at: DateTime.parse(json['created_at']),
      owner_id: json['owner_id'],
      event_type: json['event_type'],
      title: json['title'],
      description: json['description'],
      start_date_time: DateTime.parse(json['start_date_time']),
      end_date_time: DateTime.parse(json['end_date_time']),
      building: json['building'],
      room: json['room'],
      joined: json['joined'],
      expired: json['expired'],
      participants_number: json['participants_number'],
      pictures: json['pictures'],
    );
  }

}
