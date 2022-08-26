import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

Future<Response> getArrivalsFromApi(busStopCode) =>
    request('BusArrivalv2?BusStopCode=$busStopCode');

Future<Response> getArrivalFromApi(busStopCode, serviceNo) =>
    request('BusArrivalv2?BusStopCode=$busStopCode&ServiceNo=$serviceNo');

Future<Response> request(endpoint) => http.get(
      Uri.parse('http://datamall2.mytransport.sg/ltaodataservice/$endpoint'),
      headers: {
        'AccountKey': dotenv.env['API_KEY']!,
        'Accept': 'application/json',
      },
    );
