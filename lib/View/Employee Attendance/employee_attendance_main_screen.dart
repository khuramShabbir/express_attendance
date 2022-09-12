import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/View/Constant/constant.dart';
import 'package:express_attendance/View/DashBoardScreen/dashboard_scr.dart';
import 'package:express_attendance/View/Employee%20Attendance/office_checkin_checkout.dart';
import 'package:express_attendance/View/Employee%20Attendance/outside_check_in_check_out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeMainScreen extends StatefulWidget {
  const EmployeeMainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeMainScreen> createState() => _EmployeeMainScreenState();
}

class _EmployeeMainScreenState extends State<EmployeeMainScreen> {
  int _selectedValue = 1;
  CustomSegmentedController<int> controller = new CustomSegmentedController();
  late AttendanceProvider atProv;

  @override
  void initState() {
    atProv = Provider.of(context, listen: false);
    atProv.getStatus();
    atProv.getPosition();
    super.initState();
  }

  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    final s = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        bool result = await showExitPopup();

        return result;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AttendanceProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return value.isStatusLoaded
                ? RefreshIndicator(
                    onRefresh: () {
                      value.getPosition();
                      return value.getStatus();
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: s.height * 0.23,
                          width: s.width,
                          color: Colors.indigoAccent,
                          child: ListTile(
                            horizontalTitleGap: 10,
                            contentPadding: EdgeInsets.only(top: 40, left: 20, right: 30),
                            title: const Text(
                              "My Attendance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DashboardScreen()));
                              },
                              child: Container(
                                width: s.width * 0.28,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    "Dashboard",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.indigoAccent),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 120),
                              // height: s.height,
                              width: s.width,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(20), right: const Radius.circular(20)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.only(top: 20, left: 20),
                                            child: Text(
                                              "Your Current Location: ${value.address}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.indigo,
                                                  fontSize: 17),
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  Text(
                                    "Choose your Attendance Mode ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.indigo,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 30),
                                  atProv.attendanceStatusModel!.data.checkInOutType == 2
                                      ? CustomSlidingSegmentedControl<int>(
                                          controller: controller,
                                          initialValue: _selectedValue,
                                          padding: 40,
                                          height: 45,
                                          innerPadding: EdgeInsets.symmetric(horizontal: 0),
                                          children: {
                                            1: Constant.segmented(
                                                text: "Office",
                                                color: _selectedValue == 1
                                                    ? Colors.indigo
                                                    : Colors.white),
                                            2: Constant.segmented(
                                                text: "Out Side",
                                                color: _selectedValue == 2
                                                    ? Colors.indigo
                                                    : Colors.white),
                                          },
                                          decoration: BoxDecoration(
                                            color: Colors.indigoAccent,
                                            borderRadius: BorderRadius.circular(40),
                                            border:
                                                Border.all(color: Colors.indigoAccent, width: 5),
                                            // border: Border.all(color: Colors.black, width: 5),
                                          ),
                                          thumbDecoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          onValueChanged: (v) async {
                                            setState(
                                              () {
                                                _selectedValue = v;
                                              },
                                            );
                                          },
                                        )
                                      : SizedBox(),
                                  SizedBox(height: 20),
                                  buildSegmented(_selectedValue),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget buildSegmented(int? _selectedValue) {
    switch (_selectedValue) {
      case 1:
        return Office();
      case 2:
        return Outside();
      default:
        return Office();
    }
  }
}
