import 'package:farms_gate_marketplace/data_base/cart_db_helper.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  CartDatabaseHelper dataBase = CartDatabaseHelper();
  List<ProductModel> cartList = [];
  Map<String, int> productQuantities = {};
  List<ProductModel> get _cartList => cartList;
  int get cartLength => cartList.length;
  double get cartTotal => _cartList.fold(
        0,
        (previousValue, element) =>
            previousValue +
            element.marketPrice * (productQuantities[element.productId] ?? 0),
      );

  bool isProductInCart(ProductModel product) {
    return _cartList.any((item) => item.productId == product.productId);
  }


  void addToCart(ProductModel product, BuildContext context) async {
    if (!_cartList.contains(product)) {
      _cartList.add(product);
      productQuantities[product.productId!] = 1;

      await dataBase.insertCartInfo(
          product, productQuantities[product.productId].toString());

      showCustomToast(
          context, 'Item added successfully', '', ToastType.success);
    } else {
      incrementSingleProduct(product);
    }

    notifyListeners();
  }

  void addToCartFromSavedItemScreen(
      ProductModel product, BuildContext context) {
    bool exists = _cartList.any((item) => item.productId == product.productId);

    if (!exists) {
      _cartList.add(product);
      showCustomToast(
          context, 'Item added successfully', '', ToastType.success);
      notifyListeners();
    }
  }

  double getTotalAmountForProduct(ProductModel product) {
    return product.marketPrice * productQuantities[product.productId]!;
  }

  void incrementSingleProduct(ProductModel product) async {
    if (isProductInCart(product)) {
      productQuantities[product.productId!] =
          productQuantities[product.productId]! + 1;
      await dataBase.updateCartQuantity(
          product.productId!, productQuantities[product.productId]!);
      notifyListeners();
    }
  }

  // remove from cart
  void removeFromCart(ProductModel product, BuildContext context) async {
    if (productQuantities.containsKey(product.productId) &&
        productQuantities[product.productId]! > 1) {
      productQuantities[product.productId!] =
          productQuantities[product.productId]! - 1;

      await dataBase.updateCartQuantity(
          product.productId!, productQuantities[product.productId]!);
    } else if (productQuantities[product.productId]! == 1) {
      removeAllSingleProd(product, context);

      await dataBase.deleteProductFromCart(product.productId!);
    }
    notifyListeners();
  }

  void removeAllSingleProd(ProductModel product, BuildContext context) async {
    _cartList.removeWhere((item) => item.productId == product.productId);
    productQuantities.remove(product.productId);
    notifyListeners();

    await dataBase.deleteProductFromCart(product.productId!);
    showCustomToast(context, 'Item removed successfully', '', ToastType.error);

    notifyListeners();
  }

  void loadCartFromDatabase() async {
    final cartData = await dataBase.getCartInfos();

    _cartList.clear();
    productQuantities.clear();

    for (var entry in cartData) {
      final product = entry.keys.first;
      final quantity = entry.values.first;

      _cartList.add(product);
      productQuantities[product.productId!] = quantity;
    }

    notifyListeners();
  }

  void clearCartItems() async {
    _cartList.clear();
    productQuantities.clear();

    await dataBase.deleteAllProductFromCart();
    notifyListeners();
  }

  double getProductTotal(ProductModel product) {
    return product.marketPrice * (productQuantities[product.productId] ?? 0);
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in _cartList) {
      total += item.marketPrice * (productQuantities[item.productId] ?? 0);
    }

    return total;
  }

  void setCartItems(List<ProductModel> items) {
    cartList = items;
    notifyListeners();
  }
}
