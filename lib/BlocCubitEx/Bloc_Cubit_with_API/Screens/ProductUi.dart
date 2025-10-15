import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/product_cubit.dart';
import '../cubits/product_state.dart';

class ProductCubitExUi extends StatelessWidget {
  const ProductCubitExUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Cubit Example'),
        leading: FlutterLogo(),
      ),
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
            builder: (_, state) {
              if (state is ProductInitialState) {
                return Center(
                  child: OutlinedButton(onPressed:()=> context.read<ProductCubit>().FetchProducts(), child: Text("Load Products")),         // context.read<ProductCubit>().FetchProducts() Accessing Cubit and calling FetchProducts
                );

              }
              else if (state is ProductLoadingState) {
                return Center(child: CircularProgressIndicator());

              }
              else if (state is ProductLoadedState) {
                return ListView.builder(
                  itemCount: state.productsFromProductState.length,
                    itemBuilder: (_,index){
                      final productsAccess = state.productsFromProductState[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(productsAccess.image!,height: 50,width: 50,),
                          title: Text(productsAccess.title!,maxLines: 1,),
                          subtitle: Text("\$${productsAccess.price!.toString()}",style: TextStyle(color: Colors.blue),),

                        ),
                      );
                    }
                );
              }
              else if(state is ProductErrorState){
                return Center(child: Text('Error: ${state.errorMsg}'));
              }
              return SizedBox();
            }
        ),
      ),
    );
  }
}
