import '../util/info.dart';

class Stop {
  final String code;
  final String description;
  final double latitude;
  final double longitude;

  Stop.fromJson(this.code, List<dynamic> json)
      : description = json[descriptionIndex],
        latitude = json[latitudeIndex],
        longitude = json[longitudeIndex];
}
