import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bus_arrival/route/quick_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../model/bus_arrivals_resp.dart';
import '../util/datetime.dart';
import '../util/distance.dart';
import '../util/info.dart';
import '../util/location.dart';
import '../util/network.dart';

class BusArrivals extends StatefulWidget {
  const BusArrivals({super.key});

  @override
  State<BusArrivals> createState() => _BusArrivalsState();
}

class _BusArrivalsState extends State<BusArrivals> {
  var _description = '';
  var _distanceToStop = '';
  final Map<String, DateTime> _arrivals = {};
  LocationData? _locationData;
  var _shouldUpdateLocation = false;

  @override
  void initState() {
    super.initState();
    loadArrivals();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      loadArrivals();
    });
  }

  Future<void> loadArrivals() async {
    if (_locationData == null || _shouldUpdateLocation) {
      _locationData = await updateLocationData();
      _shouldUpdateLocation = false;
    }
    if (_locationData == null) {
      return;
    }
    loadArrivalsWithLocationData(_locationData);
  }

  Future<void> loadArrivalsWithLocationData(locationData) async {
    var stop = await getNearestStop(locationData);
    var selectedServices = getSelectedServices(stop.code);
    var response = await getArrivalsFromApi(stop.code);

    setState(() {
      _description = stop.description;

      _distanceToStop =
          '(${calculateDistanceToStop(locationData, stop).round()}m)';

      _arrivals.clear();
      var services =
          BusArrivalsResp.fromJson(jsonDecode(response.body)).services;
      for (var service in services) {
        if (selectedServices.contains(service.serviceNo)) {
          _arrivals.putIfAbsent(
            service.serviceNo,
            () => service.nextBus.estimatedArrival,
          );
        }
      }
    });

    log('Loaded data for bus stop ${stop.description} at '
        '${DateFormat.Hms().format(DateTime.now())}.');
  }

  @override
  Widget build(BuildContext context) {
    final serviceNos = _arrivals.keys.toList();

    final arrivals = _arrivals.values.map(convertArrivalToDatetime).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Arrivals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuickSearch()),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadArrivals,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Nearest bus stop: $_description $_distanceToStop',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, i) => Row(
                  children: [
                    Expanded(
                      child: Text(
                        serviceNos[i],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(arrivals[i], style: const TextStyle(fontSize: 16)),
                  ],
                ),
                separatorBuilder: (context, i) => const Divider(height: 32),
                itemCount: _arrivals.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _shouldUpdateLocation = true;
          loadArrivals();
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }
}
