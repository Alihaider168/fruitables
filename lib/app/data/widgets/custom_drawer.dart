import 'package:flutter/material.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/utils/language_utils.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final RxString selectedLanguage = 'English'.obs;

  final languagePreference = LanguageUtils();

  @override
  void initState() {
    super.initState();
    getLanguage();

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          SizedBox(
            height: getSize(150),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: ColorConstant.primaryPink
              ),
              accountName: MyText(
                title: 'Syed Ali Haider',
                fontSize: 18, fontWeight: FontWeight.bold,
                color: ColorConstant.white,
              ),
              accountEmail: MyText(
                title: '+923076497552',
                fontSize: 14,
                color: ColorConstant.white,
              ),
              // currentAccountPicture: CircleAvatar(
              //   backgroundColor: ColorConstant.yellow,
              //   child: Text(
              //     'S',
              //     style: TextStyle(fontSize: 24, color: Colors.white),
              //   ),
              // ),
            ),
          ),

          // Wallet and Loyalty Points Section
          customTile(icon: Icons.account_balance_wallet,title: "lbl_my_wallet".tr,showPrice: true,price: 0.00),
          customTile(icon: Icons.loyalty,title: "lbl_loyalty_points".tr,showPrice: true,price: 0.00),

          // customTile(icon: Icons.language,title: "lbl_change_language".tr,showArrow: true),
          Container(
            padding: getPadding(bottom: 10,left: 15,right: 15,top: 10),
            child: Row(
              children: [
                Icon(Icons.language),
                SizedBox(width: getSize(15),),
                MyText(
                  title: "lbl_change_language".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                Spacer(),
                Obx(() => DropdownButton<String>(
                  value: selectedLanguage.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedLanguage.value = newValue;
                      _changeLanguage(newValue);
                    }
                  },
                  items: <String>['English', 'اردو']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
              ],
            ),
          ),

          // Menu Items
          customTile(icon: Icons.location_on_outlined,title: "lbl_my_addresses".tr,showArrow: true),
          customTile(icon: Icons.receipt_long,title: "lbl_my_orders".tr,showArrow: true),
          customTile(icon: Icons.favorite_border,title: "lbl_my_favourites".tr,showArrow: true),
          customTile(icon: Icons.support_agent,title: "lbl_support_center".tr,),
          customTile(icon: Icons.exit_to_app,title: "lbl_logout".tr,),
          customTile(icon: Icons.person_remove,title: "lbl_req_account_deletion".tr,),

        ],
      ),
    );
  }

  Widget customTile({required IconData icon,required String title,bool showPrice = false,num price = 0.00,bool showArrow = false,}){
    return Container(
      padding: getPadding(bottom: 10,left: 15,right: 15,top: 10),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: getSize(15),),
          MyText(
            title: title,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          Spacer(),
          showPrice ? Container(
            padding: getPadding(left: 8,right: 8,top: 4,bottom: 4),
            decoration: BoxDecoration(
              color: ColorConstant.yellow,
              borderRadius: BorderRadius.circular(getSize(5)),
            ),
            child: MyText(
              title: '${"lbl_rs".tr} $price',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ) : Offstage(),
          showArrow ? Icon(Icons.chevron_right) : Offstage()
        ],
      ),
    );
  }

  void _changeLanguage(String languageCode) async{
    selectedLanguage.value = languageCode;
    if (languageCode == 'English') {
      Get.updateLocale(Locale('en', 'US'));
    } else if (languageCode == 'اردو') {
      Get.updateLocale(Locale('ur', 'PK'));
    }
    Get.back();
    await languagePreference.saveLanguage(languageCode);
  }

  void getLanguage() async {
    selectedLanguage.value = (await languagePreference.getLanguage())??"English";
  }
}
