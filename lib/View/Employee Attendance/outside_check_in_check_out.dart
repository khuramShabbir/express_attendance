import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/Provider/time_provider.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
import 'package:express_attendance/View/Constant/constant.dart';
import 'package:express_attendance/timer_countUp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Outside extends StatefulWidget {
  Outside({
    Key? key,
  }) : super(key: key);

  @override
  State<Outside> createState() => _OutsideState();
}

class _OutsideState extends State<Outside> {
  bool isCheckedIn = false;

  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    DateTime dateTime = DateTime.now();
    DateFormat format = DateFormat('hh:mm a');
    final nowTime = format.format(dateTime);

    return Consumer<AttendanceProvider>(
      builder: (BuildContext context, atProv, Widget? child) {
        return Container(
          child: Consumer<TimeProvider>(
            builder: (BuildContext context, timeProv, Widget? child) {
              if (atProv.attendanceStatusModel!.data.checkInOutType == 1) {
                isCheckedIn = true;
              } else {
                isCheckedIn = false;
              }

              return Column(
                children: [
                  Text(
                    "${Constant.greetingMessage()}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 28),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    nowTime,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, color: Colors.indigo, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 20, bottom: 20),
                          child: isCheckedIn
                              ? timeFormat(atProv)
                              : Text(
                                  "CheckIn Time:    ------/------ ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 2,
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (isCheckedIn) TimerUp(dateTime: atProv.attendanceStatusModel!.data.checkInOut),
                  SizedBox(
                    height: 20,
                  ),
                  isCheckedIn
                      ? InkWell(
                          onTap: () async {
                            bool result = await atProv.getImage();
                            if (result) await atProv.checkOut();
                          },
                          child: CircleAvatar(
                            maxRadius: 100,
                            backgroundColor: Colors.red,
                            child: Text(
                              "Check-out",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            bool result = await atProv.getImage();

                            if (result) await atProv.checkIn();
                          },
                          child: CircleAvatar(
                            maxRadius: 100,
                            backgroundColor: Colors.teal.shade400,
                            child: Text(
                              "Check-in",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, color: Colors.white, fontSize: 23),
                            ),
                          ),
                        )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget timeFormat(AttendanceProvider attendanceProvider) {
    DateTime dateTime = attendanceProvider.attendanceStatusModel!.data.checkInOut;
    DateFormat format = DateFormat('hh:mm a');
    final clockString = format.format(dateTime);

    return Row(
      children: [
        Text(
          "CheckIn Time:    ${clockString}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
              fontSize: 18,
              overflow: TextOverflow.ellipsis),
          maxLines: 2,
        ),
      ],
    );
  }
}
