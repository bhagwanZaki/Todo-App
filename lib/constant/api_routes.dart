class ApiRoutes {
  static String baseURL = "http://192.168.0.157:8000/api/";
  // auth apis
  static String checkAuthApi = '${baseURL}auth/checkauth';
  static String loginApi = '${baseURL}auth/login';
  static String registerApi = '${baseURL}auth/register';
  static String completeRegisterApi = '${baseURL}auth/register/complete';
  static String deleteUserApi = '${baseURL}auth/delete-user';
  static String logoutApi = '${baseURL}auth/logout';
  static String logoutFromAllDeviceApi =
      '${baseURL}auth/logout-from-all-device';
  static String otpRequestApi = '${baseURL}auth/otp-request';
  static String verifyOtpApi = '${baseURL}auth/verify-otp';
  static String resetPasswordRequestApi =
      '${baseURL}auth/reset-password-request';
  static String resetPasswordApi = '${baseURL}auth/reset-password';
  static String forgetPasswordApi = '${baseURL}auth/forget-password';
  static String updateUserProfileApi = '${baseURL}auth/update-user';

  // todo apis
  static String todoListApi = '${baseURL}todos';
  static String createTodoApi = '${baseURL}add';
  static String updateTodoApi = '${baseURL}update/';
  static String deleteTodoApi = '${baseURL}delete/';
}
  