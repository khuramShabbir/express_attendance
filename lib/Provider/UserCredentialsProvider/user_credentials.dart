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
    String response = await ApiServices.getMethodApi(
      "${ApiUrls.VERIFY_USER}?user=${emailController.text}&password=${passwordController.text}",
    );

    if (response.isEmpty) return false;

    userCredentialsModel = userCredentialsModelFromJson(response);
    AppConst.infoSnackBar(userCredentialsModel!.responseMessage);
    if (userCredentialsModel!.data != null) {
      await StorageCRUD.saveUser(response);

      logger.i(StorageCRUD.getUser().data!.employeeName);
    }
    return true;
  }

  bool logOut() {
    if (StorageCRUD.box.hasData(StorageKeys.userData)) {
      StorageCRUD.remove(StorageKeys.userData);
    }

    return false;
  }
}
