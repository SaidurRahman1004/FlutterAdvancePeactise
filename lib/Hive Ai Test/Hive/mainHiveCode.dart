import 'package:flutter/material.dart'; // Flutter এর Material Design উইজেট ব্যবহারের জন্য ইম্পোর্ট করা হয়েছে।
import 'package:hive_flutter/hive_flutter.dart'; // Hive ডাটাবেস Flutter এর সাথে ব্যবহারের জন্য ইম্পোর্ট করা হয়েছে।
import 'task_model.dart'; // আমাদের তৈরি করা Task মডেল ফাইলটি ইম্পোর্ট করা হয়েছে।

// TaskScreen একটি StatefulWidget, কারণ এর স্টেট (অবস্থা) পরিবর্তন হতে পারে।
class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState(); // TaskScreen এর স্টেট তৈরি করবে।
}

// _TaskScreenState ক্লাসটি TaskScreen উইজেটের স্টেট পরিচালনা করে।
class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _controller =
      TextEditingController(); // TextField থেকে টেক্সট ইনপুট নেওয়ার জন্য একটি কন্ট্রোলার।
  late Box<Task>
  _taskBox; // Task অবজেক্টগুলো সংরক্ষণ করার জন্য একটি Hive বক্স (ডাটাবেস টেবিলের মতো)। `late` ব্যবহার করা হয়েছে কারণ এটি initState এ مقدار পাবে।

  @override
  void initState() {
    super
        .initState(); // StatefulWidget এর প্যারেন্ট ক্লাসের initState() মেথড কল করা হয়েছে।
    _taskBox = Hive.box<Task>(
      'tasks',
    ); // 'tasks' নামের খোলা Hive বক্সটি অ্যাক্সেস করা হচ্ছে। যদি বক্সটি আগে থেকে তৈরি না থাকে, তাহলে এটি একটি এরর দেবে। সাধারণত main.dart এ বক্স ওপেন করা হয়।
  }

  // এই মেথডটি একটি নতুন টাস্ক যোগ করার জন্য ব্যবহৃত হয়।
  void _addTask() {
    if (_controller.text.isNotEmpty) {
      // যদি TextField খালি না থাকে।
      final newTask = Task(
        title: _controller.text,
      ); // TextField এর টেক্সট দিয়ে একটি নতুন Task অবজেক্ট তৈরি করা হচ্ছে।
      _taskBox.add(
        newTask,
      ); // নতুন Task অবজেক্টটি Hive বক্সে যোগ করা হচ্ছে (Create অপারেশন)। এটি ডাটাবেসে একটি নতুন এন্ট্রি যোগ করবে।
      _controller
          .clear(); // TextField খালি করা হচ্ছে যাতে নতুন টাস্ক যোগ করার জন্য প্রস্তুত থাকে।
    }
  }

  // এই মেথডটি নির্দিষ্ট ইনডেক্সের টাস্ক মুছে ফেলার জন্য ব্যবহৃত হয়।
  void _deleteTask(int index) {
    _taskBox.deleteAt(
      index,
    ); // নির্দিষ্ট ইনডেক্সের টাস্কটি Hive বক্স থেকে মুছে ফেলা হচ্ছে (Delete অপারেশন)। এটি ডাটাবেস থেকে এন্ট্রিটি স্থায়ীভাবে সরিয়ে ফেলবে।
  }

  // এই মেথডটি নির্দিষ্ট ইনডেক্সের টাস্কের স্ট্যাটাস (isCompleted) পরিবর্তন করার জন্য ব্যবহৃত হয়।
  void _toggleTaskStatus(int index, Task task) {
    task.isCompleted = !task
        .isCompleted; // টাস্কের isCompleted প্রপার্টির মান পরিবর্তন করা হচ্ছে (true হলে false, false হলে true)।
    _taskBox.putAt(
      index,
      task,
    ); // পরিবর্তিত Task অবজেক্টটি Hive বক্সে নির্দিষ্ট ইনডেক্সে আপডেট করা হচ্ছে (Update অপারেশন)। এটি ডাটাবেসে বিদ্যমান এন্ট্রির মান পরিবর্তন করবে।
  }

  @override
  Widget build(BuildContext context) {
    // UI (ইউজার ইন্টারফেস) তৈরি করার জন্য এই মেথডটি কল করা হয়।
    return Scaffold(
      // একটি মৌলিক Material Design ভিজ্যুয়াল লেআউট স্ট্রাকচার।
      appBar: AppBar(title: Text('Hive To-Do List')),
      // অ্যাপ্লিকেশনের উপরে বার, যেখানে টাইটেল দেখানো হচ্ছে।
      body: Column(
        // উইজেটগুলোকে উল্লম্বভাবে সাজানোর জন্য Column ব্যবহার করা হয়েছে।
        children: [
          // --- এই অংশটুকু একটি নতুন টাস্ক ইনপুট নেওয়ার জন্য UI তৈরি করে ---
          Padding(
            // চারপাশে প্যাডিং যোগ করার জন্য Padding উইজেট।
            padding: const EdgeInsets.all(16.0), // সব দিকে ১৬ পিক্সেল প্যাডিং।
            child: Row(
              // উইজেটগুলোকে অনুভূমিকভাবে সাজানোর জন্য Row ব্যবহার করা হয়েছে।
              children: [
                Expanded(
                  // TextField কে যতটা সম্ভব জায়গা নিতে দেওয়া হয়েছে।
                  child: TextField(
                    controller: _controller,
                    // TextField এর সাথে কন্ট্রোলার যুক্ত করা হয়েছে।
                    decoration: InputDecoration(
                      // TextField এর ডেকোরেশন (যেমন লেবেল, হিন্ট টেক্সট)।
                      labelText: 'New Task',
                      // TextField এর উপরে একটি লেবেল।
                      hintText: 'Enter your task here...',
                      // TextField খালি থাকলে একটি হিন্ট টেক্সট।
                      border: OutlineInputBorder(
                        // TextField এর চারপাশে একটি বর্ডার।
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // বর্ডারের কোণাগুলো গোলাকার করা হয়েছে।
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // TextField এবং IconButton এর মধ্যে ১০ পিক্সেল ফাঁকা জায়গা।
                IconButton(
                  // একটি আইকন বাটন, যা চাপলে _addTask মেথড কল হবে।
                  icon: Icon(Icons.add), // বাটনের আইকন।
                  iconSize: 30, // আইকনের আকার।
                  onPressed: _addTask, // বাটন চাপলে _addTask মেথড কল হবে।
                  style: IconButton.styleFrom(
                    // বাটনের স্টাইল।
                    backgroundColor: Theme.of(context).primaryColor,
                    // বাটনের الخلفية রঙ অ্যাপের প্রাইমারি রঙ।
                    foregroundColor: Colors.white,
                    // বাটনের আইকনের রঙ সাদা।
                    padding: EdgeInsets.all(12),
                    // বাটনের ভিতরে প্যাডিং।
                    shape: RoundedRectangleBorder(
                      // বাটনের আকৃতি।
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ), // বাটনের কোণাগুলো গোলাকার করা হয়েছে।
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- এই পর্যন্ত ---
          Expanded(
            // ListView.builder কে বাকি জায়গা নিতে দেওয়া হয়েছে।
            // ValueListenableBuilder Hive বক্সের পরিবর্তন শোনার জন্য ব্যবহৃত হয় এবং UI আপডেট করে।
            child: ValueListenableBuilder(
              valueListenable: _taskBox.listenable(),
              // _taskBox এর পরিবর্তন শোনার জন্য listenable() ব্যবহার করা হয়েছে। যখন বক্সে কোন ডাটা যোগ, পরিবর্তন বা মুছে ফেলা হয়, তখন এটি UI আপডেট করে।
              builder: (context, Box<Task> box, _) {
                // UI তৈরি করার জন্য বিল্ডার ফাংশন।

                // যদি বক্স খালি থাকে তবে একটি মেসেজ দেখানো হচ্ছে।
                if (box.isEmpty) {
                  return Center(
                    // মেসেজটিকে স্ক্রিনের মাঝে দেখানোর জন্য Center উইজেট।
                    child: Text(
                      "No tasks yet. Add one!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // ListView.builder একটি স্ক্রোলযোগ্য তালিকা তৈরি করে যা শুধুমাত্র দৃশ্যমান আইটেমগুলো রেন্ডার করে।
                return ListView.builder(
                  itemCount: box.length,
                  // তালিকার মোট আইটেমের সংখ্যা (বক্সের টাস্কের সংখ্যা)।
                  itemBuilder: (context, index) {
                    // প্রতিটি আইটেম তৈরি করার জন্য বিল্ডার ফাংশন।
                    final task = box.getAt(
                      index,
                    )!; // নির্দিষ্ট ইনডেক্সের Task অবজেক্টটি বক্স থেকে পড়া হচ্ছে (Read অপারেশন)। `!` ব্যবহার করা হয়েছে কারণ আমরা নিশ্চিত যে এই ইনডেক্সে একটি টাস্ক আছে।
                    return ListTile(
                      // তালিকার প্রতিটি আইটেমকে সুন্দরভাবে দেখানোর জন্য ListTile উইজেট।
                      title: Text(
                        // টাস্কের শিরোনাম দেখানোর জন্য Text উইজেট।
                        task.title,
                        style: TextStyle(
                          // টেক্সটের স্টাইল।
                          fontSize: 18,
                          decoration: task.isCompleted
                              ? TextDecoration
                                    .lineThrough // যদি টাস্ক সম্পন্ন হয়ে থাকে তবে লেখার উপর একটি লাইন টানা হবে।
                              : TextDecoration.none,
                          // অন্যথায় কোন ডেকোরেশন থাকবে না।
                          color: task.isCompleted
                              ? Colors.grey
                              : Colors
                                    .black, // যদি টাস্ক সম্পন্ন হয়ে থাকে তবে টেক্সটের রঙ ধূসর হবে, অন্যথায় কালো।
                        ),
                      ),
                      leading: Checkbox(
                        // টাস্ক সম্পন্ন হয়েছে কিনা তা চিহ্নিত করার জন্য একটি চেকবক্স।
                        value: task.isCompleted, // চেকবক্সের বর্তমান অবস্থা।
                        onChanged: (value) => _toggleTaskStatus(
                          index,
                          task,
                        ), // চেকবক্সের অবস্থা পরিবর্তন হলে _toggleTaskStatus মেথড কল হবে।
                      ),
                      trailing: IconButton(
                        // টাস্ক মুছে ফেলার জন্য একটি আইকন বাটন।
                        icon: Icon(Icons.delete), // বাটনের আইকন।
                        color: Colors.redAccent, // আইকনের রঙ।
                        onPressed: () => _deleteTask(
                          index,
                        ), // বাটন চাপলে _deleteTask মেথড কল হবে।
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
