import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mosques_donation_app/models/banner.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/models/category.dart';
import 'package:mosques_donation_app/models/organisation.dart';
import 'package:mosques_donation_app/models/product.dart';
import 'package:mosques_donation_app/models/product_attributes.dart';

class HttpService {
  // Host URL (Replace it with your host)
  // static const URL = 'http://mosquesapp.royhayek.com';
  static const URL = 'http://192.168.1.101:8000';

  // API URL (The file performing CRUD operations)
  static const API = URL + '/api';

  // Images paths in the server
  static const CATEGORY_IMAGES_PATH = URL + '/uploads/categories/';
  static const PRODUCT_IMAGES_PATH = URL + '/uploads/products/';
  static const SUBCATEGORY_IMAGES_PATH = URL + '/uploads/subcategories/';
  static const BANNER_IMAGES_PATH = URL + '/uploads/banners/';

  static Future<List<Category>> getCategories() async {
    try {
      final response = await http
          .get(API + '/categories', headers: {"Accept": "application/json"});
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        print(parsed);
        List<Category> categories =
            parsed.map<Category>((json) => Category.fromJson(json)).toList();
        return categories;
      } else {
        return List<Category>();
      }
    } catch (e) {
      print(e);
      return List<Category>();
    }
  }

  static Future<List<Banner>> getBanners() async {
    try {
      final response = await http
          .get(API + '/banners', headers: {"Accept": "application/json"});
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Banner> categories =
            parsed.map<Banner>((json) => Banner.fromJson(json)).toList();
        return categories;
      } else {
        return List<Banner>();
      }
    } catch (e) {
      print(e);
      return List<Banner>();
    }
  }

  static Future<List<Organisation>> getOrganisations() async {
    try {
      final response = await http
          .get(API + '/organisations', headers: {"Accept": "application/json"});
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Organisation> organisations = parsed
            .map<Organisation>((json) => Organisation.fromJson(json))
            .toList();
        return organisations;
      } else {
        return List<Organisation>();
      }
    } catch (e) {
      print(e);
      return List<Organisation>();
    }
  }

  static Future<List<Product>> getProductBySubcategory(
      int subcategoryId) async {
    try {
      final response = await http.get(API + '/products/$subcategoryId',
          headers: {"Accept": "application/json"});
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        print(parsed);
        List<Product> products =
            parsed.map<Product>((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        return List<Product>();
      }
    } catch (e) {
      print(e);
      return List<Product>();
    }
  }

  static Future<String> addToCart(String userId, int productId, int attributeId,
      int quantity, num price) async {
    try {
      final response = await http.post(API + '/carts', body: {
        'userId': userId.toString(),
        'productId': productId.toString(),
        'attributeId': attributeId.toString(),
        'quantity': quantity.toString(),
        'price': price.toString(),
      }, headers: {
        "Accept": "application/json"
      });
      print(response.body);

      if (201 == response.statusCode) {
        final parsed = json.decode(response.body);
        Fluttertoast.showToast(msg: parsed['message']);
        return parsed['message'];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Cart> getUserCart(String userId) async {
    try {
      final response = await http
          .get(API + '/carts/$userId', headers: {"Accept": "application/json"});
      print(response.body);
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body);
        print(parsed);
        Cart cart = Cart.fromJson(parsed);
        print(cart);
        return cart;
      } else {
        return Cart();
      }
    } catch (e) {
      print(e);
      return Cart();
    }
  }

  static Future deleteCartProduct(int cartId) async {
    try {
      final response = await http.delete(API + '/carts/$cartId',
          headers: {"Accept": "application/json"});
      if (204 == response.statusCode) {
        print('product deleted');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<String> addDevice(String token) async {
    try {
      final response = await http.post(API + '/addDeviceToken/$token',
          headers: {"Accept": "application/json"});
      print(response.body);

      if (201 == response.statusCode) {
        final parsed = json.decode(response.body);
        return parsed['message'];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<ProductAttributes>> getProductAttributes(
      int productId) async {
    try {
      final response = await http.get(API + '/getProductAttributes/$productId',
          headers: {"Accept": "application/json"});
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        List<ProductAttributes> attributes = parsed
            .map<ProductAttributes>((json) => ProductAttributes.fromJson(json))
            .toList();
        return attributes;
      } else {
        return List<ProductAttributes>();
      }
    } catch (e) {
      print(e);
      return List<ProductAttributes>();
    }
  }

  static Future<ProductAttributes> getProductWithAttribute(
      int attributeId) async {
    try {
      print('attributeId $attributeId');
      final response = await http.get(
          API + '/getProductWithAttribute/$attributeId',
          headers: {"Accept": "application/json"});
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body);
        print(parsed);
        ProductAttributes attributes = ProductAttributes.fromJson(parsed);
        return attributes;
      } else {
        return ProductAttributes();
      }
    } catch (e) {
      print(e);
      return ProductAttributes();
    }
  }

  static Future<String> updateCartProduct(
      int cartId, int quantity, num price) async {
    try {
      final response = await http.put(API + '/carts' + '/$cartId', body: {
        'quantity': quantity.toString(),
        'price': price.toString(),
      }, headers: {
        "Accept": "application/json"
      });
      print(response.body);

      if (200 == response.statusCode) {
        final parsed = json.decode(response.body);
        return parsed['message'];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
