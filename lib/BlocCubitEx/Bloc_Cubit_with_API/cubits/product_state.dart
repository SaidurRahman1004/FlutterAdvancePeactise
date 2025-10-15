import 'package:equatable/equatable.dart';
import '../models/product_model.dart';

class ProductState extends Equatable{
@override
List<Object> get props => [];

}

class ProductInitialState extends ProductState{}                       // initial state For Cubit //App Load Nothing Happens   //Initial Stage
class ProductLoadingState extends ProductState{}                      // Loading State For Cubit //App Ui or Data  Loading  //Loading Stage
// ProductLoadedState Loaded State For Cubit //When App Ui or Data  Loaded Successfully
class ProductLoadedState extends ProductState{                        //Success Stage
  final List<ProductMdl> productsFromProductState;                                    // List of products

  ProductLoadedState(this.productsFromProductState);                                  // Constructor
  @override
  List<Object> get props => [productsFromProductState];                               // Equatable props ,Equatable will understand when data changes.

}

class ProductErrorState extends ProductState{                           // Error State For Cubit //When App Ui or Data  Loaded Failed;Error Stage
  final String errorMsg;
  ProductErrorState(this.errorMsg);
  @override
  List <Object> get props => [errorMsg];                                // Equatable props ,Equatable will understand when data changes.
}