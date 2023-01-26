import 'package:flutter/material.dart';
import 'package:seccion12_fluttercourse/theme/app_theme.dart';

class LoadingScreen extends StatelessWidget {
   
  static const String routerName = 'Loading';
  
  const LoadingScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text('Productos'),
      ),
      body: const Center(
         child: CircularProgressIndicator(
          color: AppTheme.primary,
         ),
      ),
    );
  }
}