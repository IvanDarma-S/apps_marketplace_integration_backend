import 'package:flutter/material.dart';
import 'package:apps_marketplace_integration_backend/core/network/dio_client.dart';
import 'package:apps_marketplace_integration_backend/core/utils/api_constants.dart';
import 'package:apps_marketplace_integration_backend/features/dashboard/domain/models/product_model.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  ProductStatus _status = ProductStatus.initial;
  List<ProductModel> _products = [];
  String? _error;

  ProductStatus get status => _status;
  List<ProductModel> get products => _products;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      final response = await DioClient.instance.get(ApiConstants.products);

      final List<dynamic> data = response.data['data'];

      _products = data.map((e) => ProductModel.fromJson(e)).toList();

      _status = ProductStatus.loaded;
    } catch (e) {
      _error = "Gagal load produk";
      _status = ProductStatus.error;
    }

    notifyListeners();
  }
}
