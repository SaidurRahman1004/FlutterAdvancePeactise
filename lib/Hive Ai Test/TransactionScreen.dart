import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'transaction.dart'; // আমাদের মডেল ইম্পোর্ট করি

void main() async {
  // ফ্লাটার অ্যাপ শুরু হওয়ার আগে Hive ইনিশিয়ালাইজ করা নিশ্চিত করতে হবে
  await Hive.initFlutter();

  // আমাদের কাস্টম অবজেক্টের জন্য Adapter রেজিস্টার করতে হবে
  Hive.registerAdapter(TransactionAdapter());

  // 'transactions' নামে একটি বক্স খুলতে হবে
  await Hive.openBox<Transaction>('transactions');

  runApp(const HiveAiAdvtrans());
}

class HiveAiAdvtrans extends StatelessWidget {
  const HiveAiAdvtrans({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData.dark(),
      home: TransactionScreen(),
    );
  }
}

// main.dart এর বাকি অংশ

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final Box<Transaction> transactionBox = Hive.box<Transaction>('transactions');
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  // একটি নতুন ট্রানজেকশন যোগ করার ফাংশন
  void _addTransaction() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isNotEmpty && amount > 0) {
      final newTransaction = Transaction(
        title: title,
        amount: amount,
        isExpense: true, // আপাতত সবগুলোকে ব্যয় হিসেবে ধরা হচ্ছে
        createdAt: DateTime.now(),
      );

      transactionBox.add(newTransaction); // বক্সে নতুন ডেটা যোগ করা হলো

      _titleController.clear();
      _amountController.clear();
      Navigator.of(context).pop(); // ডায়ালগ বন্ধ করা
    }
  }

  // ট্রানজেকশন ডিলিট করার ফাংশন
  void _deleteTransaction(int index) {
    transactionBox.deleteAt(index); // নির্দিষ্ট ইনডেক্স থেকে ডেটা ডিলিট করা হলো
  }

  // ডেটা যোগ করার জন্য একটি ডায়ালগ দেখানোর ফাংশন
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
              TextField(controller: _amountController, decoration: InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
            ElevatedButton(onPressed: _addTransaction, child: Text('Add')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Transaction Tracker'),
      ),
      body: ValueListenableBuilder(
        // ValueListenableBuilder স্বয়ংক্রিয়ভাবে বক্সের পরিবর্তন শুনে এবং UI আপডেট করে
        valueListenable: transactionBox.listenable(),
        builder: (context, Box<Transaction> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No transactions yet.'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final transaction = box.getAt(index)!;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(transaction.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${transaction.createdAt.toLocal()}'.split(' ')[0]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '৳${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction.isExpense ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red.shade200),
                        onPressed: () => _deleteTransaction(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}