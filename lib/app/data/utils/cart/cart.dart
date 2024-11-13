import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';
import 'package:get/get.dart';

class CartItem {
  Items item;
  String size; // 'small', 'medium', or 'large'
  int quantity;

  CartItem({required this.item, required this.size, this.quantity = 0});

  // Convert CartItem to Map for JSON encoding
  Map<String, dynamic> toMap() {
    return {
      'item': item.toJson(), // Assuming item also has toMap() method
      'size': size,
      'quantity': quantity,
    };
  }

  // Create a CartItem from a Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      item: Items.fromJson(map['item']), // Assuming Items has fromMap() method
      size: map['size'],
      quantity: map['quantity'],
    );
  }
}

class Cart {
  RxList<CartItem> _cartItems = <CartItem>[].obs;

  static const String cartKey = 'cart_items';

  // Add an item to the cart with specified size
  void addItem(Items item, String size, int quantity) {
    bool itemExists = false;

    for (var cartItem in _cartItems) {
      // Check if the item and size already exist in the cart
      if (cartItem.item.id == item.id && cartItem.size == size) {
        // If exists, increase the quantity
        cartItem.quantity += quantity;
        itemExists = true;

        break;
      }
    }

    // If item and size don't exist, add the new item to the cart
    if (!itemExists) {
      _cartItems.add(CartItem(item: item, size: size,quantity: quantity));
    }

    getTotalDiscountedPrice();
    saveCartToPreferences();
  }

  // Remove an item from the cart by ID
  void removeItem(int index,) {
    if(_cartItems[index].quantity > 1){
      _cartItems[index].quantity -=1;
    }else{
      _cartItems.removeAt(index);
    }
    saveCartToPreferences();
    // _cartItems.removeWhere((cartItem) => cartItem.item.id == id && cartItem.size == size);
  }

  // Get the total price of items in the cart
  num getTotalPrice() {
    num totalPrice = 0;
    for (var cartItem in _cartItems) {
      if (cartItem.size == 'small') {
        totalPrice += (cartItem.item.smallPrice ?? 0);
      } else if (cartItem.size == 'medium') {
        totalPrice += (cartItem.item.mediumPrice ?? 0);
      } else if (cartItem.size == 'large') {
        totalPrice += (cartItem.item.largePrice ?? 0);
      }else if (cartItem.size == 'bottle') {
        totalPrice += (cartItem.item.bottlePrice ?? 0);
      }
    }
    return totalPrice;
  }

  // Get the total price of items in the cart
  num getTotalDiscountForCart() {
    num totalPrice = 0;
    num discountPrice = 0;
    for (var cartItem in _cartItems) {
      if (cartItem.size == 'small') {
        totalPrice += (cartItem.item.smallPrice ?? 0);
        discountPrice += (cartItem.item.mobileSmall ?? 0);
      } else if (cartItem.size == 'medium') {
        totalPrice += (cartItem.item.mediumPrice ?? 0);
        discountPrice += (cartItem.item.mobileMedium ?? 0);
      } else if (cartItem.size == 'large') {
        totalPrice += (cartItem.item.largePrice ?? 0);
        discountPrice += (cartItem.item.mobileLarge ?? 0);
      }else if (cartItem.size == 'bottle') {
        totalPrice += (cartItem.item.bottlePrice ?? 0);
        discountPrice += (cartItem.item.mobileBottle ?? 0);
      }
    }
    return totalPrice - discountPrice;
  }

  // Get the total price of items in the cart
  num getTotalDiscountedPrice() {
    num totalPrice = 0;
    for (var cartItem in _cartItems) {
      if (cartItem.size == 'small') {
        if((cartItem.item.mobileSmall??0)!=0 && cartItem.item.mobileSmall != cartItem.item.smallPrice){
          totalPrice += ((cartItem.item.mobileSmall ?? 0) * cartItem.quantity);
        }else{
          totalPrice += ((cartItem.item.smallPrice ?? 0) * cartItem.quantity);
        }

      } else if (cartItem.size == 'medium') {
        if((cartItem.item.mobileMedium??0)!=0 && cartItem.item.mobileMedium != cartItem.item.mediumPrice){
          totalPrice += ((cartItem.item.mobileMedium ?? 0) * cartItem.quantity);
        }else{
          totalPrice += ((cartItem.item.mediumPrice ?? 0) * cartItem.quantity);
        }
      } else if (cartItem.size == 'large') {
        if((cartItem.item.mobileLarge??0)!=0 && cartItem.item.mobileLarge != cartItem.item.largePrice){
          totalPrice += ((cartItem.item.mobileLarge ?? 0) * cartItem.quantity);
        }else{
          totalPrice += ((cartItem.item.largePrice ?? 0) * cartItem.quantity);
        }
      } else if (cartItem.size == 'bottle') {
        if((cartItem.item.mobileBottle??0)!=0 && cartItem.item.mobileBottle != cartItem.item.bottlePrice){
          totalPrice += ((cartItem.item.mobileBottle ?? 0) * cartItem.quantity);
        }else{
          totalPrice += ((cartItem.item.bottlePrice ?? 0) * cartItem.quantity);
        }
      }
    }
    return totalPrice;
  }

  num getTax(){
    num total = getTotalDiscountedPrice();
    return total * 15 / 100;
  }

  // Get all items in the cart
  RxList<CartItem> get items => _cartItems;

  void clearCart() {
    _cartItems.clear();
    saveCartToPreferences(); // Save cart to preferences after clearing
  }

  // Save the cart to shared preferences
  Future<void> saveCartToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJsonList = _cartItems.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(cartKey, cartJsonList);
  }

  // Load the cart from shared preferences
  Future<void> loadCartFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJsonList = prefs.getStringList(cartKey);

    if (cartJsonList != null) {
      _cartItems.value = cartJsonList
          .map((itemJson) => CartItem.fromMap(jsonDecode(itemJson)))
          .toList();
    }
  }

  // Display cart items
  void displayCart() {
    for (var cartItem in _cartItems) {
      print('Item: ${cartItem.item.name}, Size: ${cartItem.size}, Price: ${getPrice(cartItem)}');
    }
  }

  // Get price based on size
  num getPrice(CartItem cartItem) {
    switch (cartItem.size) {
      case 'small':
        return cartItem.item.smallPrice ?? 0;
      case 'medium':
        return cartItem.item.mediumPrice ?? 0;
      case 'large':
        return cartItem.item.largePrice ?? 0;
      case 'bottle':
        return cartItem.item.bottlePrice ?? 0;
      default:
        return 0;
    }
  }
}
