import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/constants.dart';
import '../helper/http_exception.dart';

class PaymentProvider with ChangeNotifier {
  Future<Map> createPaymentContext(
      String token, String type, String mongoId, List<String> members) async {
    try {
      //await Provider.of<Auth>(context, listen: false).refreshToken();
      final response = await http.post(
          Uri.parse('$serverURL/payment/context/create'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: json.encode(
              {"eventType": type, "eventId": mongoId, "members": members}));
      final responseData = json.decode(response.body);
      print(responseData);
      Future<Map> data = getContext(token, responseData['data']['contextId']);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      print(data);
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> getContext(String token, String contextId) async {
    try {
      final response = await http.post(
          Uri.parse('$serverURL/payment/context/get/$contextId'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      return responseData['data'];
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveUpiVerficationReq(File selectedimg, String token,
      String transactionId, String payeeName, String conId) async {
    Map<String, String> data = {
      "transactionId": transactionId.toString(),
      "payeeName": payeeName.toString(),
      "paymentContextId": conId.toString()
    };
    print(jsonEncode(data));
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$serverURL/payment/upi/request'));
      Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        "Authorization": "'Bearer $token"
      };
      print(headers);
      request.files.add(
        http.MultipartFile(
          'proof',
          selectedimg.readAsBytes().asStream(),
          selectedimg.lengthSync(),
          filename: selectedimg.path,
          // filename: selectedimg.path.split('/').last,
        ),
      );
      request.fields.addAll(data);
      request.headers.addAll(headers);
      print("request: " + request.toString());
      var res = await request.send();
      final response = await http.Response.fromStream(res);
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      rethrow;
    }
  }
}
