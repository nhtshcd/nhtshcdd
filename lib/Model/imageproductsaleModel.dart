
class ImageProductSaleModel{
  final String prod_image;
  final String prod_refId;
  final String time;
  final String latitude;
  final String longitude;

  ImageProductSaleModel(
      this.prod_image, this.prod_refId, this.time, this.latitude, this.longitude);

  Map<String, dynamic> toMap() {
    return {
      'image': prod_image,
      'refId': prod_refId,
      'time': time,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}