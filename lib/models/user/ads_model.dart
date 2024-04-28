class AdsModel
{
  // final String adId;
  final String adName;
  final String adResourceType;
  final String adDate;
  final String adPlace;
  final String photoUrl;
  // final Boolean expired;
  // final String owner_Id;
  // final String ad_Description;
  AdsModel({
    // this.owner_Id,
    // this.adId,
    // this.expired,
    // this.ad_Description,
    required this.adName,
    required this.adResourceType,
    required this.adDate,
    required this.adPlace,
    this.photoUrl='https://drive.google.com/file/d/1uOX8EaE59dW_bLBx5oC5jpNxNCZn3qxo/view?usp=drive_link'
});
}