import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_model.dart';

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier() : super(const AsyncValue.loading());

  Future<void> fetchProducts() async {
    try {
      state = const AsyncValue.loading();
      final response = await http.get(
          Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final products = data.map((e) => Product.fromJson(e)).toList();
        state = AsyncValue.data(products);
      } else {
        state = AsyncValue.error("Faild to Load Products", StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }


}
final productNotifierProvider = StateNotifierProvider<ProductNotifier,AsyncValue<List<Product>>>(
    (ref)=> ProductNotifier()
);


