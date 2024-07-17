import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBool({required String key, required bool value}) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> saveListData({required String key, required dynamic value}) async {
    if (value is List) {
      return await sharedPreferences!.setString(key, jsonEncode(value));
    } else {
      return await sharedPreferences!.setString(key, value);
    }
  }

  static List<Map<String, dynamic>> getCartItems() {
    String? cartItemsString = sharedPreferences!.getString('cartItems');
    if (cartItemsString != null) {
      List<dynamic> items = jsonDecode(cartItemsString);
      return items.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  static Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    String itemsString = jsonEncode(items);
    await sharedPreferences!.setString('cartItems', itemsString);
  }

  static Future<void> removeCartItem(String itemId) async {
    List<Map<String, dynamic>> items = getCartItems();
    items.removeWhere((cartItem) => cartItem['id'] == itemId); // Remove by unique ID
    await saveCartItems(items);
  }

}
