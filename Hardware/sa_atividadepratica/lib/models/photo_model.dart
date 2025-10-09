class PhotoModel {
  final String path;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final String? city;
  
  PhotoModel({
    required this.path,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    this.city,
  });
  
}
