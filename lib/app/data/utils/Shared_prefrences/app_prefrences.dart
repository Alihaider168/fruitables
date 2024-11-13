import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  //------------------------------------------------------------- Preference Constants ------------------------------------------------------------
  // Constants for Preference-Value's data-type
  static const String prefTypeBool = "BOOL";
  static const String prefTypeInteger = "INTEGER";
  static const String prefTypeDouble = "DOUBLE";
  static const String prefTypeString = "STRING";

  late Future _isPreferenceInstanceReady;
  late SharedPreferences _preferences;


  static const String prefUserToken = "USER_TOKEN";
  static const String prefUserData = "USER_DATA";
  static const String prefLoggedIn = "LOGGED_IN";


  //-------------------------------------------------------------------- Singleton ----------------------------------------------------------------------
  // Final static instance of class initialized by private constructor
  static final AppPreferences _instance = AppPreferences._internal();

  // Factory Constructor
  factory AppPreferences() => _instance;

  /// AppPreference Private Internal Constructor -> AppPreference
  /// @param->_
  /// @usage-> Initialize SharedPreference object and notify when operation is complete to future variable.
  AppPreferences._internal() {
    _isPreferenceInstanceReady = SharedPreferences.getInstance()
        .then((preferences) => _preferences = preferences);
  }

  AppPreferences getAppPreferences() {
    return AppPreferences();
  }

  //------------------------------------------------------- Getter Methods -----------------------------------------------------------

  // GETTER for isPreferenceReady future
  Future get isPreferenceReady => _isPreferenceInstanceReady;

  //--------------------------------------------------- Public Preference Methods -------------------------------------------------------------
  void _removeValue(String key) {
    //Remove String
    _preferences.remove(key);
  }

  void setUserData({required String data}) => _setPreference(
      prefName: prefUserData, prefValue: data, prefType: prefTypeString);

  Future<String?> getUserData() async => await _getPreference(
        prefName: prefUserData,
      ); // Check value for NULL. If NULL provide default value as FALSE.

  void setToken({required String data}) => _setPreference(
      prefName: prefUserToken, prefValue: data, prefType: prefTypeString);

  Future<String?> getToken() async => await _getPreference(
        prefName: prefUserToken,
      ); // Check value for NULL. If NULL provide default value as FALSE.

  void setIsLoggedIn({required bool loggedIn}) => _setPreference(
      prefName: prefLoggedIn, prefValue: loggedIn, prefType: prefTypeBool);

  Future<bool?> getIsLoggedIn() async {
    return await _getPreference(prefName: prefLoggedIn);
  }


  //--------------------------------------------------- Private Preference Methods ----------------------------------------------------
  /// @usage -> This is a generalized method to set preferences with required Preference-Name(Key) with Preference-Value(Value) and Preference-Value's data-type.
  void _setPreference(
      {required String prefName,
      required dynamic prefValue,
      required String prefType}) {
    // Make switch for Preference Type i.e. Preference-Value's data-type
    switch (prefType) {
      case prefTypeBool:
        {
          _preferences.setBool(prefName, prefValue);
          break;
        }
      case prefTypeInteger:
        {
          _preferences.setInt(prefName, prefValue);
          break;
        }
      case prefTypeDouble:
        {
          _preferences.setDouble(prefName, prefValue);
          break;
        }
      case prefTypeString:
        {
          _preferences.setString(prefName, prefValue);
          break;
        }
    }
  }

  Future<dynamic> _getPreference({required prefName}) async =>
      _preferences.get(prefName);

  Future<bool> clearPreference() => _preferences.clear();
}
