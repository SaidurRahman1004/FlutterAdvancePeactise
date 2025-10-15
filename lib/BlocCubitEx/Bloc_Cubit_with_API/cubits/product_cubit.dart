import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttert_test_code/BlocCubitEx/Bloc_Cubit_with_API/cubits/product_state.dart';
import 'package:fluttert_test_code/BlocCubitEx/Bloc_Cubit_with_API/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductCubit extends Cubit<ProductState>{
  ProductCubit():super(ProductInitialState());

  Future<void> FetchProducts() async{
    try{
      emit(ProductLoadingState());
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if(response.statusCode == 200){
        final List dataFromApi = jsonDecode(response.body);
        final productsAll = dataFromApi.map((dta)=>ProductMdl.fromJson(dta)).toList();
        emit(ProductLoadedState(productsAll));
      }else{
        emit(ProductErrorState('Failed to load products'));
      }
    }catch(e){
      emit(ProductErrorState(e.toString()));
    }
  }






}