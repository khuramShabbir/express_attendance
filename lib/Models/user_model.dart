import 'dart:convert';

UserCredentialsModel userCredentialsModelFromJson(String str) =>
    UserCredentialsModel.fromJson(json.decode(str));

class UserCredentialsModel {
  UserCredentialsModel({
    required this.responseMessage,
    this.data,
    required this.isValid,
    required this.error,
    required this.errorDetail,
  });

  String responseMessage;
  Data? data;
  bool isValid;
  bool error;
  dynamic errorDetail;

  factory UserCredentialsModel.fromJson(Map<String, dynamic> json) => UserCredentialsModel(
        responseMessage: json["ResponseMessage"],
        data: json["Data"] != null ? Data.fromJson(json["Data"]) : null,
        isValid: json["IsValid"],
        error: json["Error"],
        errorDetail: json["ErrorDetail"],
      );

  Map<String, dynamic> toJson() => {
        "ResponseMessage": responseMessage,
        "Data": data?.toJson(),
        "IsValid": isValid,
        "Error": error,
        "ErrorDetail": errorDetail,
      };
}

class Data {
  Data({
    required this.employeeId,
    required this.employeeName,
    required this.companyId,
    required this.companyName,
    required this.userName,
    required this.userPswd,
    required this.officeLatitude,
    required this.officeLongitude,
    required this.officeAddress,
    required this.isAdmin,
  });

  int employeeId;
  String employeeName;
  int companyId;
  String companyName;
  String userName;
  dynamic userPswd;
  double officeLatitude;
  double officeLongitude;
  String officeAddress;
  bool isAdmin;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        employeeId: json["EmployeeID"],
        employeeName: json["EmployeeName"],
        companyId: json["CompanyID"],
        companyName: json["CompanyName"],
        userName: json["UserName"],
        userPswd: json["UserPswd"],
        officeLatitude: json["OfficeLatitude"].toDouble(),
        officeLongitude: json["OfficeLongitude"].toDouble(),
        officeAddress: json["OfficeAddress"],
        isAdmin: json["IsAdmin"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "EmployeeName": employeeName,
        "CompanyID": companyId,
        "CompanyName": companyName,
        "UserName": userName,
        "UserPswd": userPswd,
        "OfficeLatitude": officeLatitude,
        "OfficeLongitude": officeLongitude,
        "OfficeAddress": officeAddress,
        "IsAdmin": isAdmin,
      };
}
