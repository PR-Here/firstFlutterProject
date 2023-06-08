import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyLocalStorage.dart';

import '../../../utils/constant/MyRoutes.dart';

class LoginByEmail extends StatefulWidget {
  const LoginByEmail({Key? key}) : super(key: key);

  @override
  State<LoginByEmail> createState() => _LoginByEmailState();
}

class _LoginByEmailState extends State<LoginByEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  //Field validation and Login Api Called
  void validateAndSave(context) async {
    final myDataStorage = await MyLocalStorage();
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      FocusScope.of(context).unfocus();
      AppLoader.showLoader(context);
      try {
        final responce = await ApiCall.userLoginApi(
            _emailController.text.toString(),
            _passwordController.text.toString());
        if (responce.statusCode == 200) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(responce.body)['status'], 1, Colors.green);
          //create a object to store locally after login successfully
          var userDetails = {
            'token': jsonDecode(responce.body)['token'],
            'email': jsonDecode(responce.body)['data']['currentUser']['email'],
            'roleLength': jsonDecode(responce.body)['data']['currentUser']
                    ['role']
                ?.length,
            'availabilityStatus': jsonDecode(responce.body)['data']
                ['availabilityStatus'],
            'currentRole': jsonDecode(responce.body)['data']['currentUser']
                ['currentRole'],
            'ratingsAverage': jsonDecode(responce.body)['data']['currentUser']
                ['ratingsAverage'],
            'currentLanguage': jsonDecode(responce.body)['data']['currentUser']
                ['currentLanguage'],
          };
          print({'response.body', jsonDecode(responce.body)['data']['isAccountSetup']});
          myDataStorage.storeObject(userDetails);
          //Check here AccountSetup true or false and navigate accordingly
          if (jsonDecode(responce.body)['data']['isAccountSetup']) {
            Navigator.pushNamedAndRemoveUntil(
                context, MyRoutes.DashboardMap, (r) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, MyRoutes.PersonalInfoSetup, (r) => false, arguments: {
              "phoneCode": '',
              "mobile": _emailController.text,
              "loginType": 'email'
            });
          }
        } else {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(responce.body)['message'], 3, Colors.red);
        }
      } catch (error) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(context, error.toString(), 3, Colors.red);
        print({"LOGIN ERORR : ", error});
      }
    }
  }

  //Check Email validation
  bool validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //Email Id
              Container(
                constraints: BoxConstraints(
                  minHeight: height * .06,
                  minWidth: width * .90,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "Email id"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email id.';
                    } else if (!validateEmail(value)) {
                      return 'Please enter a valid email id.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: height * .03),
              //  Password
              Container(
                constraints: BoxConstraints(
                  minHeight: height * .06,
                  minWidth: width * .90,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password.';
                    } else if (value.length < 8) {
                      return 'Password should be minimum 8 digit.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: height * .01),
              //forgot password
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.ForgotByEmail);
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
              SizedBox(height: height * .04),
              //Login button
              InkWell(
                onTap: () {
                  validateAndSave(context);
                },
                child: Container(
                  height: height * .06,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Apply shadow offset
                        )
                      ]),
                  child: const Text("Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
