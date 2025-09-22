import 'package:flutter/material.dart';
import 'package:fluttert_test_code/haive%20Ex%20Wishlist/wishListProduct_model.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'wishlist_providerLogic.dart';

class wishListUi extends StatelessWidget {
  const wishListUi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductScreen(),
    );
  }
}

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final List<String> products = [
    "Smartphone",
    "Laptop",
    "Headphones",
    "Smart Watch",
    "LED TV",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              _showWishlistDialog(context);
            },
          ),
          // Wishlist Counter
          Consumer<WishlistProvider>(
            builder: (context, wishlist, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    wishlist.wishlistItems.length.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product),
            trailing: ElevatedButton(
              child: const Text("Add to Wishlist"),
              onPressed: () {
                context.read<WishlistProvider>().addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$product added to wishlist!")),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showWishlistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("My Wishlist"),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer<WishlistProvider>(
              builder: (context, wishlist, child) {
                if (wishlist.wishlistItems.isEmpty) {
                  return const Center(child: Text("Your wishlist is empty."));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: wishlist.wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = wishlist.wishlistItems.getAt(index);
                    if (item == null) {
                      return SizedBox.shrink(); // Return an empty widget if item is null
                    }
                    return ListTile(
                      title: Text(item.name),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context.read<WishlistProvider>().removeItem(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

