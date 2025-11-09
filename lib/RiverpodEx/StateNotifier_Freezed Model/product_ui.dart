import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'productNotifier.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productNotifierProvider);
    final productNotifier = ref.read(productNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: () {
              productNotifier.fetchProducts();
            },
            icon: Icon(Icons.refresh, color: Colors.red),
          ),
        ],
      ),
      body: productState.when(
        data: (products) =>
            ListView.builder(
              itemCount: products.length,
                itemBuilder: (_, index) => ListTile(
                  leading: Image.network(products[index].image,height: 50,width: 50,),
                  title: Text(products[index].title,maxLines: 1,),
                  subtitle: Text("\$ ${products[index].price.toString()}"),




            )),
        error: (err, _) => Center(child: Text("Error: $err")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
