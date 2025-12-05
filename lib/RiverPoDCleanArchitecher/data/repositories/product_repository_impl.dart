import '../models/product_model.dart';
import '../sources/product_api.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository{

  late final ProductApi productApi;
  ProductRepositoryImpl(this.productApi);

  @override
  Future<List<ProductModel>> getProducts() {
    return productApi.fetchProducts();

  }





}