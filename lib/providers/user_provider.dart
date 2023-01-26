import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  String email    = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isValidForm() {

    print(loginFormKey.currentState?.validate());

    print('$email - $password');

    return loginFormKey.currentState?.validate() ?? false;
  }
}
