import 'service.dart';

class BusArrivalsResp {
  final String busStopCode;
  final List<Service> services;

  BusArrivalsResp.fromJson(Map<String, dynamic> json)
      : busStopCode = json['BusStopCode'] ?? '',
        services = (json['Services'] as List)
            .map((service) => Service.fromJson(service))
            .toList();
}
