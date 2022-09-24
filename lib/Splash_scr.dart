import 'dart:async';

import 'package:express_attendance/View/Authentication/login.dart';
import 'package:express_attendance/View/Employee%20Attendance/employee_attendance_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Services/ApiServices/StorageServices/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future loadData() async {
    Timer(
      Duration(seconds: 3),
      () async {
        if (await StorageCRUD.box.hasData(StorageKeys.remember) &&
            StorageCRUD.box.read(StorageKeys.remember))
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeMainScreen(),
            ),
          );
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Attendance App",
            style: TextStyle(
              fontSize: 28,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          )),
        ],
      ),
    );
  }
}
