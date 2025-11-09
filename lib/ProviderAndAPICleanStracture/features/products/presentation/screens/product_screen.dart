import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../logic/product_provider.dart';


class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products (Provider + Repository)"),
        actions: [
          IconButton(
            onPressed: productProvider.loadProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (productProvider.isLoading) {
            return Center(child: LoadingIndicator());
          } else if (productProvider.error != null) {
            return Center(child: Text("❌ ${productProvider.error}"));
          } else if (productProvider.products.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: productProvider.loadProducts,
                child: const Text("Load Products"),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (_, index) {
                final p = productProvider.products[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(p.image, height: 50, width: 50),
                    title: Text(p.title, maxLines: 1),
                    subtitle: Text("\$${p.price}", style: const TextStyle(color: Colors.teal)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

