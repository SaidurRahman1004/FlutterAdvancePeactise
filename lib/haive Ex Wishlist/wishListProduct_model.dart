import 'package:hive/hive.dart';
part 'wishListProduct_model.g.dart';
@HiveType(typeId: 0)
class wishProduct extends HiveObject{
  @HiveField(0)
  final String name;

  wishProduct({required this.name});
}