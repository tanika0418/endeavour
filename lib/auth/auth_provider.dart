import 'dart:async';
import 'dart:convert';

import 'package:endeavour22/auth/user_model.dart';
import 'package:endeavour22/events/regietered_model.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token = '';
  UserModel? _userModel;
  List<RegisteredModel> _registered = [];

  bool get isAuth {
    return _token != '';
  }

  String get token {
    return _token;
  }

  UserModel? get userModel {
    return _userModel;
  }

  List<RegisteredModel> get registered {
    return _registered;
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/auth/signin'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      // LOGIN SUCCESSFUL
      _token = responseData['data']['access_token'];
      // String userEmail = decodeToken(_token)['email'];
      // print(userEmail);

      // SETTING UP LOCAL DATA
      const storage = FlutterSecureStorage();
      await storage.write(
          key: 'refreshToken', value: responseData['data']['refresh_token']);
      await storage.write(key: 'userToken', value: _token);
      await fetchUserData(_token);
      await storage.write(key: 'userId', value: _userModel!.id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
  // Map<String, dynamic> decodeToken(String token) {
  //   Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  //   print('Tokennnnnnnnnnnnnn  $decodedToken');
  //   return decodedToken;
  // }

  Future<void> tryAutoLogin(BuildContext context) async {
    const storage = FlutterSecureStorage();
    var check = await storage.containsKey(key: 'userToken');
    if (!check) {
      return;
    }
    var userToken = await storage.read(key: 'userToken');
    _token = userToken.toString();
    var status = await fetchUserData(_token);
    if (!status) {
      showErrorFlush(
        context: context,
        message: "User session expired please login again!",
      );
      await logout();
      return;
    }
    notifyListeners();
  }

  Future<bool> fetchUserData(String t) async {
    try {
      await refreshToken();
      final response = await http.get(
        Uri.parse('$serverURL/user/get'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token",
        },
      );
      final responseData = json.decode(response.body);
      print("fetchhhhhhhhhhhhhhh $responseData");
       if (responseData['hasError']){
        return false;
      }
      // update userModel
      final userData = UserModel.fromMap(responseData['data'] as Map);
      print(userData);
      _userModel = userData;
      final List<RegisteredModel> tempList = [];
      final registeredData = responseData['data']['endeavourUser']['teams'];
      final role = responseData['data']['endeavourUser']['iAmRoles'];
      for (var element in registeredData) {
        tempList.add(RegisteredModel.fromMap(element, role));
      }
      _registered = tempList;
      notifyListeners();
      return true;
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  // Future<void> fetchRegistered(String token) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$serverURL/api/user/registeredEvents'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": token,
  //       },
  //     );
  //     final responseData = json.decode(response.body);
  //     if (responseData['hasError']) {
  //       return;
  //     }
  //     // update registered...
  //     final List<RegisteredModel> tempList = [];
  //     for (var element in responseData['data']) {
  //       tempList.add(RegisteredModel.fromMap(element));
  //     }
  //     _registered = tempList;
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<void> signUp(String email, String password, String phoneNumber,
      String name, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "email": email,
          "contactNumber": phoneNumber,
          "password": password,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      // SIGNUP SUCCESSFUL
    } catch (error) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/forgotpassword/password'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      // REQUEST SEND
      Navigator.of(context).pop();
      showNormalFlush(
        context: context,
        message: responseData['message'],
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changePassword(
      String oldPass, String newPass, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$serverURL/forgotpassword/reset-password'),
        headers: {
          "content-Type": "application/json",
          "Authorization": _token,
        },
        body: json.encode({
          'oldPassword': oldPass,
          'newPassword': newPass,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      // CHANGE PASSWORD LINK SEND
      Navigator.of(context).pop();
      showNormalFlush(
        context: context,
        message: responseData['message'],
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProfile(String email, String contactNumber, bool eventPass, String clgName, String clgId, String course,
      String year, String name, BuildContext context, bool isFirstTime) async {
        var endeavourUser = {
        "college": clgName,
        "studentId": clgId,
        "course": course,
        "year": year,
        "eventPass": false
        };
        print(endeavourUser);
    try {
      final response = await http.post(
        Uri.parse('$serverURL/user/update'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token',
        },
        body: json.encode({"name":name, "email": email, "contactNumber": contactNumber, "endeavourUser": endeavourUser
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      // Again Fetch UserData
      await fetchUserData(_token);
      // Update Successful
      if (isFirstTime) {
        showNormalFlush(
          context: context,
          message: "Profile Completed Successfully!",
        );
      } else {
        Navigator.of(context).pop();
        showNormalFlush(
          context: context,
          message: "Profile Updated Successfully!",
        );
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = '';
    _userModel = null;
    _registered = [];
    notifyListeners();
    const storage = FlutterSecureStorage();
    storage.deleteAll();
    // UNSUBSCRIBE FROM THE FIREBASE MESSAGING SERVICE
    //await FirebaseMessaging.instance.unsubscribeFromTopic('Listen');
  }

  Future<void> refreshToken() async {
    //print('Refreshinggg');
    const storage = FlutterSecureStorage();
    var refreshtoken = await storage.read(key: 'refreshToken');
    String rtoken = refreshtoken.toString();
    final response = await http.post(
      Uri.parse('$serverURL/auth/refresh'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $rtoken",
      },
    );
    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['hasError']) {
      throw HttpException(responseData['message']);
    }
    rtoken = responseData['data']['refresh_token'];
    _token = responseData['data']['access_token'];
    await storage.write(key: 'refreshToken', value: rtoken);
    await storage.write(key: 'userToken', value: _token);
  }
}
