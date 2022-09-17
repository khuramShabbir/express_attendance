import 'package:express_attendance/Provider/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimerUp extends StatefulWidget {
  final DateTime dateTime;
  const TimerUp({required this.dateTime, Key? key}) : super(key: key);

  @override
  State<TimerUp> createState() => _TimerUpState();
}

class _TimerUpState extends State<TimerUp> {
  late TimeProvider timeProvider;

  @override
  void initState() {
    DateTime dateTime = DateTime.parse(widget.dateTime.toString());
    DateTime dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime.toString(), true);

    timeProvider = Provider.of<TimeProvider>(context, listen: false);
    timeProvider.startTimer(dateTime: dateFormat.toLocal());
    super.initState();
  }

  @override
  void dispose() {
    timeProvider.timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeProvider>(
      builder: (BuildContext context, timerProv, Widget? child) {
        return Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Duration: ", style: timerStyle),
              Text(twoDigits(timerProv.hours).replaceAll("-", ""), style: timerStyle),
              separate(),
              Text(twoDigits(timerProv.mints).replaceAll("-", ""), style: timerStyle),
              separate(),
              Text(twoDigits(timerProv.seconds).replaceAll("-", ""), style: timerStyle),
            ],
          ),
        );
      },
    );
  }

  String twoDigits(int n) {
    if (n >= -9) return "0$n";
    return "$n";
  }

  Widget separate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Text(":"),
    );
  }

  TextStyle timerStyle = TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold);
}
