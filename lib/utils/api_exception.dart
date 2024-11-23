// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

// no internet exception
class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

// bad request bole toh 400 status code
class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message, "");
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message]) : super(message, "");
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
    case 202:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 204:
      return true;
    case 400:
    case 401:
      var responseJson = json.decode(response.body.toString());
      throw BadRequestException(capitalize(responseJson['message']));
    case 403:
      var responseJson = json.decode(response.body.toString());
      throw UnauthorisedException(capitalize(responseJson['message']));
    case 404:
      throw FetchDataException("Page not found");
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
