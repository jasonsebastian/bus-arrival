class NextBus {
  final DateTime estimatedArrival;
  final double latitude;
  final double longitude;

  NextBus.fromJson(Map<String, dynamic> json)
      : estimatedArrival = DateTime.parse(json['EstimatedArrival']),
        latitude = double.parse(json['Latitude']),
        longitude = double.parse(json['Longitude']);
}
