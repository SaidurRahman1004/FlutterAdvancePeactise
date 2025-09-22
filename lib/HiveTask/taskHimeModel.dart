import 'package:hive/hive.dart';
part 'taskHimeModel.g.dart';
@HiveType(typeId: 0)
class taskModelH extends HiveObject{
  @HiveField(0)
  String taskName;
  @HiveField(1)
  bool isDone;
  taskModelH({required this.taskName,this.isDone=false});
}
