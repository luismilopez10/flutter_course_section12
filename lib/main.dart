import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';
import 'share_preferences/preferences.dart';
import 'providers/providers.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode),),
      ChangeNotifierProvider(create: (_) => ProductsService(),),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: LoginScreen.routerName,
      routes: {
        LoginScreen.routerName: (_) => const LoginScreen(),
        HomeScreen.routerName: (_) => const HomeScreen(),
        ProductFormScreen.routerName: (_) => ProductFormScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
