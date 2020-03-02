import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_app/src/pages/bloc/products_bloc.dart';
import 'package:form_app/src/pages/bloc/provider.dart';
import 'package:form_app/src/pages/models/producto_model.dart';

import 'package:form_app/src/pages/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {


  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsBloc productBloc;

  bool _saving = false;

  File photo;

  ProductModel product = new ProductModel();


  @override
  Widget build(BuildContext context) {
    productBloc = Provider.productsBloc(context);

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData !=null){
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: ()=>_processImage(ImageSource.gallery)),
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: ()=>_processImage(ImageSource.camera))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _showPhoto(),
                  _createName(),
                  _createPrice(),
                  _createAvailable(),
                  _createButton()
                ],
              ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Product'
      ),
      onSaved: (value)=> product.title = value,
      validator: (value){
        if(value.length<3){
          return "Get product's Name";
        }else{
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: 'Price'
      ),
      onSaved: (value)=> product.value = double.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }else{
          return 'Only Numbers';
        }
      },
    );
  }

  Widget _createButton(){
    return RaisedButton.icon(
      onPressed: (_saving) ? null : _submit,
      icon: Icon(Icons.save),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      label: Text('Save'),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  void _submit()async{
    if(!formKey.currentState.validate()) return;
    formKey.currentState.save();


    setState(() {
      _saving = true;
    });

    if( photo != null){
      product.urlPhoto = await productBloc.uploadPhoto(photo);
    }


    if(product.id == null){
      productBloc.addProduct(product);
    }else{
      productBloc.editProduct(product);
    }



//    setState(() {
//      _saving = false;
//    });
    showSnackbar('Saved Register ');

    Navigator.pop(context);
  }

  void showSnackbar(String message){
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);

  }
  Widget _createAvailable(){
    return SwitchListTile(
      value: product.available,
      title: Text("Available"),
      activeColor: Colors.deepPurple,
      onChanged: (value)  => setState((){
        product.available = value;
      }),
    );
  }

  Widget _showPhoto(){
    if(product.urlPhoto!=null){

      return FadeInImage(
        image: NetworkImage(product.urlPhoto),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    }else{
      
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
      
    }
  }

  _processImage(ImageSource origin) async{
    photo = await ImagePicker.pickImage(
        source: origin
    );

    if (photo!=null){
      product.urlPhoto = null;

    }

    setState(() {});
  }
}
