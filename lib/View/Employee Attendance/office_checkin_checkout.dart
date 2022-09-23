import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
import 'package:express_attendance/View/Camera%20View/camera_image_view.dart';
import 'package:express_attendance/View/Constant/constant.dart';
import 'package:express_attendance/View/Camera%20View/camera.dart';
import 'package:express_attendance/timer_countUp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Provider/time_provider.dart';
import 'package:get/get.dart';

class Office extends StatefulWidget {
  const Office({
    Key? key,
  }) : super(key: key);

  @override
  State<Office> createState() => _OfficeState();
}

class _OfficeState extends State<Office> {
  @override
  void initState() {
    super.initState();
  }

  bool isCheckedIn = false;

  @override
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
            //TODO:
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

                      if (atProv.xFile != null) await atProv.checkOut();
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
                      bool result = await atProv.getPosition();
                      if (!result) {
                        AppConst.errorSnackBar("Unable to find your location");
                        return;
                      }
                      double dis = await atProv.checkArea();
                      if (dis > 200) {
                        await Get.defaultDialog(
                          title: "Can't Check-in",
                          content: Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Your Distance from office"
                                " ${dis.round()} meter, "
                                "Please Check-in"
                                " from Out Side",
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              MaterialButton(
                                color: Colors.indigo,
                                onPressed: () {
                                  Get.back();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );

                        return;
                      }
                      if (dis < 200) {
                        atProv.xFile = await Get.to(() => CameraApp());
                        if (atProv.xFile == null) return;

                        await atProv.checkIn();
                      }
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
