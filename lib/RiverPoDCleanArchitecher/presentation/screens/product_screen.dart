import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttert_test_code/RiverPoDCleanArchitecher/presentation/screens/product_details_screen.dart';

import '../providers/product_notifier.dart';

class ProductUi extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue = ref.watch(productNotifiProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.read(productNotifiProvider.notifier).refreshProducts();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(productNotifiProvider.notifier).refreshProducts();
          },
          child: productAsyncValue.when(
            data: (data) {
              if(data.isEmpty){
                return Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                  itemBuilder: (_,index){
                  final product = data[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 5,
                    child: ListTile(
                      leading: Image.network(
                        product.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 50);
                        },

                      ),
                      title: Text(product.title ?? "No Title",maxLines: 1,),
                      trailing: Text('\$${product.price?.toStringAsFixed(2) ?? "N/A"}',),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.category, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  product.category ?? "No Category",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                product.rating != null
                                    ? '${product.rating!.rate} (${product.rating!.count} reviews)'
                                    : 'No Ratings',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailsScreen(product: product,) ));
                      },


                    ),
                  );

              });
            },
            error: (e, stack) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    color: Colors.red.shade50,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: Colors.red.shade200,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      // Padding inside the card
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline, // Error icon
                            color: Colors.red.shade700,
                            size: 28.0,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              'Error: $e',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: Text('Error, loading products')),
          ),
        ),
      ),
    );
  }
}
