//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:form_app/src/pages/bloc/products_bloc.dart';
import 'package:form_app/src/pages/bloc/provider.dart';
import 'package:form_app/src/pages/models/producto_model.dart';
import 'package:form_app/src/pages/providers/products_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadingProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcomehome'),
      ),
      body: _createList(productsBloc),
      floatingActionButton: _createButton(context),
    );
  }

  _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: ()=> Navigator.pushNamed(context, 'product'),
    );
  }

  Widget _createList(ProductsBloc productsBloc) {
      StreamBuilder(
        stream: productsBloc.productsStream,
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
          if(snapshot.hasData){
            final products = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i)=> _createItem(context,productsBloc , products[i]),
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }

  Widget _createItem(BuildContext context, ProductsBloc productsBloc, ProductModel product){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction)=> productsBloc.deleteProduct(product.id),
      child: Card(
        child: Column(
          children: <Widget>[
            (product.urlPhoto == null)
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              image:NetworkImage(product.urlPhoto),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            ListTile(
              title: Text('${product.title} - ${product.value}'),
              subtitle: Text(product.id),
              onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
            ),

          ],
        ),
      ),
    );

//
  }


}
