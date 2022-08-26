import 'dart:math' show asin, cos, sqrt;

double calculateDistanceToStop(locationData, stop) => calculateDistanceInMeters(
      locationData.latitude,
      locationData.longitude,
      stop.latitude,
      stop.longitude,
    );

double calculateDistanceInMeters(lat1, lon1, lat2, lon2) {
  const p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742000 * asin(sqrt(a));
}
