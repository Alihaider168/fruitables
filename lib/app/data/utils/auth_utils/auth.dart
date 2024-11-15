import 'package:rexsa_cafe/app/data/core/app_export.dart';

class MyAppAuth{


// Private constructor
  MyAppAuth._internal();

  // Singleton instance
  static final MyAppAuth _instance = MyAppAuth._internal();

  // Factory constructor to return the singleton instance
  factory MyAppAuth() {
    return _instance;
  }

  Future<dynamic> sendOTP(String mobile,{final void Function(dynamic response)? onSuccess,final void Function()? onError}) async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.post(ApiUtils.sendOTP,
            onSuccess: (response) async {
              print(response);
              onSuccess!(response.data);

              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              onError!();
              return false;
            },
            data: {'mobile': mobile});
      }
    });
  }

  Future<dynamic> login( String mobile, String otp,{final void Function(dynamic response)? onSuccess,final void Function()? onError}) async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.post(ApiUtils.login,
            onSuccess: (response) async {
              print(response);
              onSuccess!(response.data);
              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              onError!();
              return false;
            },
            data: {
              "mobile": mobile,
              "otp": otp
            });
      }
    });
  }

  Future<dynamic> signup(String name,String email, String mobile, String otp,{final void Function(dynamic response)? onSuccess,final void Function()? onError}) async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.post(ApiUtils.register,
            onSuccess: (response) async {
              print(response);
              onSuccess!(response.data);
              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              onError!();
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