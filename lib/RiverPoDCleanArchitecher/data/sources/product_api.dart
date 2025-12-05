import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
class ProductApi{
  final String url = "https://fakestoreapi.com/products";

  Future<List<ProductModel>> fetchProducts() async{
    final response = await http.get(Uri.parse(url));
    
    if(response.statusCode == 200){
      List jsonRsponse = jsonDecode(response.body);
      return jsonRsponse.map((product)=> ProductModel.fromJson(product)).toList();
    }else{
      throw Exception('Failed to load products');
    }
    

  }
}