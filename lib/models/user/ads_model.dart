class AdsModel {
  final String? adId;
  final String? adName;
  final String? owner_id;
  final String? category;
  final String? adResourceType;
  final DateTime? adDate;
  final String? building;
  final bool? expired;
  final String? adtype;
  final List<dynamic>? pictures;
  final String? photoUrl;

  // final Boolean expired;
  // final String owner_Id;
  final String? description;
  AdsModel({
    this.owner_id,
    required this.adId,
    this.expired,
    this.category,
    required this.adName,
    required this.adResourceType,
    required this.adDate,
    required this.building,
    required this.description,
    this.adtype= 'Item',
    this.pictures,
    this.photoUrl =
        'https://drive.google.com/file/d/1uOX8EaE59dW_bLBx5oC5jpNxNCZn3qxo/view?usp=drive_link',
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      adId: json['item_id'],
      owner_id: json['owner_id'],
      adName: json['title'],
      category: json['category'],
      expired: json['expired'],
      adResourceType: json['item_type'],
      adDate: DateTime.parse(json['created_at']),
      building: json['building'],
      description: json['description'],
      pictures: json['pictures'],
    );
  }
}
