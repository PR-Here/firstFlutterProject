class ApiEndPoint {
  //BASE URL HERE
  static const String baseUrl = 'https://localkings.iknowsolution.com/api';

//  IMAGE URL
  static const String imageUrl =
      'https://localkings.iknowsolution.com/uploads/';

//  LOGIN API
  static const String userLoginByEmail = '/users/loginWithEmail'; //post
  static const String userLoginByPhone = '/users/loginWithMobile'; //post

  // Register Api
  static const String userRegisterByEmail = '/users/registerEmail'; //post
  static const String userRegisterByPhone = '/users/registerMobile'; //post
  static const String userRegisterVerifyOtp = '/users/verifyMobile'; //patch
  static const String userSendOtpForRegister = '/users/sendOtp'; //post


//  Forgot Password
  static const String forgotPassword = "/users/forgetPassword"; //post
  static const String forgotPasswordVerifyOtp = "/users/verifyOtp"; //patch
  static const String forgotPasswordResetPassword =
      "/users/resetPassword"; //patch

//Validate mobile number
  static const String validateMobileNumber = '/users/lookup'; //post

//  Account Setup Personal and address Info
  static const String accountSetupPersonalInfo = '/users/me'; //patch
  static const String accountSetupAddress = '/address'; //post
}
