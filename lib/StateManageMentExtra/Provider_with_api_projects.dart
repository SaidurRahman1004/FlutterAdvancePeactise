//Practice Task 8.1 Provider with API Demo
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ================= Provider Class =================
class Product {
  final int id;
  final String title;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}

class ProductProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Product> _productslist = [];

  bool get isLoading => _isLoading;

  List<Product> get productsList => _productslist;

  int _cartItemCount = 0;
  int _wishListCount = 0;
  int get cartItemCount => _cartItemCount;
  int get wishListCount => _wishListCount;

  //fetch Product Provider Api Data Fetch
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse("https://fakestoreapi.com/products");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      
      final List data = jsonDecode(response.body);
      _productslist = data.map((e) => Product.fromJson(e)).toList();
    } else {
      _productslist = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  //add to cart
void addtoCart(Product product){
  _cartItemCount++;
    notifyListeners();
}

//WishList Provider Function
void wiashLishProduct(Product product){
  _wishListCount++;
    notifyListeners();
}

//Reset Function
void resetAll(){
  _cartItemCount = 0;
  _wishListCount = 0;
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
        actions: [
          TextButton.icon(onPressed: (){}, label: Text("${ProviderControl.cartItemCount}"),icon: Icon(Icons.shopping_cart,color: Colors.blue,)),
          TextButton.icon(onPressed: (){}, label: Text("${ProviderControl.wishListCount}"),icon: Icon(Icons.favorite,color: Colors.red,)),
          TextButton.icon(onPressed: (){
            ProviderControl.resetAll();
          }, label: Text("Reset"), icon: Icon(Icons.refresh,color: Colors.red,)),



        ],
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
            final productcntrl = ProviderControl.productsList[index];
            return Card(
              elevation: 5,
              child: ListTile(
                leading: Image.network(productcntrl.image,height: 50,width: 50,),
                title: Text(productcntrl.title,maxLines: 1,),
                subtitle: Text("\$${productcntrl.price}"),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: (){
                      ProviderControl.addtoCart(productcntrl);
                    },  icon: Icon(Icons.shopping_cart,color: Colors.blue,)),
                    IconButton(onPressed: (){
                      ProviderControl.wiashLishProduct(productcntrl);
                    },icon: Icon(Icons.favorite,color: Colors.red,)),
                  ],
                ),
              ),
            );


          }
      ),
    );
  }
}
