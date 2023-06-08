import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interview_prep_flutter/utils/constant/ApiEndPoint.dart';
import 'package:interview_prep_flutter/utils/constant/MyString.dart';

class ApiCall {
//  Login by Email Api
  static Future<http.Response> userLoginApi(
      String email, String password) async {
    print({
      'LOGIN PARAMS : ',
      email,
      password,
      ApiEndPoint.baseUrl + ApiEndPoint.userLoginByEmail
    });
    final response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.userLoginByEmail),
      headers: {
        'Accept-Language': MyString.currentLanguage,
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'fcmToken': '',
        "currentLanguage": MyString.currentLanguage
      }),
    );
    return response;
  }

//  Login by mobile number
  static Future<http.Response> userLoginWithMobileNumber(
      String mobile, String password) async {
    print({
      'userLoginWithMobileNumber PARAMS : ',
      mobile,
      password,
      ApiEndPoint.baseUrl + ApiEndPoint.userLoginByPhone
    });
    final response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.userLoginByPhone),
      headers: {
        'Accept-Language': MyString.currentLanguage,
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'email': mobile,
        'password': password,
        'fcmToken': '',
        "currentLanguage": MyString.currentLanguage
      }),
    );
    return response;
  }

//  Login by Mobile number
  static Future<http.Response> userLoginByMobileApi(
      String mobile, String password, String phoneCode) async {
    print({
      'userLoginByMobileApi PARAMS : ',
      mobile,
      password,
      phoneCode,
      ApiEndPoint.baseUrl + ApiEndPoint.userLoginByPhone
    });
    final response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.userLoginByPhone),
      body: jsonEncode(<String, dynamic>{
        'mobile': mobile,
        'password': password,
        'fcmToken': '',
        "currentLanguage": MyString.currentLanguage,
        'phoneCode': phoneCode
      }),
      headers: {
        'Accept-Language': MyString.currentLanguage,
        'Content-Type': 'application/json'
      },
    );
    return response;
  }

//  Register Api for both email and mobile number to send Otp
  static Future<http.Response> registerApiSendOtp(String email, String password,
      String phoneCode, String registerType) async {
    print({
      'registerByEmail PARAMS : ',
      email,
      password,
      phoneCode,
      registerType,
      ApiEndPoint.baseUrl + ApiEndPoint.userSendOtpForRegister
    });
    final response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.userSendOtpForRegister),
      body: jsonEncode(<String, dynamic>{
        'mobile': email,
        'loginType': registerType == 'email' ? 'email' : 'phone',
        "currentLanguage": MyString.currentLanguage,
        "phoneCode": phoneCode,
      }),
      headers: {
        'Accept-Language': MyString.currentLanguage,
        'Content-Type': 'application/json'
      },
    );
    return response;
  }

//  Register By Otp
  static Future<http.Response> registerByOtp(String mobile, String password,
      String phoneCode, String Otp, String loginType) async {
    print({
      'registerByOtp PARAMS : ',
      mobile,
      password,
      phoneCode,
      Otp,
      loginType,
      ApiEndPoint.baseUrl + ApiEndPoint.userRegisterVerifyOtp
    });
    final response = await http.patch(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.userRegisterVerifyOtp),
      body: jsonEncode(<String, dynamic>{
        "otp": Otp,
        "fcmToken": "",
        "password": password,
        'mobile': mobile,
        'loginType': loginType,
        "phoneCode": phoneCode,
        "currentLanguage": MyString.currentLanguage,
      }),
      headers: {
        'Accept-Language': MyString.currentLanguage,
        'Content-Type': 'application/json'
      },
    );
    return response;
  }

