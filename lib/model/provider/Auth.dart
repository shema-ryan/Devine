import 'package:devine/model/error/http_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _email;
  String get token {
    if (_token != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }
    return null;
  }

  void logOut() {
    _token = null;
    notifyListeners();
  }

  bool get authMode {
    return token != null;
  }

  String get email {
    return _email;
  }

  Future<void> signUp({String email, String password}) async {
    const String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key= AIzaSyDneAmxRBxdtk277mifs9vqmZ1NDRBy_Cw';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpError(message: responseData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> sigIn({String email, String password}) async {
    const String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key= AIzaSyDneAmxRBxdtk277mifs9vqmZ1NDRBy_Cw';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpError(message: responseData['error']['message']);
      }
      _email = responseData['email'];
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      print(_email);
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> resetPassword({String email}) async {
    print('the email is ...... $email');
    const String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyDneAmxRBxdtk277mifs9vqmZ1NDRBy_Cw';
    try {
      final response = await http.post(url,
          body: json.encode({
            'requestType': "PASSWORD_RESET",
            'email': email,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpError(message: responseData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }
}
