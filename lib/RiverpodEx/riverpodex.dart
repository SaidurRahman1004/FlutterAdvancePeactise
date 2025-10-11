//Practice Task 8.3 Ans - Riverpod Api Example

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model
class productModel {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  productModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  //receiving data from server
  productModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating = json['rating'] != null
        ? new Rating.fromJson(json['rating'])
        : null;
  }

  //sending data to server
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['category'] = this.category;
    data['image'] = this.image;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class Rating {
  double? rate;
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  //sending data to server
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}

// Riverpod FutureProvider with  Api Service
final productProvider = FutureProvider<List<productModel>>((ref) async {
  final response = await http.get(
    Uri.parse("https://fakestoreapi.com/products"),
  );
  if (response.statusCode == 200) {
    final List JsonResponse = jsonDecode(
      response.body,
    ); // Decode the JSON response
    return JsonResponse.map(
      (productItems) => productModel.fromJson(productItems),
    ).toList(); // Map each item to productModel //kind of loop?
  } else {
    throw Exception("Failed to load data");
  }
});

//UI Product List
class RiverpodApiExUi extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProductRiverpodCtrl = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Riverpod Api Example"),
      ),
      body: asyncProductRiverpodCtrl.when(
          data: (productModel)=>ListView.builder(
            itemCount: productModel.length,
              itemBuilder: (_,index){
              final singleProductAccess = productModel[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  leading: Image.network(singleProductAccess.image!,height: 50,width: 50,fit: BoxFit.fill,),
                  title: Text(singleProductAccess.title!,maxLines: 1,),
                  subtitle: Text("\$${singleProductAccess.price!.toString()}",style: TextStyle(color: Colors.blue),),
                ),
              );
              }
          ),
          error: (err,stack)=> Text("Something Went Wrong ${err.toString()}"),
          loading: ()=> Center(child: CircularProgressIndicator(),)
      ),
    );


  }

}