import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
import 'package:express_attendance/View/Constant/constant.dart';
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
    DateTime dateTime = DateTime.now();
    DateFormat format = DateFormat('hh:mm a');
    final nowTime = format.format(dateTime);

    return Container(
      child: Consumer<TimeProvider>(
        builder: (BuildContext context, timeProv, Widget? child) {
          return Consumer<AttendanceProvider>(
            builder: (BuildContext context, atProv, Widget? child) {
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
                  SizedBox(height: 10),
                  Text(nowTime,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.indigo, fontSize: 18)),
                  SizedBox(height: 20),
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
                  SizedBox(height: 10),
                  //TODO:
                  if (isCheckedIn)
                    TimerUp(dateTime: atProv.attendanceStatusModel!.data.checkInOut.toLocal()),
                  SizedBox(
                    height: 30,
                  ),

                  isCheckedIn
                      ? InkWell(
                          onTap: () async {
                            bool result = await atProv.getImage();
                            logger.i(result);

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
                            bool result = await atProv.getPosition();
                            double dis = await atProv.checkArea();
                            bool image = await atProv.getImage();
                            if (!image) return;

                            if (dis > 200) {
                              await Get.defaultDialog(
                                  title: "Can't Check-in",
                                  content: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        "Your Distance from office ${dis.round()} meter, Please Check-in from Out Side",
                                        style: TextStyle(
                                            color: Colors.red, fontWeight: FontWeight.bold),
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
                                  ));

                              return;
                            }

                            if (result && dis < 200) await atProv.checkIn();
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
        },
      ),
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
