import 'package:express_attendance/Provider/time_provider.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
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
    DateTime dateTime = DateTime.parse("2022-09-12T13:08:18.9570");
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
    if (n >= -10) return "0$n";
    return "$n";

    // switch (unitType) {
    //   case "minutes":
    //     if (widget.format == CountDownTimerFormat.daysHoursMinutes ||
    //         widget.format == CountDownTimerFormat.hoursMinutes ||
    //         widget.format == CountDownTimerFormat.minutesOnly) {
    //       if (difference > Duration.zero) {
    //         n++;
    //       }
    //     }
    //     if (n >= 10) return "$n";
    //     return "0$n";
    //   case "hours":
    //     if (widget.format == CountDownTimerFormat.daysHours ||
    //         widget.format == CountDownTimerFormat.hoursOnly) {
    //       if (difference > Duration.zero) {
    //         n++;
    //       }
    //     }
    //     if (n >= 10) return "$n";
    //     return "0$n";
    //   case "days":
    //     if (widget.format == CountDownTimerFormat.daysOnly) {
    //       if (difference > Duration.zero) {
    //         n++;
    //       }
    //     }
    //     if (n >= 10) return "$n";
    //     return "0$n";
    //   default:
    //     if (n >= 10) return "$n";
    //     return "0$n";
    // }
  }

  Widget separate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Text(":"),
    );
  }

  TextStyle timerStyle = TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold);
}
