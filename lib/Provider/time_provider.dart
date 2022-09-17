import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TimeProvider with ChangeNotifier {
  int hours = 00;
  int mints = 00;
  int seconds = 00;
  Timer? timer;

  DateTime? dateTime;

  void startTimer({required dateTime}) {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      hours = dateTime!.difference(DateTime.now()).inHours.remainder(24);
      mints = dateTime!.difference(DateTime.now()).inMinutes.remainder(60);
      seconds = dateTime!.difference(DateTime.now()).inSeconds.remainder(60);
      notifyListeners();
    });
  }

  void stopTime() {
    if (timer != null && timer!.isActive) timer!.cancel();

    dateTime = null;
    notifyListeners();
  }

  void pauseTime() {
    if (timer != null && timer!.isActive) timer!.cancel();
  }

  String nowTime = "";

  void getCurrentTime() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime dateTime = DateTime.now();
      DateFormat format = DateFormat('hh:mm a');
      nowTime = format.format(dateTime);
      notifyListeners();
    });
  }
}
