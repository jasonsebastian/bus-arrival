import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://datamall2.mytransport.sg/ltaodataservice';

Future<Response> getArrivalsFromApi(busStopCode) =>
    request('$baseUrl/BusArrivalv2?BusStopCode=$busStopCode');

Future<Response> getArrivalFromApi(busStopCode, serviceNo) => request(
    '$baseUrl/BusArrivalv2?BusStopCode=$busStopCode&ServiceNo=$serviceNo');

Future<Response> request(url) => http.get(Uri.parse(url), headers: {
      'AccountKey': dotenv.env['API_KEY']!,
      'Accept': 'application/json',
    });
