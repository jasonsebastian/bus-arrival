import '../model/stop.dart';
import 'distance.dart';
import 'parse.dart';

const stopsWithSelectedServices = {
  // Queenstown, Redhill
  '10201': ['33', '64', '120', '145'],
  '10281': ['51', '111', '186', '970'],
  '10289': ['111'],
  // Clementi
  '17171': ['52', '105', '106', '183'],
  '20109': ['52', '99', '105', '106', '173', '183'],
  // Pioneer, Boon Lay
  '22009': ['179', '187', '199'],
  '22521': ['179'],
  '27211': ['179', '179A'],
  // Jurong East
  '28211': ['990'],
  '28631': ['502'],
  '28639': ['188', '990'],
  // Bukit Batok
  '43009': ['173', '189', '990'],
  '43389': ['173', '187', '189'],
  '43691': ['187'],
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
