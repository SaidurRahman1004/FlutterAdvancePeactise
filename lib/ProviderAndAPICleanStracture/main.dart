import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/products/logic/product_provider.dart';
import 'features/products/presentation/screens/product_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clean Architecture Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ProductScreen(),
    );
  }
}
