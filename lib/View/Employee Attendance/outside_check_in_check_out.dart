import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/Provider/time_provider.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
import 'package:express_attendance/View/Camera%20View/camera_image_view.dart';
import 'package:express_attendance/View/Constant/constant.dart';
import 'package:express_attendance/View/Camera%20View/camera.dart';
import 'package:express_attendance/timer_countUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Consumer<AttendanceProvider>(
      builder: (BuildContext context, atProv, Widget? child) {
        if (atProv.attendanceStatusModel!.data == null) {
          isCheckedIn = false;
        } else if (atProv.attendanceStatusModel!.data!.checkInOutType == 1) {
          isCheckedIn = true;
        } else {
          isCheckedIn = false;
        }
        return Column(
          children: [
            Text(
              "${Constant.greetingMessage()}",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 28),
            ),
            SizedBox(height: 10),
            Consumer<TimeProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return Text(
                  value.nowTime,
                  style: TextStyle(fontWeight: FontWeight.w400, color: Colors.indigo, fontSize: 18),
                );
              },
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            if (isCheckedIn)
              Consumer<TimeProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return TimerUp(dateTime: atProv.attendanceStatusModel!.data!.checkInOut);
                },
              ),
            SizedBox(height: 20),
            isCheckedIn
                ? InkWell(
                    onTap: () async {
                      atProv.xFile = await Get.to(() => CameraApp());

                      logger.e(atProv);

                      if (atProv.xFile == null)
                        return;
                      else {
                        await atProv.checkOut();
                      }
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
                      atProv.xFile = await Get.to(() => CameraApp());

                      if (atProv.xFile != null) await atProv.checkIn();
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
    );
  }

  Widget timeFormat(AttendanceProvider attendanceProvider) {
    DateTime dateTimeCheckIn = attendanceProvider.attendanceStatusModel!.data!.checkInOut;

    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTimeCheckIn.toString(), true);

    DateFormat format = DateFormat('hh:mm a');

    final clockString = format.format(dateTime.toLocal());
    return Row(
      children: [
        Text(
          "CheckIn Time:  ${clockString}",
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
