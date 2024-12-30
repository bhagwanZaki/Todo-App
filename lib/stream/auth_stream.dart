import 'dart:async';

import 'package:todo/model/user_model.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/service/auth_service.dart';
import 'package:todo/utils/api_response.dart';

class AuthStream {
  late AuthService _authService;

  // controller
  late StreamController<ApiResponse<UserModel>> _authController;
  late StreamController<ApiResponse<RegisterResponseModel>>
      _verifyEmailController;
  late StreamController<ApiResponse<bool>> _boolController;

  // sink
  StreamSink<ApiResponse<UserModel>> get authSink => _authController.sink;
  StreamSink<ApiResponse<bool>> get boolSink => _boolController.sink;
  StreamSink<ApiResponse<RegisterResponseModel>> get verifyEmailSink =>
      _verifyEmailController.sink;

  // stream
  Stream<ApiResponse<UserModel>> get authStream => _authController.stream;
  Stream<ApiResponse<RegisterResponseModel>> get verifyEmailStream =>
      _verifyEmailController.stream;
  Stream<ApiResponse<bool>> get boolStream => _boolController.stream;

  // constructor
  AuthStream() {
    _authService = AuthService();
    _authController = StreamController<ApiResponse<UserModel>>();
    _boolController = StreamController<ApiResponse<bool>>();
    _verifyEmailController =
        StreamController<ApiResponse<RegisterResponseModel>>();
  }

  // methods

  checkAuth(AuthProvider provider) async {
    authSink.add(ApiResponse.loading("Calling api"));
    try {
      var data = await _authService.isAuthApi(provider);
      authSink.add(ApiResponse.completed(data));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      authSink.add(ApiResponse.error(e.toString()));
    }
  }

  login(AuthProvider provider, String username, String password) async {
    authSink.add(ApiResponse.loading("Calling api"));
    try {
      var data = await _authService.loginApi(provider, username, password);
      authSink.add(ApiResponse.completed(data));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      authSink.add(ApiResponse.error(e.toString()));
    }
  }

  register(String username, String email) async {
    verifyEmailSink.add(ApiResponse.loading("call register api"));
    try {
      RegisterResponseModel data =
          await _authService.registerApi(username, email);
      verifyEmailSink.add(ApiResponse.completed(data));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      verifyEmailSink.add(ApiResponse.error(e.toString()));
    }
  }

  completeRegisterApi(
    AuthProvider provider,
    String username,
    String email,
    String password,
    String fullname,
    int otp,
  ) async {
    authSink.add(ApiResponse.loading("call register api"));
    try {
      UserModel data = await _authService.completeRegisterApi(
        provider,
        username,
        email,
        password,
        fullname,
        otp,
      );
      authSink.add(ApiResponse.completed(data));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      authSink.add(ApiResponse.error(e.toString()));
    }
  }

  deleteUser(
    int otp,
    AuthProvider provider,
  ) async {
    boolSink.add(ApiResponse.loading("called delete user api"));
    try {
      bool status = await _authService.deleteUserApi(otp, provider);
      boolSink.add(ApiResponse.completed(status));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      boolSink.add(ApiResponse.error(e.toString()));
    }
  }

  logout(AuthProvider provider, bool allDeviceLogout) async {
    boolSink.add(ApiResponse.loading("called logout api"));
    try {
      bool status = await _authService.logoutApi(provider, allDeviceLogout);
      boolSink.add(ApiResponse.completed(status));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      boolSink.add(ApiResponse.error(e.toString()));
    }
  }

  otpRequest(String email, int requestType) async {
    boolSink.add(ApiResponse.loading("called otp request api"));
    try {
      bool status = await _authService.otpRequestApi(email, requestType);
      boolSink.add(ApiResponse.completed(status));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      boolSink.add(ApiResponse.error(e.toString()));
    }
  }

  verifyOtp(String email, int otp, int requestType) async {
    boolSink.add(ApiResponse.loading("called verify password change otp api"));
    try {
      bool status = await _authService.verifyOtpApi(email, otp, requestType);
      boolSink.add(ApiResponse.completed(status));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      boolSink.add(ApiResponse.error(e.toString()));
    }
  }

  resetPasswordRequest(String username, String password) async {
    boolSink.add(ApiResponse.loading("called reset password request api"));
    try {
      bool status =
          await _authService.resetPasswordRequestApi(username, password);
      boolSink.add(ApiResponse.completed(status));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      boolSink.add(ApiResponse.error(e.toString()));
    }
  }

  resetPassoword(String email, String password) async {
    boolSink.add(ApiResponse.loading("called reset password api"));
    try {
      bool status = await _authService.resetPassowordApi(email, password);
      boolSink.add(ApiResponse.completed(status));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      boolSink.add(ApiResponse.error(e.toString()));
    }
  }

  forgetPassoword(String email, String password) async {
    boolSink.add(ApiResponse.loading("called forget password api"));
    try {
      bool status = await _authService.forgetPassowordApi(email, password);
      boolSink.add(ApiResponse.completed(status));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      boolSink.add(ApiResponse.error(e.toString()));
    }
  }

  updateUserProfile(
      AuthProvider provider, Map<String, String> profileRes) async {
    authSink.add(ApiResponse.loading("Updateing user profile"));
    try {
      UserModel user =
          await _authService.updateProfileService(provider, profileRes);
      authSink.add(ApiResponse.completed(user));
    } catch (e) {
      print("ERROR : ${e.toString()}");
      authSink.add(ApiResponse.error(e.toString()));
    }
  }

  disposeBoolStream() {
    boolSink.add(ApiResponse.active());
    _boolController.close();
  }
}
