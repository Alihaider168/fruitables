import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/favourite_model.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:fruitables/app/modules/main_menu/controllers/main_menu_controller.dart';

class FavUtils{

  RxList<Items?> favItems = <Items?>[].obs;
  RxList<String?> productIds = <String?>[].obs;

// Private constructor
  FavUtils._internal();

  // Singleton instance
  static final FavUtils _instance = FavUtils._internal();

  // Factory constructor to return the singleton instance
  factory FavUtils() {
    return _instance;
  }

  Future<dynamic> addOrRemoveFav(String? id,{final void Function(dynamic response)? onSuccess,final void Function()? onError}) async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.post(ApiUtils.favorites,
            onSuccess: (response) async {
              print(response);
              getFavourites();
              // onSuccess!(response.data);

              return true;
            },
            onError: (error) {
              BaseClient.handleApiError(error);
              // onError!();
              return false;
            },
            headers: Utils.getHeader(),
            data: {'productId': id});
      }
    });
  }

  Future<dynamic> getFavourites() async {
    Utils.check().then((value) async {
      if (value) {
        await BaseClient.get(ApiUtils.favorites,
            onSuccess: (response) async {
              print(response);
              FavouriteModel model = FavouriteModel.fromJson(response.data);
              favItems.clear();
              getFavItemsFromIds(model.products??[]);

              productIds.clear();
              productIds.addAll(model.products??[]);
              productIds.refresh();

              return true;
            },
            onError: (error) {
              // BaseClient.handleApiError(error);
              return false;
            },
          headers: Utils.getHeader()
        );
      }
    });
  }


  void getFavItemsFromIds(List<String> products){
    favItems.value.clear();
    favItems.value.addAll(Constants.menuItems.where((item) {
      return products.contains(item?.id);
    }).toList());
    favItems.refresh();
  }


}