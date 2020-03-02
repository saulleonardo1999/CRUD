
import 'dart:io';

import 'package:form_app/src/pages/models/producto_model.dart';

import 'package:form_app/src/pages/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {
  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  loadingProducts()async{
    final products = await _productsProvider.loadProducts();
    _productsController.sink.add(products);

  }

  void addProduct (ProductModel product) async{
      _loadingController.sink.add(true);
      await _productsProvider.createProduct(product);
      _loadingController.sink.add(false);
  }

  Future<String> uploadPhoto (File photo) async{
    _loadingController.sink.add(true);
    final photoUrl = await _productsProvider.loadImage(photo);
    _loadingController.sink.add(false);
    return photoUrl;
  }

  void editProduct (ProductModel product) async{
    _loadingController.sink.add(true);
    await _productsProvider.editProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct (String id) async{

    await _productsProvider.deleteProduct(id);

  }

  dispose(){
    _productsController?.close();
    _loadingController?.close();
  }
}

