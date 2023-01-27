import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  String email    = '';
  String password = '';

  String _loginError = '';
  String get loginError => _loginError;
  set loginError(String value) {
    final Map<String, String> errors = {
      'EMAIL_NOT_FOUND': 'Correo electrónico no registado',
      'INVALID_PASSWORD': 'Contraseña incorrecta',
      'EMAIL_EXISTS': 'Correo electrónico ya registrado'
    };
    _loginError = errors[value] ?? value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;  
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isValidForm() {

    print(loginFormKey.currentState?.validate());

    print('$email - $password');

    return loginFormKey.currentState?.validate() ?? false;
  }
}
