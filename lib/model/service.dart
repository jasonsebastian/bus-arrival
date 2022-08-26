import 'next_bus.dart';

class Service {
  final String serviceNo;
  final NextBus nextBus;

  Service.fromJson(Map<String, dynamic> json)
      : serviceNo = json['ServiceNo'] ?? '',
        nextBus = NextBus.fromJson(json['NextBus']);
}
