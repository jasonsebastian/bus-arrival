String convertArrivalToDatetime(arrival) {
  var minutes = arrival.difference(DateTime.now()).inMinutes;
  return minutes > 0 ? '$minutes min' : 'Arr';
}
