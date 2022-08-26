import 'dart:developer';

import 'package:location/location.dart';

Future<LocationData?> updateLocationData() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  var locationData = await location.getLocation();
  log('Updated current location: ${locationData.latitude}, ${locationData.longitude}.');
  return locationData;
}
