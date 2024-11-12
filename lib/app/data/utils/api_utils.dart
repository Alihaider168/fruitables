class ApiUtils {
  static const baseUrl = 'https://coffee-shop-be-production.up.railway.app/v1';


  static const getRegions = '$baseUrl/mobile-app/getAllBranches?companyId=rexsacafe';
  static const getMenu = '$baseUrl/mobile-app/getBranchMenu/64209654e91634fed32dbd1e';
  static const register = '$baseUrl/app-customers/register';
  static const login = '$baseUrl/app-customers/login';
  static const addresses = '$baseUrl/app-customers/addresses';
  static const favorites = '$baseUrl/app-customers/favorites';
  static const sendOTP = '$baseUrl/app-customers/send-otp';
  static const sendOTP1 = '$baseUrl/app-customers/send-otp';
  static customers(String customerId) => '$baseUrl/app-customers/$customerId';

}
