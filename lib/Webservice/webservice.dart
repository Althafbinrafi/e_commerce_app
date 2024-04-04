import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/Models/category_model.dart';
import 'package:flutter_application_1/Models/order_model.dart';
import 'package:flutter_application_1/Models/product_model.dart';
import 'package:flutter_application_1/Models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Webservice {
  final imageurl = 'http://bootcamp.cyralearnings.com/products/';
  static final mainurl = 'http://bootcamp.cyralearnings.com/';

  Future<List<ProductModel>?> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(mainurl + 'view_offerproducts.php'),
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load Products');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<CategoryModel>?> fetchCategory() async {
    try {
      final response = await http.get(
        Uri.parse('http://bootcamp.cyralearnings.com/getcategories.php'),
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load Categories');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<ProductModel>> fetchCatProducts(int catid) async {
    log('catid==' + catid.toString());
    final response = await http.post(
        Uri.parse(
            'http://bootcamp.cyralearnings.com/get_category_products.php'),
        body: {'catid': catid.toString()});
    log('statuscode==' + response.statusCode.toString());
    if (response.statusCode == 200) {
      log('catid is string');
      log('response == ' + response.body.toString());

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception('failed to load');
    }
  }

  Future<UserModel> fetchUser(String username) async {
    final response = await http.post(Uri.parse(mainurl + 'get_user.php'),
        body: {'username': username});

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Fetchuser");
    }
  }

  Future<List<OrderModel>?> fetchOrderDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String username = prefs.getString('username').toString();

      final response = await http.post(
          Uri.parse('http://bootcamp.cyralearnings.com/get_orderdetails.php'),
          body: {'username': username.toString()});

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      log('order detalis' + e.toString());
    }
    return null;
  }
}
