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
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, LoginScreen.routerName);
          },
          icon: const Icon(Icons.logout_sharp),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 30),
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
