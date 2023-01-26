import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:seccion12_fluttercourse/providers/providers.dart';
import 'package:seccion12_fluttercourse/screens/home_screen.dart';
import 'package:seccion12_fluttercourse/ui/input_decorations.dart';
import 'package:seccion12_fluttercourse/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routerName = 'Login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250,),
              CardContainer(
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text('Login', style: Theme.of(context).textTheme.headline4,),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                    create: ( _ ) => UserProvider(),
                    child: const _LoginForm(),
                  ),
                ]),
              ),
              const SizedBox(height: 50),
              const Text('Crear una nueva cuenta'),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<UserProvider>(context);

    return Container(
      child: Form(
        key: loginFormProvider.loginFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'usuario@email.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_outlined),
              onChanged: (value) => loginFormProvider.email = value,
              validator: (value) {
                if (value!.isEmpty) return "Debe ingresar el correo electrónico";

                RegExp emailRegExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

                return emailRegExp.hasMatch(value)
                  ? null
                  : 'Correo no válido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: '********',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline),
              onChanged: ( value ) => loginFormProvider.password = value,
              validator: (value) {
                if (value!.isEmpty) return "Debe ingresar la contraseña";

                return (value.length >= 6)
                  ? null
                  : 'La contraseña debe tener mínimo 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,              
              onPressed: loginFormProvider.isLoading 
                ? null 
                : () async {                
                  FocusScope.of(context).unfocus();
                  
                  if(!loginFormProvider.isValidForm()) return;

                  loginFormProvider.isLoading = true;

                  await Future.delayed(const Duration(seconds: 2));

                  // TODO: validar si el login es correcto
                  loginFormProvider.isLoading = false;

                  Navigator.pushReplacementNamed(context, HomeScreen.routerName);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginFormProvider.isLoading 
                    ? 'Espere'
                    : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
