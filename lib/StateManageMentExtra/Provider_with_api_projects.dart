//Practice Task 8.1
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ================= Provider Class =================

class ProductProvider with ChangeNotifier {
  bool _isLoading = false;
  List<dynamic> _productslist = [];

  bool get isLoading => _isLoading;

  List<dynamic> get productsList => _productslist;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse("https://fakestoreapi.com/products");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _productslist = jsonDecode(response.body);
    } else {
      _productslist = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}

///MAin App
void main() {
  runApp(
    ChangeNotifierProvider(create: (_)=>ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProviderProjApiIn(),
      ),
    )
  );
}
class ProviderProjApiIn extends StatelessWidget {
  const ProviderProjApiIn({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderControl = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider with API"),
        centerTitle: true,
      ),
      body: ProviderControl._isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ProviderControl.productsList.isEmpty ? Center(
        child: ElevatedButton(onPressed: (){
          ProviderControl.fetchProducts();
        }, child: Text("Load Products")),
      ) : ListView.builder(
        itemCount: ProviderControl.productsList.length,
          itemBuilder: (_,index){
          final productControl = ProviderControl.productsList[index];
          return Card(
            child: ListTile(
              leading: Image.network(productControl['image'],height: 50,width: 50,),
              title: Text(productControl['title']),
              subtitle: Text("\$${productControl['price']}"),
            ),
          );
          })
    );
  }
}
