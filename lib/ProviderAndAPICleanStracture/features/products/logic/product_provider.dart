import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  bool _isLoading = false;
  String? _error;
  List<Product> _products = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _repository.fetchProducts();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
