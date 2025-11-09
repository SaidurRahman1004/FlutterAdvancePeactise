import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class Product with _$Product{
  const factory Product({
    required int id,
    required String title,
    required String description,
    required double price,
    required String image,

}) = _Product;
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);



}

//flutter pub run build_runner build --delete-conflicting-outputs