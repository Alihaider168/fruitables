import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rexsa_cafe/app/data/widgets/custom_snackbar.dart';
import 'package:get/get.dart' as gttt;
import 'package:get/get_utils/get_utils.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../routes/app_pages.dart';
import 'api_exceptions.dart';

class BaseClient {

  static bool isShowingError = false;
  static bool isSessionExpired = false;

  static const commonHeaderValue = "qJCcwiJ62M2wuUjKZPxY";
  static Map<String, dynamic> commonHeader = {
    "x-access-token": commonHeaderValue
  };

  static Future<bool> checkInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  static final Dio _dio = Dio(); //Network.getDio();

  static const Duration TIME_OUT_DURATION =
      Duration(milliseconds: 50000); // in milliseconds
  static Duration TIME_OUT_INT = 50000.milliseconds; // in milliseconds
  // GET request
  static get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    Function? onLoading,
  }) async {
    bool check = await checkInternetConnection();
    if (check == true) {
      print("NET AVAILABLE");
      try {
        print(url);

        // 1) indicate loading state
        onLoading?.call();
        // 2) try to perform http request
        var response = await _dio
            .get(
              url,
              onReceiveProgress: onReceiveProgress,
              queryParameters: queryParameters,
              options: Options(
                headers: headers ?? commonHeader,
              ),
            )
            .timeout(TIME_OUT_DURATION);

        print(response);
        // 3) return response (api done successfully)
        await onSuccess(response);
      } on DioError catch (error) {
        // dio error (api reach the server but not performed successfully
        // no internet connection
        print(error);
        if (error.message!.toLowerCase().contains('socket')) {
          onError?.call(ApiException(
                message: "msg_no_internet".tr,
                url: url,
              )) ??
              _handleError("msg_no_internet".tr);
        }

        // no response
        if (error.response == null) {
          var exception = ApiException(
            url: url,
            message: error.message!,
          );
          return onError?.call(exception) ?? handleApiError(exception);
        }
        // await _appPreferences.getAppPreferences().isPreferenceReady;

        if (error.response?.statusCode == 401) {
          // await _appPreferences.getAppPreferences().clearPreference();
          _handleSessionExpiry();
          // gttt.Get.offAllNamed(Routes.GET_STARTED);
          return;
        }

        // check if the error is 500 (server problem)
        if (error.response?.statusCode == 500) {
          var exception = ApiException(
            message: "msg_server_error".tr,
            url: url,
            statusCode: 500,
          );
          // return onError?.call(exception) ?? handleApiError(exception);
        }

        var exception = ApiException(
            message: error.response!.data['message'],
            url: url,
            statusCode: error.response?.statusCode ?? 404);
        return onError?.call(exception) ?? handleApiError(exception);
      } on SocketException {
        // No internet connection
        onError?.call(ApiException(
              message: "msg_no_internet".tr,
              url: url,
            )) ??
            _handleError("msg_no_internet".tr);
      } on TimeoutException {
        // Api call went out of time
        onError?.call(ApiException(
              message: "msg_server_not_responding".tr,
              url: url,
            )) ??
            _handleError("msg_server_not_responding".tr);
      } catch (error) {
        // unexpected error for example (parsing json error)
        onError?.call(ApiException(
              message: error.toString(),
              url: url,
            )) ??
            _handleError(error.toString());
      }
    } else {
      return false;
    }
  }

  // POST request
  static post(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int total, int progress)?
        onSendProgress, // while sending (uploading) progress
    Function(int total, int progress)?
        onReceiveProgress, // while receiving data(response)
    Function? onLoading,
    dynamic data,
  }) async {
    print(url);
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.post(
        url,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ?? commonHeader,
            receiveTimeout: TIME_OUT_INT,
            sendTimeout: TIME_OUT_INT),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioError catch (error) {
      // dio error (api reach the server but not performed successfully

      // no internet connection
      print(error);

      if (error.response!.data['message'].toLowerCase().contains('socket')) {
        onError?.call(ApiException(
              message: "msg_no_internet".tr,
              url: url,
            )) ??
            _handleError("msg_no_internet".tr);
      }

      // no response
      if (error.response!.data['message'] == null) {
        var exception = ApiException(
          url: url,
          message: error.message!,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      // await _appPreferences.getAppPreferences().isPreferenceReady;

      if (error.response?.statusCode == 401) {
        // await _appPreferences.getAppPreferences().clearPreference();
        _handleSessionExpiry();
        // gttt.Get.offAllNamed(Routes.GET_STARTED);

        return;
      }
      // check if the error is 500 (server problem)
      if (error.response!.statusCode! >= 500) {
        // var exception = ApiException(message: "msg_server_error".tr, url: url, statusCode: 500,);
        // return onError?.call(exception) ?? handleApiError(exception);

        // CustomSnackBar.showCustomErrorToast(message: "msg_server_error".tr);

        return;
      }

      var exception = ApiException(
        message: error.response!.data['message'],
        url: url,
        statusCode: error.response?.statusCode ?? 404,
      );
      return onError?.call(exception) ?? handleApiError(exception);
    } on SocketException {
      // No internet connection
      onError?.call(ApiException(
            message: "msg_no_internet".tr,
            url: url,
          )) ??
          _handleError("msg_no_internet".tr);
    } on TimeoutException {
      // Api call went out of time
      onError?.call(ApiException(
            message: "msg_server_not_responding".tr,
            url: url,
          )) ??
          _handleError("msg_server_not_responding".tr);
    } catch (error) {
      // unexpected error for example (parsing json error)
      onError?.call(ApiException(
            message: error.toString(),
            url: url,
          )) ??
          _handleError(error.toString());
    }
  }

// PATCH request
  static patch(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int total, int progress)?
        onSendProgress, // while sending (uploading) progress
    Function(int total, int progress)?
        onReceiveProgress, // while receiving data(response)
    Function? onLoading,
    dynamic data,
  }) async {
    print(url);
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.patch(
        url,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ?? commonHeader,
            receiveTimeout: TIME_OUT_INT,
            sendTimeout: TIME_OUT_INT),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioError catch (error) {
      // dio error (api reach the server but not performed successfully

      // no internet connection
      print(error);
      // await _appPreferences.getAppPreferences().isPreferenceReady;

      if (error.response?.statusCode == 401) {
        // await _appPreferences.getAppPreferences().clearPreference();
        _handleSessionExpiry();
        // gttt.Get.offAllNamed(Routes.GET_STARTED);
        return;
      }
      if (error.response!.data['message'].toLowerCase().contains('socket')) {
        onError?.call(ApiException(
              message: "msg_no_internet".tr,
              url: url,
            )) ??
            _handleError("msg_no_internet".tr);
      }

      // no response
      if (error.response!.data['message'] == null) {
        var exception = ApiException(
          url: url,
          message: error.message!,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      if (error.response?.statusCode == 401) {
        // await _appPreferences.getAppPreferences().clearPreference();
        _handleSessionExpiry();
        // gttt.Get.offAllNamed(Routes.GET_STARTED);
        return;
      }

      // check if the error is 500 (server problem)
      if (error.response!.statusCode! >= 500) {
        // var exception = ApiException(message: "msg_server_error".tr, url: url, statusCode: 500,);
        // return onError?.call(exception) ?? handleApiError(exception);
        // CustomSnackBar.showCustomErrorToast(message: "msg_server_error".tr);
        return;
      }

      var exception = ApiException(
        message: error.response!.data['message'],
        url: url,
        statusCode: error.response?.statusCode ?? 404,
      );
      return onError?.call(exception) ?? handleApiError(exception);
    } on SocketException {
      // No internet connection
      onError?.call(ApiException(
            message: "msg_no_internet".tr,
            url: url,
          )) ??
          _handleError("msg_no_internet".tr);
    } on TimeoutException {
      // Api call went out of time
      onError?.call(ApiException(
            message: "msg_server_not_responding".tr,
            url: url,
          )) ??
          _handleError("msg_server_not_responding".tr);
    } catch (error) {
      // unexpected error for example (parsing json error)
      onError?.call(ApiException(
            message: error.toString(),
            url: url,
          )) ??
          _handleError(error.toString());
    }
  }

  // PUT request
  static put(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int total, int progress)?
        onSendProgress, // while sending (uploading) progress
    Function(int total, int progress)?
        onReceiveProgress, // while receiving data(response)
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.put(
        url,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ?? commonHeader,
            receiveTimeout: TIME_OUT_INT,
            sendTimeout: TIME_OUT_INT),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioError catch (error) {
      // dio error (api reach the server but not performed successfully
      // no internet connection
      if (error.response!.data['message'].toLowerCase().contains('socket')) {
        onError?.call(ApiException(
              message: "msg_no_internet".tr,
              url: url,
            )) ??
            _handleError("msg_no_internet".tr);
      }

      // no response
      if (error.response!.data['message'] == null) {
        var exception = ApiException(
          url: url,
          message: error.message!,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      // await _appPreferences.getAppPreferences().isPreferenceReady;

      if (error.response?.statusCode == 401) {
        // await _appPreferences.getAppPreferences().clearPreference();
        _handleSessionExpiry();
        // gttt.Get.offAllNamed(Routes.GET_STARTED);
        return;
      }
      // check if the error is 500 (server problem)
      if (error.response?.statusCode == 500) {
        var exception = ApiException(
          message: "msg_server_error".tr,
          url: url,
          statusCode: 500,
        );
        // return onError?.call(exception) ?? handleApiError(exception);
      }

      var exception = ApiException(
        message: error.response!.data['message'],
        url: url,
        statusCode: error.response?.statusCode ?? 404,
      );
      return onError?.call(exception) ?? handleApiError(exception);
    } on SocketException {
      // No internet connection
      onError?.call(ApiException(
            message: "msg_no_internet".tr,
            url: url,
          )) ??
          _handleError("msg_no_internet".tr);
    } on TimeoutException {
      // Api call went out of time
      onError?.call(ApiException(
            message: "msg_server_not_responding".tr,
            url: url,
          )) ??
          _handleError("msg_server_not_responding".tr);
    } catch (error) {
      // unexpected error for example (parsing json error)
      onError?.call(ApiException(
            message: error.toString(),
            url: url,
          )) ??
          _handleError(error.toString());
    }
  }

  // DELETE request
  static delete(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ?? commonHeader,
            receiveTimeout: TIME_OUT_INT,
            sendTimeout: TIME_OUT_INT),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioError catch (error) {
      // dio error (api reach the server but not performed successfully
      // no internet connection
      if (error.message!.toLowerCase().contains('socket')) {
        onError?.call(ApiException(
              message: "msg_no_internet".tr,
              url: url,
            )) ??
            _handleError("msg_no_internet".tr);
      }

      // no response
      if (error.response == null) {
        var exception = ApiException(
          url: url,
          message: error.message!,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      // await _appPreferences.getAppPreferences().isPreferenceReady;

      if (error.response?.statusCode == 401) {
        // await _appPreferences.getAppPreferences().clearPreference();
        _handleSessionExpiry();
        // gttt.Get.offAllNamed(Routes.GET_STARTED);

        return;
      }
      // check if the error is 500 (server problem)
      if (error.response?.statusCode == 500) {
        var exception = ApiException(
          message: "msg_server_error".tr,
          url: url,
          statusCode: 500,
        );
        // return onError?.call(exception) ?? handleApiError(exception);
      }

      var exception = ApiException(
        message: error.message!,
        url: url,
        statusCode: error.response?.statusCode ?? 404,
      );
      return onError?.call(exception) ?? handleApiError(exception);
    } on SocketException {
      // No internet connection
      onError?.call(ApiException(
            message: "msg_no_internet".tr,
            url: url,
          )) ??
          _handleError("msg_no_internet".tr);
    } on TimeoutException {
      // Api call went out of time
      onError?.call(ApiException(
            message: "msg_server_not_responding".tr,
            url: url,
          )) ??
          _handleError("msg_server_not_responding".tr);
    } catch (error) {
      // unexpected error for example (parsing json error)
      onError?.call(ApiException(
            message: error.toString(),
            url: url,
          )) ??
          _handleError(error.toString());
    }
  }

  /// download file
  static download(
      {required String url, // file url
      required String savePath, // where to save file
      Function(ApiException)? onError,
      Function(int value, int progress)? onReceiveProgress,
      required Function onSuccess}) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
            receiveTimeout: 999999.milliseconds,
            sendTimeout: 999999.milliseconds),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  /// handle error automaticly (if user didnt pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason
  static handleApiError(ApiException apiException) {
    if (!isShowingError &&
        !apiException.message.contains(
            "Looking up a deactivated widget's ancestor is unsafe.") &&
        !apiException.message.contains("Overlay")) {
      isShowingError = true;
      String msg =
          apiException.response?.data?['message'] ?? apiException.message;
      print(apiException.response?.data);
      CustomSnackBar.showCustomErrorToast(message: msg);
      Future.delayed(const Duration(seconds: 3), () => isShowingError = false);
    }
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    CustomSnackBar.showCustomErrorToast(message: msg);
  }

  static addToken(token) {
    print("token: $token");
    return commonHeader.addAll({"Authorization": "Bearer $token"});
  }

  static removeToken() {
    commonHeader.remove("Authorization");
  }

  /// handle session expiry toast
  static _handleSessionExpiry() {
    if (!isSessionExpired) {
      isSessionExpired = true;
      CustomSnackBar.showCustomErrorToast(message: "session_expired".tr);
    }
  }
}
