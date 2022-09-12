import 'package:flutter/cupertino.dart';

class TimeDuration extends ChangeNotifier{

String time="";
// late Stopwatch stopwatch;

String get()=>time;

void startTime( Stopwatch stopwatch){

  if(stopwatch.isRunning){
    stopwatch.stop();

  }
  else{
    stopwatch.start();
  }
  notifyListeners();
}

void returnFormattedText(Stopwatch stopwatch) {
  var milli = stopwatch.elapsed.inMilliseconds;
  var hour=stopwatch.elapsed.inHours;

  String milliseconds = (milli % 1000).toString().padLeft(3, "0");
  String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
  String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");
  String hours = ((milli ~/ 1000) ~/ 3600).toString().padLeft(2, "0");
    time="$hours:$minutes:$seconds";
  // return "$minutes:$seconds:$milliseconds";
notifyListeners();
}





}