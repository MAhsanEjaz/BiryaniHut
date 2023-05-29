import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/products_model.dart';

class CustomerCartStorage {
  final box = Hive.box("customer_cart_box");

  void addCartItem({required CartItem item}) {
    log("json of product = ${json.encode(item)}");

    // String itemString = getStringFromProductItem(item);
    String itemString = json.encode(item);

    log("box.get =${box.get("customer_cart_list")} ");
    List<String> list = [];
    if (box.get("customer_cart_list") != null) {
      list = box.get("customer_cart_list");
      list.add(itemString);
      box.put("customer_cart_list", list);
    } else {
      list.add(itemString);
      box.put("customer_cart_list", list);
    }

    log("total item in cart = ${list.length}");
  }

  List<String>? getCartItems() {
    if (box.get("customer_cart_list") == null) {
      return [];
    } else {
      return box.get("customer_cart_list");
    }
  }

  //! to update quanitity of a existing product

  void updateCartItem({required CartItem item}) {
    List<CartItem> model = [];
    // String itemString = getStringFromProductItem(item);
    String itemString = json.encode(item);

    log("json of product = ${itemString}");

    log("box.get =${box.get("customer_cart_list")} ");
    List<String> list = [];
    if (box.get("customer_cart_list") != null) {
      list = box.get("customer_cart_list");

      list.forEach((element) {
        model.add(CartItem.fromJson(json.decode(element)));
      });

      for (int i = 0; i < model.length; i++) {
        if (item.productId == model[i].productId) {
          // model[i] = item;
          // list.removeAt(i);
          list[i] = itemString;
          box.put("customer_cart_list", list);
          // model.remove(model[i]);
          return;
        }
      }

      // list = json.encode(model);
    } else {
      list.add(itemString);
      box.put("customer_cart_list", list);
    }

    log("total item in cart = ${list.length}");
  }

  void deleteCartItem({required int index}) {
    List<String> list = [];
    if (box.get("customer_cart_list") != null) {
      list = box.get("customer_cart_list");
      list.removeAt(index);

      box.put("customer_cart_list", list);
    }
  }

  String getStringFromProductItem(ProductData item) {
// int quantity = 0;

    CartItem cartItem = CartItem(
      productId: item.productId,
      price: item.price,
      quantity: 1,
      discount: item.discount,
      productDescription: item.discription,
      productImage: item.productImagePath!,
      productImagePath: '',
      productName: item.productName,
      totalCost: item.price * item.quantity,
      totalPrice: item.price,
    );

    return json.encode(cartItem);
  }
}
