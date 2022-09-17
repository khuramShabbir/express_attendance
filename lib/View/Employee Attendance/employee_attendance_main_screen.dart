import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/Provider/time_provider.dart';
import 'package:express_attendance/Services/ApiServices/StorageServices/get_storage.dart';
import 'package:express_attendance/Splash_scr.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
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
    Provider.of<TimeProvider>(context, listen: false).getCurrentTime();

    networkCall();
    super.initState();
  }

  void networkCall() async {
    await atProv.getStatus();
    await atProv.getPosition();
    await atProv.getCurrentAddressFromServer(
        lat: atProv.position!.latitude, lng: atProv.position!.longitude);
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
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            Container(
                              height: s.height * 0.3,
                              width: s.width,
                              color: Colors.indigoAccent,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "My Attendance",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => DashboardScreen()));
                                          },
                                          child: Container(
                                            width: s.width * 0.3,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(30)),
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
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 30,
                                              backgroundColor: Colors.white,
                                              child: Image.asset("assets/person_icon.png"),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Hi , ${StorageCRUD.getUser().data?.employeeName}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              StorageCRUD.remove(StorageKeys.userData);
                                              if (await StorageCRUD.box
                                                  .hasData(StorageKeys.remember))
                                                StorageCRUD.box.remove(StorageKeys.remember);
                                              StorageCRUD.box.erase();
                                              Navigator.pushAndRemoveUntil(
                                                  (context),
                                                  MaterialPageRoute(
                                                      builder: (context) => SplashScreen()),
                                                  (route) => false);
                                              AppConst.successSnackBar("User logout Successfully");
                                            },
                                            icon: Icon(
                                              Icons.logout,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 120),
                                  width: s.width,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[50],
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(20),
                                        right: const Radius.circular(20)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /// office address
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 20),
                                                child: Text(
                                                  "Office Location: ${StorageCRUD.getUser().data!.officeAddress}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.indigo,
                                                      fontSize: 15),
                                                )),
                                          ),
                                        ],
                                      ),

                                      /// current address
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
                                                      fontSize: 15),
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      /// Distance
                                      _selectedValue == 1
                                          ? Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Distance...."),
                                                  Text(
                                                    "${atProv.checkArea().round().toString()} meters",
                                                    style: TextStyle(color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(""),
                                                  Text(""),
                                                ],
                                              ),
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
                                      atProv.attendanceStatusModel!.data == null ||
                                              atProv.attendanceStatusModel!.data!.checkInOutType ==
                                                  2
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
                                                border: Border.all(
                                                    color: Colors.indigoAccent, width: 5),
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

                                      SizedBox(height: 200),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
