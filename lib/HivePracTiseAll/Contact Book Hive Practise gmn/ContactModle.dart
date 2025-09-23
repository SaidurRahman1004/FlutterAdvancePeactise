import 'package:hive/hive.dart';
part 'ContactModle.g.dart';  //flutter packages pub run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 0)
class ContactModle extends HiveObject{
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String phoneNumber;

  ContactModle({required this.name, required this.phoneNumber});

}