import 'package:express_attendance/Services/ApiServices/StorageServices/get_storage.dart';
import 'package:express_attendance/Splash_scr.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
import 'package:express_attendance/View/Attendance%20_report/attendance_report_scr.dart';
import 'package:express_attendance/View/Constant/constant.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: s.height * 0.2,
                  width: s.width,
                  color: Colors.indigoAccent,
                  child: Column(
                    children: [
                      ListTile(
                          horizontalTitleGap: 10,
                          contentPadding: EdgeInsets.only(top: 40, left: 20, right: 30),
                          leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Colors.white,
                            child: Image.asset("assets/person_icon.png"),
                          ),
                          title: Text(
                            "Hi , ${StorageCRUD.getUser().data?.employeeName}",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: Colors.white, fontSize: 16),
                          ),
                          subtitle: Text(
                            "${Constant.greetingMessage()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
                          ),
                          trailing: IconButton(
                              onPressed: () async {
                                StorageCRUD.remove(StorageKeys.userData);
                                if (await StorageCRUD.box.hasData(StorageKeys.remember))
                                  StorageCRUD.box.remove(StorageKeys.remember);
                                StorageCRUD.box.erase();
                                Navigator.pushAndRemoveUntil(
                                    (context),
                                    MaterialPageRoute(builder: (context) => SplashScreen()),
                                    (route) => false);
                                AppConst.successSnackBar("User logout Successfully");
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 160),
                  child: Container(
                    height: s.height,
                    width: s.width,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20), right: const Radius.circular(20)),
                    ),
                    child: Column(),
                  ),
                ),
                Positioned.fill(
                  top: 180,
                  child: Container(
                    width: s.width,
                    height: s.height * 0.4,
                    child: GridView.builder(
                      primary: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.3,
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 13,
                      ),
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: index == 0
                              ? EdgeInsets.only(left: 10, right: 10)
                              : index + 1 == 2
                                  ? EdgeInsets.only(left: 10, right: 10)
                                  : EdgeInsets.only(left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              if (index == 1) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AttendanceReport()));
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    child: Image.asset(
                                      index == 0
                                          ? "assets/employee_icon.png"
                                          : "assets/attendance_icon.png",
                                    ),
                                    height: 60,
                                    width: 120,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    index == 0 ? "Employee Attendance" : " Attendance Report",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
