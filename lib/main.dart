import 'dart:io';
import 'package:express_attendance/Provider/AttendanceProvider/attendance_provider.dart';
import 'package:express_attendance/Provider/UserCredentialsProvider/user_credentials.dart';
import 'package:express_attendance/Provider/time_provider.dart';
import 'package:express_attendance/Splash_scr.dart';
import 'package:express_attendance/View/Camera%20View/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  await WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserCredentialsProvider()),
      ChangeNotifierProvider.value(value: AttendanceProvider()),
      ChangeNotifierProvider.value(value: TimeProvider()),
      ChangeNotifierProvider.value(value: CameraProvider()),
    ],
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    ),
  ));
}
