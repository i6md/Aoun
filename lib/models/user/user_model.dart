import 'package:intl/intl.dart';

class UserModel
{
  final String id;
  final String name;
  final String phone;
  final String email;
  final String building;
  final String room;
  final String pic;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.building,
    required this.room,
    required this.pic
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // String start_date_time_string = json['start_date_time'];
    // start_date_time_string =
    //     start_date_time_string.substring(0, start_date_time_string.length - 4);
    // String end_date_time_string = json['end_date_time'];
    // end_date_time_string =
    //     end_date_time_string.substring(0, end_date_time_string.length - 4);

    // Add debug print statements to log the type and value of each field
    // print("Parsing user_id: ${json['user_id']}, Type: ${json['user_id'].runtimeType}");
    // print("Parsing email: ${json['email']}, Type: ${json['email'].runtimeType}");
    // print("Parsing phone_number: ${json['phone_number']}, Type: ${json['phone_number'].runtimeType}");
    // print("Parsing name: ${json['name']}, Type: ${json['name'].runtimeType}");
    // print("Parsing building: ${json['building']}, Type: ${json['building'].runtimeType}");
    // print("Parsing room: ${json['room']}, Type: ${json['room'].runtimeType}");
    // print("Parsing pic: ${json['pic']}, Type: ${json['pic'].runtimeType}");


    return UserModel(
      id: json['user_id']as String? ?? "no user id",
      email: json['email']as String? ?? "no email",
      phone: json['phone_number']as String? ?? "no phoneNumber",
      name: json['name']as String? ?? "no name",
      building: json['building']as String? ?? "no building",
      room: json['room']as String? ?? "no room",
        pic: json['pic']as String? ?? "no picture"
    );
  }

}