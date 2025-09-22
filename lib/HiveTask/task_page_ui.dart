import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttert_test_code/HiveTask/taskHimeModel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure Start Flutter engine
  Hive.initFlutter(); //
  Hive.registerAdapter(taskModelHAdapter()); // Adapter Register
  await Hive.openBox<taskModelH>("tasksBox");

  runApp(taskPageUi());
}

class taskPageUi extends StatefulWidget {
  taskPageUi({super.key});

  @override
  State<taskPageUi> createState() => _taskPageUiState();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _taskControllerEdt = TextEditingController();
  final Box<taskModelH> taskBoxMemory = Hive.box<taskModelH>(
    "tasksBox",
  ); //taskBoxMemory নামে লিস্টের মত কিছু তৈরি করছি যাতে tasksBox Hive বক্স্বের এলিমেন্ট যুক্ত হবে!tasksBox কিনা Haive Box এটি টেবিলের নামের মত কাজ করে এটার ভিতর ই সব রাখা!হাইব মডেল রাখা!

  //task add Function
  void _addTask(String NewtaskName) {
    final task = taskModelH(
      taskName: NewtaskName,
    ); //TextFeild এ যে নাম (NewtaskName হিসেবে)এড করবে task এ স্টোর হবে!যা taskModelH এর taskName হিসেবে NewtaskName এড হবে!
    taskBoxMemory.add(task);
    _taskController.clear();
  }

  //task completer Function
  void _completeTask(int index) {
    final task = taskBoxMemory.getAt(index);
    taskBoxMemory.putAt(
      index,
      taskModelH(taskName: task!.taskName, isDone: !task.isDone),
    );
  }

  void _deletTask(int Index) {
    taskBoxMemory.deleteAt(Index);
  }
}

class _taskPageUiState extends State<taskPageUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Page Using Hive Local Storage")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget._taskController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Enter Task",
                    ),
                  ),
                ),
                SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    widget._addTask(widget._taskController.text);
                  },
                  icon: Icon(Icons.add, size: 30, color: Colors.red),
                ),
              ],
            ),
          ),
          //TaskList
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.taskBoxMemory.listenable(),
              builder: (_, Box<taskModelH> box, _) {
                if (box.isEmpty) {
                  return Center(child: Text("No Task Found"));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final taskShort = box.getAt(index)!;
                    return ListTile(
                      leading: Checkbox(
                        value: taskShort.isDone,
                        onChanged: (value) {
                          widget._completeTask(index);
                        },
                      ),
                      title: Text(
                        taskShort.taskName,
                        style: TextStyle(
                          decoration: taskShort.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              widget._deletTask(index);
                            },
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Edit Task"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: widget._taskControllerEdt,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            hintText: "Enter Task",
                                          ),
                                        ),

                                        SizedBox(height: 10),
                                        OutlinedButton(
                                          onPressed: () {
                                            widget.taskBoxMemory.putAt(
                                              index,
                                              taskModelH(
                                                taskName: widget
                                                    ._taskControllerEdt
                                                    .text,
                                                isDone: taskShort.isDone,
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Save&Change"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
