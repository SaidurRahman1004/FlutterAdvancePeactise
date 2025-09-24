import 'package:hive/hive.dart';
part 'note_app_model.g.dart';
@HiveType(typeId:0)
class noteModle extends HiveObject{
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  noteModle({required this.title,required this.content});
}