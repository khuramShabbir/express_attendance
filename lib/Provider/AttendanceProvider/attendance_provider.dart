import 'dart:io';

import 'package:express_attendance/Models/attendace_status.dart';
import 'package:express_attendance/Models/get_address_model.dart';
import 'package:express_attendance/Services/ApiServices/StorageServices/get_storage.dart';
import 'package:express_attendance/Services/ApiServices/api_services.dart';
import 'package:express_attendance/Services/ApiServices/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xml2json/xml2json.dart';
import '../../UtilsAndConst/const.dart';
import 'package:ftpconnect/ftpConnect.dart';

class AttendanceProvider extends ChangeNotifier {
  ImagePicker imagePicker = ImagePicker();
  final myTransformer = Xml2Json();
  Position? position;
  bool? serviceEnabled;
  LocationPermission? permission;
  List<Placemark>? places;
  List<Placemark>? officePlace;
  String address = "Getting location";
  String fileUrl = "Getting location";

  String officeAddress = "Getting location";
  bool isStatusLoaded = false;
  AttendanceStatusModel? attendanceStatusModel;
  XFile? xFile;

  Future<bool> getStatus({bool showProgress = false}) async {
    await getPosition();
    if (showProgress) AppConst.startProgress();
    String response = await ApiServices.getMethodApi(
        "${ApiUrls.GET_STATUS}?EmployeeID=${StorageCRUD.getUser().data!.employeeId}");
    logger.i(response);
    AppConst.stopProgress();
    if (response.isEmpty) return false;
    attendanceStatusModel = attendanceStatusModelFromJson(response);
    isStatusLoaded = true;
    notifyListeners();
    return true;
  }

  Future<bool> getOfficeAddressFromServer({
    required double lat,
    required double lng,
  }) async {
    String response =
        await ApiServices.getMethodApi("${ApiUrls.GET_ADDRESS}?latitude=$lat&longitude=$lng");
    if (response.isEmpty) return false;

    myTransformer.parse(response);
    String json = myTransformer.toBadgerfish();
    GetAddressModel documentsModel = getAddressModelFromJson(json);
    officeAddress = documentsModel.geocodeResponse.result
        .firstWhere((element) {
          return element.formattedAddress.empty.isNotEmpty;
        })
        .formattedAddress
        .empty;

    /// TODO: get address
    notifyListeners();
    return true;
  }

  Future<bool> getCurrentAddressFromServer({
    required double lat,
    required double lng,
  }) async {
    String response =
        await ApiServices.getMethodApi("${ApiUrls.GET_ADDRESS}?latitude=$lat&longitude=$lng");
    if (response.isEmpty) return false;

    myTransformer.parse(response);
    String json = myTransformer.toBadgerfish();
    GetAddressModel documentsModel = getAddressModelFromJson(json);
    address = documentsModel.geocodeResponse.result
        .firstWhere((element) {
          return element.formattedAddress.empty.isNotEmpty;
        })
        .formattedAddress
        .empty;
    logger.i(officeAddress);

    /// TODO: get address
    notifyListeners();
    return true;
  }

  Future<bool> uploadImage() async {
    AppConst.startProgress();
    FTPConnect ftpConnect = FTPConnect('132.148.73.1', user: 'appftpuser', pass: 'H\$3ipa210');
    try {
      File fileToUpload = File(xFile!.path);
      await ftpConnect.connect();
      bool file = await ftpConnect.uploadFile(fileToUpload);
      logger.i("upload file url  " + file.toString());

      await ftpConnect.disconnect();

      fileUrl = xFile!.path.split('/').last;
      logger.e(fileUrl);
      AppConst.stopProgress();
      return true;
    } catch (e) {
      logger.i("error of ftp" + e.toString());
      AppConst.stopProgress();
    }
    AppConst.stopProgress();

    return false;
  }

  Future<void> checkIn() async {
    await getPosition();
    if (position == null) {
      AppConst.stopProgress();

      AppConst.errorSnackBar("Unable to get Position");

      return;
    }

    bool res = await uploadImage();
    if (!res) {
      AppConst.stopProgress();

      AppConst.errorSnackBar("Unable to Upload Image");

      return;
    }

    AppConst.startProgress();
    Map<String, String> fields = {
      "EmployeeID": "${StorageCRUD.getUser().data!.employeeId}",
      "CheckInOutType": "1",
      "ImageURL": fileUrl,
      "Latitude": position!.latitude.toString(),
      "Longitude": position!.longitude.toString()
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
    bool res = await uploadImage();
    if (!res) {
      AppConst.stopProgress();

      AppConst.errorSnackBar("Unable to Upload Image");
      return;
    }
    AppConst.startProgress();
    Map<String, String> fields = {
      "EmployeeID": "${StorageCRUD.getUser().data!.employeeId}",
      "CheckInOutType": "2",
      "ImageURL": fileUrl,
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
    AppConst.startProgress();

    position = await Geolocator.getCurrentPosition();
    places = await placemarkFromCoordinates(position!.latitude, position!.longitude);
    AppConst.stopProgress();

    notifyListeners();
    return true;
  }

  double checkArea() {
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
