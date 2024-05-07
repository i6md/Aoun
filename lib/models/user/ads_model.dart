class AdsModel {
  final String adId;
  final String? adName;
  final String? adResourceType;
  final DateTime? adDate;
  final String? adPlace;
  final List<dynamic>? adImages;
  final String photoUrl;

  // final Boolean expired;
  // final String owner_Id;
  final String? adDescription;
  AdsModel({
    // this.owner_Id,
    required this.adId,
    // this.expired,

    required this.adName,
    required this.adResourceType,
    required this.adDate,
    required this.adPlace,
    required this.adDescription,
    this.adImages,
    this.photoUrl =
        'https://drive.google.com/file/d/1uOX8EaE59dW_bLBx5oC5jpNxNCZn3qxo/view?usp=drive_link',
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      adId: json['item_id'],
      adName: json['title'],
      adResourceType: json['item_type'],
      adDate: DateTime.parse(json['created_at']),
      adPlace: json['description'],
      adDescription: json['description'],
      adImages: json['pictures'],
    );
  }
}
