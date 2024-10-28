import 'package:fruitables/app/data/core/app_export.dart';
import 'package:fruitables/app/data/models/menu_model.dart';

class CartItem {
  Items item;
  String size; // 'small', 'medium', or 'large'

  CartItem({required this.item, required this.size});
}

class Cart {
  RxList<CartItem> _cartItems = <CartItem>[].obs;

  // Add an item to the cart with specified size
  void addItem(Items item, String size) {
    _cartItems.add(CartItem(item: item, size: size));
  }

  // Remove an item from the cart by ID
  void removeItem(String id) {
    _cartItems.removeWhere((cartItem) => cartItem.item.id == id);
  }

  // Get the total price of items in the cart
  int getTotalPrice() {
    int totalPrice = 0;
    for (var cartItem in _cartItems) {
      if (cartItem.size == 'small') {
        totalPrice += (cartItem.item.smallPrice ?? 0);
      } else if (cartItem.size == 'medium') {
        totalPrice += (cartItem.item.mediumPrice ?? 0);
      } else if (cartItem.size == 'large') {
        totalPrice += (cartItem.item.largePrice ?? 0);
      }
    }
    return totalPrice;
  }

  // Get the total price of items in the cart
  int getTotalDiscountedPrice() {
    int totalPrice = 0;
    for (var cartItem in _cartItems) {
      if (cartItem.size == 'small') {
        totalPrice += (cartItem.item.smallDiscountedPrice ?? 0);
      } else if (cartItem.size == 'medium') {
        totalPrice += (cartItem.item.mediumDiscountedPrice ?? 0);
      } else if (cartItem.size == 'large') {
        totalPrice += (cartItem.item.largeDiscountedPrice ?? 0);
      }
    }
    return totalPrice;
  }

  // Get all items in the cart
  RxList<CartItem> get items => _cartItems;

  // Clear the cart
  void clearCart() {
    _cartItems.clear();
  }

  // Display cart items
  void displayCart() {
    for (var cartItem in _cartItems) {
      print('Item: ${cartItem.item.name}, Size: ${cartItem.size}, Price: ${getPrice(cartItem)}');
    }
  }

  // Get price based on size
  int getPrice(CartItem cartItem) {
    switch (cartItem.size) {
      case 'small':
        return cartItem.item.smallPrice ?? 0;
      case 'medium':
        return cartItem.item.mediumPrice ?? 0;
      case 'large':
        return cartItem.item.largePrice ?? 0;
      default:
        return 0;
    }
  }
}
