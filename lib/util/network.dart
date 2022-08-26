import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://datamall2.mytransport.sg/ltaodataservice';

Future<Response> getArrivalFromApi(busStopCode, serviceNo) => http.get(
      Uri.parse(
          '$baseUrl/BusArrivalv2?BusStopCode=$busStopCode&ServiceNo=$serviceNo'),
      headers: {
        'AccountKey': dotenv.env['API_KEY']!,
        'Accept': 'application/json',
      },
    );
