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
      ChangeNotifierProvider(create: (_) => AuthService(),),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: NotificationsService.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: CheckAuthScreen.routerName,
      routes: {
        LoginScreen.routerName: (_) => const LoginScreen(),
        RegisterScreen.routerName: (_) => const RegisterScreen(),
        HomeScreen.routerName: (_) => const HomeScreen(),
        ProductFormScreen.routerName: (_) => ProductFormScreen(),
        CheckAuthScreen.routerName: (_) => const CheckAuthScreen(),
      },
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
