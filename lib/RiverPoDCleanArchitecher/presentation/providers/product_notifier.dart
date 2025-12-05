import 'dart:async';

import '../../domain/repositories/product_repository.dart';
import 'package:fluttert_test_code/RiverPoDCleanArchitecher/data/repositories/product_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sources/product_api.dart';
import '../../data/models/product_model.dart';

//Injecting the dependencies using Riverpod Provider ,Instance of ProductRepositoryImpl is created here 105555555556

final ProductRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ProductApi());
});

//Notifier to manage the state of product list using AsyncNotifier
class ProductNotifier extends AsyncNotifier<List<ProductModel>> {
  late final ProductRepository repo; // Repository instance for data operations

  // Overriding the build method to fetch products and manage state and build called when notifier is first created
  @override
  Future<List<ProductModel>> build() {
    repo = ref.read(
      ProductRepositoryProvider,
    ); // Reading the repository instance from provider
    return repo.getProducts(); // Fetching the product list from repository
  }

  // Method to refresh the product list and update the state accordingly
  Future<void> refreshProducts() async {
    // Setting state to loading before refreshing data
    state = const AsyncValue.loading();
    // Fetching the updated product list and updating the state
    state = await AsyncValue.guard(() => repo.getProducts());
  }
}

//use ProductNotifier to Ui by creating a provider for it
final productNotifiProvider = AsyncNotifierProvider<ProductNotifier, List<ProductModel>>(
    ProductNotifier.new, // Creating a provider for ProductNotifier
);