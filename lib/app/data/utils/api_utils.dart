class ApiUtils {
  static const baseUrl = 'https://coffee-shop-be-production.up.railway.app/v1';
  static const baseUrl1 = '$baseUrl/app-customers';


  static const getRegions = '$baseUrl/mobile-app/getAllBranches?companyId=rexsacafe';
  static const getMenu = '$baseUrl/mobile-app/getBranchMenu/64209654e91634fed32dbd1e';
  static const register = '$baseUrl1/register';
  static const login = '$baseUrl1/login';
  static const addresses = '$baseUrl1/addresses';
  static deleteAddress(String? id) => '$baseUrl1/addresses/$id';
  static const favorites = '$baseUrl1/favorites';
  static const sendOTP = '$baseUrl1/send-otp';
  static const sendOTP1 = '$baseUrl1/send-otp';
  static const addOrder = '$baseUrl1/sales';
  static const getOrders = '$baseUrl1/sales';
  static getOrderDetail(String? id) => '$baseUrl1/sales/$id';

}
