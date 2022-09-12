import 'package:express_attendance/Models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class StorageCRUD {
  static final box = GetStorage();

  static Future write(String key, dynamic value) async {
    await box.write(key, value);
  }

  static Future read(String key) async {
    await box.read(key);
  }

  static Future remove(String key) async {
    await box.remove(key);
  }

  static Future erase() async {
    await box.erase();
  }

  static UserCredentialsModel getUser() {
    UserCredentialsModel userAuthModel =
        userCredentialsModelFromJson(box.read(StorageKeys.userData));
    return userAuthModel;
  }

  static Future<void> saveUser(String data) async {
    await box.write(StorageKeys.userData, data);
  }
}

class StorageKeys {
  static String userData = "userData";
  static String remember = "remember";
}
