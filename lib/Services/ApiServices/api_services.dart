import 'dart:convert';

import 'package:express_attendance/Services/ApiServices/api_urls.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<String> getMethodApi(String feedUrl) async {
    http.Request request = await http.Request('GET', Uri.parse(ApiUrls.BASE_URL + feedUrl));

    http.StreamedResponse response = await request.send();
    String res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return res;
    } else {
      logger.e(res);
      AppConst.errorSnackBar("Something Went Wrong, try again later");
      return "";
    }
  }

  static Future<String> postRawMethodApi(Map<String, String> body, String feedurl) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(ApiUrls.BASE_URL + feedurl));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    logger.i(response.statusCode);
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return "";
    }
  }

  // static Future<String> postMethodApi(
  //     {Map<String, String>? fields, String? files, required String feedUrl}) async {
  //   Map<String, String> headers = {'Content-Type': 'application/json'};
  //   AppConst.startProgress();
  //   http.MultipartRequest request =
  //       http.MultipartRequest('POST', Uri.parse(ApiUrls.BASE_URL + feedUrl));
  //   if (fields != null) request.fields.addAll(fields);
  //   if (files != null) request.files.add(await http.MultipartFile.fromPath('ImageURL', files));
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   AppConst.stopProgress();
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     String result = await response.stream.bytesToString();
  //     logger.i(result);
  //     return result;
  //   } else {
  //     String result = await response.stream.bytesToString();
  //     dynamic parsed = jsonDecode(result);
  //     await AppConst.errorSnackBar("${response.statusCode} ${parsed["message"]}");
  //
  //     logger.e(parsed);
  //
  //     return "";
  //   }
  // }
}
