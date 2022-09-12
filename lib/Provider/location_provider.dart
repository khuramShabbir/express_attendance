// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
//
// class LocationProv extends ChangeNotifier {
//   Logger logger = Logger();
//   Position? position;
//   String location = '';
//   String Address = '';
//   double dis = 0.0;
//
//   Future<Position?> getGeoLocationPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best, timeLimit: Duration(seconds: 10));
//   }
//
//   Future<Position?> getLocation() async {
//     position = await getGeoLocationPosition();
//     location = 'Lat: ${position!.latitude} , Long: ${position!.longitude}';
//
//     if (position == null) return null;
//
//     return position!;
//   }
//
//   /// it will return in Meters
//   bool calculateDistance({
//     required userLat,
//     required userLong,
//   }) {
//     // if (MySharedPreference.getLat() == null || MySharedPreference.getLng() == null) {
//     //   return false;
//     // }
//     // double officeLat = double.parse(MySharedPreference.getLat()!);
//     // double officeLong = double.parse(MySharedPreference.getLng()!);
//
//     var p = 0.017453292519943295;
//     var a = 0.5 -
//         cos((userLat - officeLat) * p) / 2 +
//         cos(officeLat * p) * cos(userLat * p) * (1 - cos((userLong - officeLong) * p)) / 2;
//     dis = 12742 * asin(sqrt(a)) * 1000;
//     notifyListeners();
//
//     /// meters .....
//     logger.i(dis);
//
//     if (dis > 200) return false;
//
//     return true;
//   }
// }
