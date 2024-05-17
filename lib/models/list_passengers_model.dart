class ListPassengersModel {
  final String? ride_id;
  final String? order_id;
  final String? clinet_id;
  final DateTime? joined_at;
  final String? client_name;
  final String? client_phone_number;

  ListPassengersModel({
    required this.ride_id,
    required this.order_id,
    required this.clinet_id,
    required this.joined_at,
    required this.client_name,
    required this.client_phone_number,
  });


  factory ListPassengersModel.fromJson(Map<String, dynamic> json) {
    return ListPassengersModel(
      ride_id: json['ride_id'],
      order_id: json['order_id'],
      clinet_id: json['client_id'],
      joined_at: DateTime.parse(json['ordered_at']),
      client_name: json['client_name'],
      client_phone_number: json['client_phone_number'],
    );
  }
}
