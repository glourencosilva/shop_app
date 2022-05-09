import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class AuthProv with ChangeNotifier {


  late String _token = '';
  late DateTime _expiryDate = DateTime.now();
  late String _userId = '';
  late Timer _authTimer;

  bool get isAuth {
    return token.isNotEmpty;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate.toString().isNotEmpty &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token.isNotEmpty) {
      return _token;
    } else {
      return '';
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyChP2gZqzwrgpKJKhpjN3U99NbaSsE_WNE');
    try {
      var dataBody = jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });
      final response = await http.post(url, body: dataBody);
      //debugPrint(response.body);
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.tryParse(responseData['expiresIn'])!));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup({required String email, required String password}) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn({required String email, required String password}) async {
    return _authenticate(email, password, 'signInWithPassword');
  }


  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
  //
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   _autoLogout();
  //   return true;
  // }


  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    if (_authTimer.isActive) {
      _authTimer.cancel();
      !_authTimer.isActive;
    }
    notifyListeners();
    //final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    //prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer.isActive) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
