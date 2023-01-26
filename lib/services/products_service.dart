import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:seccion12_fluttercourse/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-f59de-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;

  File? newPictureFile;

  ProductsService() {
    this.loadProducts();
  }

//
  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(response.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();

    return this.products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // Crear nuevo producto
      await this.createProduct(product);
    } else {
      // Actualizar product
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product productUpdated) async {
    final url = Uri.https(_baseUrl, 'products/${productUpdated.id}.json');
    final response = await http.put(url, body: productUpdated.toJson());

    final index = this.products.indexWhere((prod) => prod.id == productUpdated.id);
    this.products[index] = productUpdated;

    return productUpdated.id!;
  }

  Future<String> createProduct(Product newProduct) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.post(url, body: newProduct.toJson());
    final decodedData = json.decode(response.body);

    newProduct.id = decodedData['name'];

    this.products.add(newProduct);

    return newProduct.id!;
  }

  void updateSelectedProductImage(String path) {
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dqnudwull/image/upload?upload_preset=yrf5yjmx');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Algo salió mal subiendo la imagen a Cloudinary');
      print(response.body);
      return null;
    }

    this.newPictureFile = null;

    final decodedData = jsonDecode(response.body);
    
    return decodedData['secure_url'];
  }
}
