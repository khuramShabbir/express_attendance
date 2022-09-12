import 'dart:convert';

AttendanceStatusModel attendanceStatusModelFromJson(String str) =>
    AttendanceStatusModel.fromJson(json.decode(str));

String attendanceStatusModelToJson(AttendanceStatusModel data) => json.encode(data.toJson());

class AttendanceStatusModel {
  AttendanceStatusModel({
    required this.responseMessage,
    required this.data,
    required this.isValid,
    required this.error,
    required this.errorDetail,
  });

  String responseMessage;
  Data data;
  bool isValid;
  bool error;
  dynamic errorDetail;

  factory AttendanceStatusModel.fromJson(Map<String, dynamic> json) => AttendanceStatusModel(
        responseMessage: json["ResponseMessage"],
        data: Data.fromJson(json["Data"]),
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseMessage": responseMessage,
        "Data": data.toJson(),
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
}

class Data {
  Data({
    required this.employeeId,
    required this.checkInOut,
    required this.checkInOutType,
  });

  int employeeId;
  DateTime checkInOut;
  int checkInOutType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        employeeId: json["EmployeeID"],
        checkInOut: DateTime.parse(json["CheckInOut"]),
        checkInOutType: json["CheckInOutType"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "CheckInOut": checkInOut.toIso8601String(),
        "CheckInOutType": checkInOutType,
      };
}
