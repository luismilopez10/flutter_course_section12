import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:seccion12_fluttercourse/models/models.dart';
import 'package:seccion12_fluttercourse/screens/screens.dart';
import 'package:seccion12_fluttercourse/services/services.dart';
import 'package:seccion12_fluttercourse/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
  static const String routerName = 'Home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed(context, ProductFormScreen.routerName);
          },
          child: ProductCard(product: productsService.products[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsService.selectedProduct = Product(
            available: true, 
            name: '', 
            price: 0.0
          );
          Navigator.pushNamed(context, ProductFormScreen.routerName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
