// ignore_for_file: constant_identifier_names

import 'package:rexsa_cafe/app/data/core/app_export.dart';
import 'package:rexsa_cafe/app/data/models/city_model.dart';
import 'package:rexsa_cafe/app/data/models/menu_model.dart';
import 'package:rexsa_cafe/app/data/models/orders_model.dart';
import 'package:rexsa_cafe/app/data/models/user_model.dart';

class Constants {

  static const int otpLength = 6;
  static const int EMAIL_VALIDATION = 35;
  static const int NAME_VALIDATION = 20;
  static const int NAME_MIN_VALIDATION = 2;
  static const int PASSWORD_MIN_VALIDATION = 8;
  static const int PASSWORD_VALIDATION = 15;
  static const int PHONE_MIN_VALIDATION = 10;
  static const int PHONE_VALIDATION = 15;
  static const int MAX_INPUT_LIMIT = 30;
  static const int refreshDelay = 800;
  static const int MAX_IMAGE_SIZE = 3; // in Mbs
  static const int DELIVERY_FEES = 0; // in Mbs
  static const String paramCheckout = 'checkout';
  static const String fatoorahToken = 'JWbF302shVkN7_EcCW25joW02cxhd7L9qG2-_-RLQcowRCJe_DJM7HLXWsAvsRTuCtHeWfMNHzrIVUQlRZNbRI_Nx1E8HKNvgOIiZ70tPgYcjOj-JIJMDtDl_J3kVQ_E8iU-Nr_bjZEDggW-sFtDdyyOrP0aoDi0qyLfWtKRerGSQSDZWKJoL_XlTbP5VJUph3NznUFN5F5TQbwjahI_gTAWBmXBTC6lqNernUE-929zI4h8InRny9YaMxo1WxalJsRuSlIZnoaeYImM1HbqLsrHDvoo263PKmfNad6hCtJ7dT7AEuJHgkDd2WjETzKAZ6zuFvSe8qPD0k-YsWxQytveKFNJb1YmK6FRy2KCKVo8scc0VeUk4DcZ_NUunxKT6swANqujJXASG4aYdzfCh1jPduX1kNEFdo9uX931eCIvWPRqcOmmu5mDBoiGwZhwJ6PzIfB6L7BgmxQibKvMHBkGHtIHyeXJYdRa2cReJ1zUq_1n5gVdQH9z0t5MBl-MWhbPOd3V08bA37yIGWMR3x183ejfaghfnMIIA3sIJ5SOELPRDoDgeMXI1wMZ-mVjTLGDg2_dywZdJJoI2aZUEtB848aCYmJ368CiyOUzAstPy6A70UFLPcLtyIl9FrRdSg_GmIrzZ-l0I5Q1qgVrTHPNecpXCCh9gLJ76iZWNzR75YJfJvvwsI8eQnby76qIz0nmQQ';
  static const String fatoorahTestToken = 'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL';

  static RxBool isLoggedIn = false.obs;
  static RxBool isDelivery = true.obs;

  static UserModel? userModel;

  static List<Items?> menuItems =[];

  static bool showToast = true;
  static bool showNoInternetToast = false;

  static const debounceDuration = Duration(milliseconds: 1000);

  static Cities? selectedCity;
  static OrderBranch? selectedBranch;



}
