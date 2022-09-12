import 'package:express_attendance/Models/attendace_status.dart';
import 'package:express_attendance/Services/ApiServices/StorageServices/get_storage.dart';
import 'package:express_attendance/Services/ApiServices/api_services.dart';
import 'package:express_attendance/Services/ApiServices/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../UtilsAndConst/const.dart';

class AttendanceProvider extends ChangeNotifier {
  ImagePicker imagePicker = ImagePicker();
  Position? position;
  bool? serviceEnabled;
  LocationPermission? permission;
  List<Placemark>? places;
  String address = "";

  bool isStatusLoaded = false;
  AttendanceStatusModel? attendanceStatusModel;

  XFile? xFile;

  Future<bool> getStatus({bool showProgress = false}) async {
    if (showProgress) AppConst.startProgress();
    String response = await ApiServices.getMethodApi(
        "${ApiUrls.GET_STATUS}?EmployeeID=${StorageCRUD.getUser().data!.employeeId}");
    if (showProgress) AppConst.stopProgress();
    if (response.isEmpty) return false;
    attendanceStatusModel = attendanceStatusModelFromJson(response);
    isStatusLoaded = true;
    logger.i(attendanceStatusModel!.data.checkInOutType);
    notifyListeners();
    return true;
  }

  Future<bool> getAddress({required double lat, required double lng}) async {
    AppConst.startProgress();
    String response =
        await ApiServices.getMethodApi("${ApiUrls.GET_ADDRESS}?latitude=$lat&longitude$lng");
    AppConst.stopProgress();
    if (response.isEmpty) return false;

    /// TODO:
    // attendanceStatusModel = attendanceStatusModelFromJson(response);
    isStatusLoaded = true;
    logger.i(attendanceStatusModel!.data.checkInOutType);
    notifyListeners();
    return true;
  }

  Future<void> checkIn() async {
    await getPosition();
    if (position == null) {
      AppConst.errorSnackBar("Unable to get Position");

      return;
    }
    AppConst.startProgress();
    Map<String, String> fields = {
      "EmployeeID": "${StorageCRUD.getUser().data!.employeeId}",
      "CheckInOutType": "1",
      "ImageURL": "https://consussol.com/appftp/sample.png",
      "Latitude": "23.3",
      "Longitude": "125.36"
    };
    String response = await ApiServices.postRawMethodApi(fields, ApiUrls.ATTENDANCE);
    AppConst.stopProgress();

    logger.i(response);
    if (response.isEmpty) return;
    bool status = await getStatus(showProgress: true);
    if (status) AppConst.successSnackBar("Checked In Successfully ");
  }

  Future<void> checkOut() async {
    await getPosition();
    if (position == null) {
      AppConst.errorSnackBar("Unable to get Position");

      return;
    }

    AppConst.startProgress();
    Map<String, String> fields = {
      "EmployeeID": "${StorageCRUD.getUser().data!.employeeId}",
      "CheckInOutType": "2",
      "ImageURL": "https://consussol.com/appftp/sample.png",
      "Latitude": position!.latitude.toString(),
      "Longitude": position!.longitude.toString()
    };

    String response = await ApiServices.postRawMethodApi(fields, ApiUrls.ATTENDANCE);
    AppConst.stopProgress();

    logger.i(response);
    if (response.isEmpty) return;
    bool status = await getStatus(showProgress: true);
    if (status) AppConst.successSnackBar("Checked Out Successfully ");
  }

  Future<bool> getImage() async {
    xFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (xFile == null) return false;
    return true;
  }

  Future<bool> getPosition() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      AppConst.infoSnackBar('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppConst.infoSnackBar('Location services are disabled.');

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppConst.infoSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.');

      return false;
    }
    position = await Geolocator.getCurrentPosition();
    places = await placemarkFromCoordinates(position!.latitude, position!.longitude);
    address = "${places!.first.thoroughfare},${places!.first.locality}";
    logger.e(address);

    notifyListeners();
    return true;
  }

  Future<double> checkArea() async {
    double dis = Geolocator.distanceBetween(
      StorageCRUD.getUser().data!.officeLatitude,
      StorageCRUD.getUser().data!.officeLongitude,
      position!.latitude,
      position!.longitude,
    );
    logger.wtf(dis.round());
    return dis;
  }
}
