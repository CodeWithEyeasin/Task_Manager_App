import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:task_manager_app/presentation/controllers/auth_controller.dart';
import 'package:task_manager_app/presentation/data/models/response_object.dart';

class NetWorkCaller {
  static Future<ResponseObject> getRequest(String url) async {
    try {
      final Response response = await get(Uri.parse(url),headers:{
        'token': AuthController.accessToken ?? ''
      } );

      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
            isSuccess: true, statusCode: 200, responseBody: decodedResponse);
      } else {
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '');
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responseBody: '',
          errorMessage: e.toString());
    }
  }

  static Future<ResponseObject> postRequest(
      String url, Map<String, dynamic> body) async {
    try {
      final Response response = await post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {
            'Content-type': 'application/json',
            'token': AuthController.accessToken ?? ''
          });

      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
            isSuccess: true, statusCode: 200, responseBody: decodedResponse);
      }else if(response.statusCode==401){
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '');
      } else {
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
        errorMessage: 'Email/Password is incorrect! TryAgain');
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responseBody: '',
          errorMessage: e.toString());
    }
  }
}
