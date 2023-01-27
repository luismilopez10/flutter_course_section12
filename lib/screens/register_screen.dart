import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:seccion12_fluttercourse/providers/providers.dart';
import 'package:seccion12_fluttercourse/screens/screens.dart';
import 'package:seccion12_fluttercourse/services/services.dart';
import 'package:seccion12_fluttercourse/theme/app_theme.dart';
import 'package:seccion12_fluttercourse/ui/input_decorations.dart';
import 'package:seccion12_fluttercourse/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  static const String routerName = 'Register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => LoginProvider(),
        child: AuthBackground(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 250,),
                CardContainer(
                  child: Column(children: [
                    const SizedBox(height: 10),
                    Text('Crear cuenta', style: Theme.of(context).textTheme.headline4,),
                    const SizedBox(height: 30),
                    _RegisterForm(),
                  ]),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, LoginScreen.routerName),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(AppTheme.primary.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                  ),
                  child: const Text('Ya tengo una cuenta', style: TextStyle(fontSize: 16, color: Colors.black87),),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _RegisterForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginProvider>(context);

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
            const SizedBox(height: 15),
            loginFormProvider.loginError.isNotEmpty
            ? Row(
                children: [
                  const SizedBox(width: 10,),
                  const Icon(Icons.error_outline, color: AppTheme.warning,),
                  const SizedBox(width: 5,),
                  Text(loginFormProvider.loginError, style: const TextStyle(color: AppTheme.warning),),
                ],
              )
            : Container(),
            const SizedBox(height: 25),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,              
              onPressed: loginFormProvider.isLoading 
                ? null 
                : () async {
                  FocusScope.of(context).unfocus();
                  final authService = Provider.of<AuthService>(context, listen: false);
                  
                  if(!loginFormProvider.isValidForm()) return;

                  loginFormProvider.isLoading = true;

                  // TODO: validar si el login es correcto
                  final String? errorMessage = await authService.createUser(loginFormProvider.email, loginFormProvider.password);

                  loginFormProvider.isLoading = false;

                  if (errorMessage == null) {
                    loginFormProvider.loginError = '';
                    Navigator.pushReplacementNamed(context, HomeScreen.routerName);
                    return;
                  }

                  loginFormProvider.loginError = errorMessage;
                  print(errorMessage);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginFormProvider.isLoading 
                    ? 'Espere'
                    : 'Registrarse',
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
