import 'package:adaptive_widgeet/api/Model/Product.dart';
import 'package:adaptive_widgeet/api/services/api_services.dart';
import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  final url = "https://dummyjson.com//products/";

  final ApiService apiService;

  Controller() : apiService = ApiService(baseUrl: "https://dummyjson.com/");

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Product> _products = [];
  List<Product> get products => _products;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getProducts() async {
    _setLoading(true);

    try {
      final products = await apiService.callApi<Product>(
        endpoint: "products/",
        body: {},
        fromJson: (data) => Product.fromJson(data),
      );
      print(products);

      // final res = await apiService.callApi<ProductResponse>(
      //   endpoint: PRODUCT,
      //   fromJson: (data) => ProductResponse.fromJson(data),
      // );

      // _products = res.products;
      // print(_products);
    } catch (e) {
      debugPrint("Error: $e");
    }

    _setLoading(false);
  }
}