//  Account Setup Personal Info Api
  static Future<http.Response> accountSetupPersonalInfo(
    String firstName,
    String lastName,
    String dob,
    String mobile,
    String phoneCode,
    String email,
    String token,
  ) async {
    print({
      'accountSetupPersonalInfo PARAMS : ',
      firstName,
      lastName,
      dob,
      phoneCode,
      mobile,
      email,
      token,
      ApiEndPoint.baseUrl + ApiEndPoint.accountSetupPersonalInfo
    });
    final response = await http.patch(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.accountSetupPersonalInfo),
      body: jsonEncode(<String, dynamic>{
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        'mobile': mobile,
        'dob': dob,
        "image": '',
        "phoneCode": phoneCode,
        "fcmToken": ""
      }),
      headers: {
        'Accept-Language': MyString.currentLanguage,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

//  Forgot Password by Email id
  static Future<http.Response> forgotPasswordByEmail(
      String email, String type, String phoneCode) async {
    print({
      'forgotPasswordByEmail PARAMS : ',
      email,
      type,
      phoneCode,
      ApiEndPoint.baseUrl + ApiEndPoint.forgotPassword
    });
    final response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.forgotPassword),
      body: jsonEncode(<String, dynamic>{
        'userEmail': email,
        'loginType': type,
        "phoneCode": phoneCode,
      }),
      headers: {
        'Accept-Language': MyString.currentLanguage,
        'Content-Type': 'application/json'
      },
    );
    return response;
  }

  // Forgot Password  Otp Verify Api
  static Future<http.Response> forgotPasswordOtpVerify(
      String otp, String mobile, String phoneCode, String type) async {
    print({
      'forgotPasswordOtpVerify PARAMS : ',
      otp,
      mobile,
      phoneCode = phoneCode == "" ? "" : phoneCode,
      type = type == "email" ? "email" : "phone",
      MyString.currentLanguage,
      ApiEndPoint.baseUrl + ApiEndPoint.forgotPasswordVerifyOtp
    });
    final response = await http.patch(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.forgotPasswordVerifyOtp),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': MyString.currentLanguage,
      },
      body: jsonEncode({
        "otp": otp,
        "mobile": mobile,
        "loginType": type == "email" ? "email" : "phone",
        "phoneCode": phoneCode == "" ? "" : phoneCode,
        "currentLanguage": MyString.currentLanguage,
      }),
    );
    return response;
  }

// Forgot  Reset Password Api
  static Future<http.Response> forgotResetPasswordApi(String otp, String mobile,
      String passwordConfirm, String password) async {
    print({
      'forgotResetPasswordApi PARAMS : ',
      otp,
      passwordConfirm,
      password,
      mobile,
      ApiEndPoint.baseUrl + ApiEndPoint.forgotPasswordResetPassword
    });
    final response = await http.patch(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.forgotPasswordResetPassword),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': MyString.currentLanguage,
      },
      body: jsonEncode(<String, dynamic>{
        'passwordConfirm': passwordConfirm,
        'password': password,
        "otp": otp,
        "email": mobile,
      }),
    );
    return response;
  }

//  Validate mobile number when user type into textFormField
  static Future<http.Response> validateMobileNumber(
      String mobile, String phoneCode) async {
    print({
      'validateMobileNumber PARAMS : ',
      mobile,
      phoneCode,
      ApiEndPoint.baseUrl + ApiEndPoint.validateMobileNumber
    });
    final response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.validateMobileNumber),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': MyString.currentLanguage,
      },
      body: jsonEncode(<String, dynamic>{
        "phoneCode": phoneCode,
        "mobile": mobile,
      }),
    );
    return response;
  }

//  Address Setup in Register Screen
  static Future<http.Response> addressSetupApi(
      String city,
      String roadName,
      String zipCode,
      String houseNo,
      String latitude,
      String longitude,
      String token) async {
    print({
      'addressSetupApi PARAMS : ',
      city,
      roadName,
      zipCode,
      houseNo,
      latitude,
      longitude,
      token,
      ApiEndPoint.baseUrl + ApiEndPoint.accountSetupAddress
    });
    final response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.accountSetupAddress),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': MyString.currentLanguage,
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "city": city,
        "roadName": roadName,
        "zipCode": zipCode,
        "houseNumber": houseNo,
        "addresstype": 'Home',
        "latitude": latitude,
        "longitude": longitude,
      }),
    );
    return response;
  }

//  Show LocalKing List in the Google Map Api
  static Future<http.Response> showLocalKingListApi(
      num latitude, num longitude, String token, String from) async {
    String url;
    from == "currentLocation"
        ? (url =
            '${ApiEndPoint.baseUrl}/users?sort=_id?ratingsAverage&search=&lat=${"$latitude&lng=$longitude"}&page=${1}&limit=1000')
        : from == "pagination"
            ? (url =
                '${ApiEndPoint.baseUrl}/users?sort=_id?ratingsAverage&search=&lat=${"$latitude&lng=$longitude"}&page=${1}&limit=1000')
            : from == "locationButton"
                ? (url =
                    '${ApiEndPoint.baseUrl}/users?sort=_id?ratingsAverage&search=&lat=${"$latitude&lng=$longitude"}&page=1&limit=1000')
                : from == "FromSearch"
                    ? (url =
                        '${ApiEndPoint.baseUrl}/users?sort=_id?ratingsAverage&search=true&lat=${"$latitude&lng=$longitude"}&page=1&limit=1000')
                    : (url =
                        '${ApiEndPoint.baseUrl}/users?sort=_id?ratingsAverage&search=true&lat=${"$latitude&lng=$longitude"}&page=1&limit=1000');
    print({
      'showLocalKingListApi PARAMS : ',
      latitude,
      longitude,
      token,
      url,
    });
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept-Language': MyString.currentLanguage,
      },
    );
    print({"1234567890 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&...",response.statusCode});
    return response;
  }
}
