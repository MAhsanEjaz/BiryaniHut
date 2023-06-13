import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/products_model.dart';

class SalesrepCartStorage {
  final box = Hive.box("salesrep_cart_box");

  void addCartItem({required CartItem item, required int customerId}) {
    String itemString = json.encode(item);
    log("json of product = $itemString");

    log("box.get =${box.get("$customerId+salesrep_cart_list")} ");
    List<String> list = [];
    if (box.get("$customerId+salesrep_cart_list") != null) {
      list = box.get("$customerId+salesrep_cart_list");
      list.add(itemString);
      box.put("$customerId+salesrep_cart_list", list);
    } else {
      list.add(itemString);
      box.put("$customerId+salesrep_cart_list", list);
    }

    log("total item in cart = ${list.length}");
  }

  List<String>? getCartItems({required int customerId}) {
    if (box.get("$customerId+salesrep_cart_list") == null) {
      return [];
    } else {
      return box.get("$customerId+salesrep_cart_list");
    }
  }

  //! to update quanitity of a existing product

  void updateCartItem({required CartItem item, required int customerId}) {
    List<CartItem> model = [];
    // String itemString = getStringFromProductItem(item);
    String itemString = json.encode(item);

    log("json of product = $itemString");

    log("box.get =${box.get("$customerId+salesrep_cart_list")} ");
    List<String> list = [];
    if (box.get("$customerId+salesrep_cart_list") != null) {
      list = box.get("$customerId+salesrep_cart_list");

      list.forEach((element) {
        model.add(CartItem.fromJson(json.decode(element)));
      });

      for (int i = 0; i < model.length; i++) {
        if (item.productId == model[i].productId) {
          // model[i] = item;
          // list.removeAt(i);
          list[i] = itemString;
          box.put("$customerId+salesrep_cart_list", list);
          // model.remove(model[i]);
          return;
        }
      }

      // list = json.encode(model);
    } else {
      list.add(itemString);
      box.put("$customerId+salesrep_cart_list", list);
    }

    log("total item in cart = ${list.length}");
  }

  void deleteCartItem({required int index, required int customerId}) {
    List<String> list = [];
    if (box.get("$customerId+salesrep_cart_list") != null) {
      list = box.get("$customerId+salesrep_cart_list");
      list.removeAt(index);

      box.put("$customerId+salesrep_cart_list", list);
    }
  }

//! delete any particular cart
  void clearAnyCustomerCart({required int customerId}) {
    box.put("$customerId+salesrep_cart_list", <String>[]);
  }

  String getStringFromProductItem(ProductData item) {
// int quantity = 0;

    CartItem cartItem = CartItem(
      productId: item.productId,
      price: item.salePrice,
      quantity: 1,
      discount: item.discount,
      productDescription: item.discription,
      productImage: item.productImagePath!,
      productImagePath: '',
      productName: item.productName,
      totalCost: item.salePrice * item.quantity,
      totalPrice: item.salePrice,
    );

    return json.encode(cartItem);
  }
}
