import 'dart:convert';
import 'dart:developer';

import 'package:bus_arrival/model/bus_arrivals_resp.dart';
import 'package:flutter/material.dart';

import '../util/datetime.dart';
import '../util/network.dart';
import '../util/parse.dart';

class QuickSearch extends StatefulWidget {
  const QuickSearch({super.key});

  @override
  State<QuickSearch> createState() => _QuickSearchState();
}

class _QuickSearchState extends State<QuickSearch> {
  var _estimatedTimeOfArrival = 'N/A';
  final stopDescriptionController = TextEditingController();
  final serviceNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter text';
    }
    return null;
  }

  Future<void> getEstimatedTimeOfArrival() async {
    var description = stopDescriptionController.text;
    var serviceNo = serviceNoController.text;

    var stopCode = await getStopCodeByDescription(description);
    if (stopCode == null) {
      log('Bus stop $description is not found.');
      resetEstimatedTimeOfArrival();
      return;
    }

    var response = await getArrivalFromApi(stopCode, serviceNo);
    var services = BusArrivalsResp.fromJson(jsonDecode(response.body)).services;
    if (services.isEmpty) {
      log('No services found for bus service $serviceNo on $description.');
      resetEstimatedTimeOfArrival();
      return;
    }

    setState(() {
      _estimatedTimeOfArrival =
          convertArrivalToDatetime(services.first.nextBus.estimatedArrival);
    });
  }

  void resetEstimatedTimeOfArrival() {
    setState(() {
      _estimatedTimeOfArrival = 'N/A';
    });
  }

  @override
  void dispose() {
    stopDescriptionController.dispose();
    serviceNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Search'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: TextFormField(
                controller: stopDescriptionController,
                validator: validateTextField,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Bus stop name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: serviceNoController,
                validator: validateTextField,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Service no',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    getEstimatedTimeOfArrival();
                  } else {
                    resetEstimatedTimeOfArrival();
                  }
                },
                child: const Text(
                  'Get arrival',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                'Estimated time of arrival: $_estimatedTimeOfArrival',
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
