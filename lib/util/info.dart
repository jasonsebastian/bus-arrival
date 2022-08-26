import '../model/stop.dart';
import 'distance.dart';
import 'parse.dart';

const stopsWithSelectedServices = {
  '10201': ['33', '64', '120', '145'],
  '20109': ['52', '99', '105', '106', '173', '183'],
  '28211': ['990'],
  '43009': ['173', '189', '990'],
  '43389': ['173', '187', '189'],
  '43699': ['176', '187', '188', '990'],
};

const longitudeIndex = 0;
const latitudeIndex = 1;
const descriptionIndex = 2;

Future<Stop> getNearestStop(locationData) async {
  var codes = stopsWithSelectedServices.keys;
  var stops = await getStopsByCodes(codes);
  stops.sort((a, b) {
    var distanceToA = calculateDistanceToStop(locationData, a);
    var distanceToB = calculateDistanceToStop(locationData, b);
    return distanceToA.compareTo(distanceToB);
  });
  return stops.first;
}

List<String> getSelectedServices(code) => stopsWithSelectedServices[code]!;
