import 'dart:convert';
import 'dart:io';

import 'package:form_app/src/pages/user_preferences/user_preferences.dart';
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';

import 'package:form_app/src/pages/models/producto_model.dart';
import 'package:http/http.dart' as http;
class ProductsProvider{
  final String _url = 'https://flutter-various-82e52.firebaseio.com';
  final _prefs = new UserPreferences();

  Future<bool>createProduct (ProductModel product) async{
    final url = '$_url/products.json?auth=${_prefs.token}';


    final ans = await http.post(url, body: productModelToJson(product));
    final decodedData = json.decode(ans.body);


    return true;
  }

  Future<bool>editProduct (ProductModel product) async{
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';


    final ans = await http.put(url, body: productModelToJson(product));
    final decodedData = json.decode(ans.body);

    return true;
  }

  Future<List<ProductModel>> loadProducts()async{

    final url = '$_url/products.json?auth=${_prefs.token}';
    final ans = await http.get(url);

    final Map<String, dynamic>decodedData = json.decode(ans.body);
    final List<ProductModel> products = new List();

    if(decodedData == null) return [];

    if(decodedData['error']!= null) return [];

    decodedData.forEach((id, prod){

      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;

      products.add(prodTemp);

    });

    return products;
  }

  Future<int> deleteProduct(String id) async{
    final url = "$_url/products/$id.json?auth=${_prefs.token}";
    final ans = await http.delete(url);

    print(ans.body);
    return 1;
  }
  
  Future <String> loadImage(File image) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dfg0yiszi/image/upload?upload_preset=huvbm1ei');
    final mimeType = mime(image.path).split('/'); //image/jpg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );
    final file = await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType(
            mimeType[0],
            mimeType[1]
        )
    );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final ans = await http.Response.fromStream(streamResponse);

    if(ans.statusCode!=200 && ans.statusCode!=201){
      print("something failed");
      print(ans.body);
      return null;
    }

    final respData = json.decode(ans.body);
    print(respData);


    return respData['secure_url'];
  }
}