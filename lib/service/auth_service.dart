import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:todo/constant/api_routes.dart';
import 'package:todo/model/user_model.dart';
import 'package:todo/provier/auth_provider.dart';

import 'package:todo/utils/api_exception.dart';
import 'package:todo/utils/preferences.dart';

class AuthService {
  var normalHeader = {'Content-Type': 'application/json'};
  Preferences prefs = Preferences();

  Future<dynamic> isAuthApi(AuthProvider provider) async {
    try {
      String? token = await prefs.getStringItem("token");

      if (token == null) {
        throw UnauthorisedException("No token found");
      }

      normalHeader['Cookie'] = token;
      http.Response response = await http.get(
        Uri.parse(ApiRoutes.checkAuthApi),
        headers: normalHeader,
      );

      var responseBody = returnResponse(response);
      var user = UserModel.fromMap(responseBody);
      await prefs.setStringItem("username", user.username);
      await prefs.setStringItem("email", user.email);
      await prefs.setStringItem("fullname", user.fullname);
      provider.setUsername(user.username);
      provider.setFullname(user.fullname);
      provider.setEmail(user.email);

      return user;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> loginApi(
      AuthProvider provider, String username, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse(ApiRoutes.loginApi),
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
        headers: normalHeader,
      );

      var responseBody = returnResponse(response);
      var user = UserModel.fromMap(responseBody);

      await prefs.setStringItem("username", user.username);
      await prefs.setStringItem("email", user.email);
      await prefs.setStringItem("fullname", user.fullname);
      await prefs.setStringItem("token", response.headers['set-cookie']!);
      provider.setUsername(user.username);
      provider.setFullname(user.fullname);
      provider.setEmail(user.email);

      return user;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> registerApi(String username, String email) async {
    try {
      http.Response response = await http.post(
        Uri.parse(ApiRoutes.registerApi),
        body: jsonEncode({
          "username": username,
          "email": email,
        }),
        headers: normalHeader,
      );

      var responseBody = returnResponse(response);
      var registerData = RegisterResponseModel.fromMap(responseBody);

      return registerData;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> completeRegisterApi(
    AuthProvider provider,
    String username,
    String email,
    String password,
    String fullname,
    int otp,
  ) async {
    try {
      http.Response response = await http.post(
        Uri.parse(ApiRoutes.completeRegisterApi),
        body: jsonEncode({
          "username": username,
          "fullname": fullname,
          "email": email,
          "password": password,
          "otp": otp,
        }),
        headers: normalHeader,
      );

      var responseBody = returnResponse(response);
      var user = UserModel.fromMap(responseBody);

      await prefs.setStringItem("username", user.username);
      await prefs.setStringItem("email", user.email);
      await prefs.setStringItem("fullname", user.fullname);
      await prefs.setStringItem("token", response.headers['set-cookie']!);
      provider.setUsername(user.username);
      provider.setFullname(user.fullname);
      provider.setEmail(user.email);

      return user;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> deleteUserApi(int otp, AuthProvider provider) async {
    try {
      String? token = await prefs.getStringItem("token");

      if (token == null) {
        throw UnauthorisedException("No token found");
      }

      normalHeader['Cookie'] = token;
      http.Response response = await http.delete(
          Uri.parse(ApiRoutes.deleteUserApi),
          headers: normalHeader,
          body: json.encode({"otp": otp}));

      returnResponse(response);
      prefs.resetPreference();
      provider.clear();

      return true;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> logoutApi(AuthProvider provider, bool allDeviceLogout) async {
    try {
      String? token = await prefs.getStringItem("token");

      if (token == null) {
        throw UnauthorisedException("No token found");
      }

      normalHeader['Cookie'] = token;
      http.Response response = await http.post(
        Uri.parse(allDeviceLogout
            ? ApiRoutes.logoutFromAllDeviceApi
            : ApiRoutes.logoutApi),
        headers: normalHeader,
      );

      returnResponse(response);
      prefs.resetPreference();
      provider.clear();
      return true;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> otpRequestApi(String email, int requestType) async {
    try {
      http.Response response = await http.post(
        Uri.parse(ApiRoutes.otpRequestApi),
        headers: normalHeader,
        body: jsonEncode({
          "email": email,
          "requestType": requestType,
        }),
      );

      returnResponse(response);
      return true;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> verifyOtpApi(String email, int otp, int requestType) async {
    try {
      http.Response response = await http.post(
        Uri.parse(ApiRoutes.verifyOtpApi),
        headers: normalHeader,
        body: jsonEncode(
          {
            "email": email,
            "otp": otp,
            "requestType": requestType,
          },
        ),
      );

      returnResponse(response);
      return true;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> resetPasswordRequestApi(
      String username, String password) async {
    try {
      String? token = await prefs.getStringItem("token");

      if (token == null) {
        throw UnauthorisedException("No token found");
      }

      normalHeader['Cookie'] = token;

      http.Response response = await http.post(
        Uri.parse(ApiRoutes.resetPasswordRequestApi),
        headers: normalHeader,
        body: jsonEncode(
          {
            "username": username,
            "password": password,
          },
        ),
      );

      returnResponse(response);
      return true;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> resetPassowordApi(String email, String password) async {
    try {
      String? token = await prefs.getStringItem("token");

      if (token == null) {
        throw UnauthorisedException("No token found");
      }

      normalHeader['Cookie'] = token;

      http.Response response = await http.post(
        Uri.parse(ApiRoutes.resetPasswordApi),
        headers: normalHeader,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      returnResponse(response);
      return true;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> forgetPassowordApi(String email, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse(ApiRoutes.forgetPasswordApi),
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      returnResponse(response);
      return true;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  Future<dynamic> updateProfileService(
      AuthProvider provider, Map<String, String> profileRes) async {
    try {
      String? token = await prefs.getStringItem("token");

      if (token == null) {
        throw UnauthorisedException("No token found");
      }

      normalHeader['Cookie'] = token;

      http.Response response = await http.put(
        Uri.parse(ApiRoutes.updateUserProfileApi),
        headers: normalHeader,
        body: jsonEncode(profileRes),
      );

      var repsonseBody = returnResponse(response);
      UserModel user = UserModel.fromMap(repsonseBody);

      await prefs.setStringItem("username", user.username);
      await prefs.setStringItem("email", user.email);
      await prefs.setStringItem("fullname", user.fullname);

      provider.setUsername(user.username);
      provider.setFullname(user.fullname);
      provider.setEmail(user.email);

      return user;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }
}
