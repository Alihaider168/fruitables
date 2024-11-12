import 'package:fruitables/app/data/core/app_export.dart';

class MyAppAuth{


// Private constructor
  MyAppAuth._internal();

  // Singleton instance
  static final MyAppAuth _instance = MyAppAuth._internal();

  // Factory constructor to return the singleton instance
  factory MyAppAuth() {
    return _instance;
  }

  Future<dynamic> sendOTP(String email, String mobile) async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.post(ApiUtils.sendOTP,
            onSuccess: (response) async {
              print(response);
              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              return false;
            },
            data: {'email': email});
      }
    });
  }

  Future<dynamic> login(String email, String mobile, String otp) async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.post(ApiUtils.login,
            onSuccess: (response) async {
              print(response);
              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              return false;
            },
            data: {
              "email": email,
              "mobile": mobile,
              "otp": otp
            });
      }
    });
  }

  Future<dynamic> signup(String name,String email, String mobile, String otp) async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.post(ApiUtils.register,
            onSuccess: (response) async {
              print(response);
              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              return false;
            },
            data: {
              "name": name,
              "email": email,
              "mobile": mobile,
              "otp": otp
            });
      }
    });
  }


}