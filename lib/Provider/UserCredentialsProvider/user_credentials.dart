import 'package:express_attendance/Models/user_model.dart';
import 'package:express_attendance/Services/ApiServices/StorageServices/get_storage.dart';
import 'package:express_attendance/Services/ApiServices/api_services.dart';
import 'package:express_attendance/Services/ApiServices/api_urls.dart';
import 'package:express_attendance/UtilsAndConst/const.dart';
import 'package:flutter/cupertino.dart';

class UserCredentialsProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserCredentialsModel? userCredentialsModel;

  Future<bool> verifiedUser() async {
    AppConst.startProgress();
    String response = await ApiServices.getMethodApi(
      "${ApiUrls.VERIFY_USER}?user=${emailController.text.trim()}&password=${passwordController.text.trim()}",
    );

    if (response.isEmpty) {
      AppConst.stopProgress();

      return false;
    }
    ;

    userCredentialsModel = userCredentialsModelFromJson(response);

    if (userCredentialsModel!.data == null) {
      await AppConst.infoSnackBar(userCredentialsModel!.responseMessage);
      AppConst.stopProgress();

      return false;
    } else if (userCredentialsModel!.data != null) {
      await StorageCRUD.saveUser(response);
      AppConst.stopProgress();

      return true;
    }
    return false;
  }

  bool logOut() {
    if (StorageCRUD.box.hasData(StorageKeys.userData)) {
      StorageCRUD.remove(StorageKeys.userData);
    }

    return false;
  }
}
