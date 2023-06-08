import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyLocalStorage.dart';
import 'package:interview_prep_flutter/utils/constant/MyRoutes.dart';

class RegisterByEmail extends StatefulWidget {
  const RegisterByEmail({Key? key}) : super(key: key);

  @override
  State<RegisterByEmail> createState() => _RegisterByEmailState();
}

class _RegisterByEmailState extends State<RegisterByEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  //validate field and Register Api Called
  void validateField(context) async {
    FocusScope.of(context).unfocus();
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      AppLoader.showLoader(context);
      try {
        final response = await ApiCall.registerApiSendOtp(
            _emailController.text, _passwordController.text,'','email');
        if (response.statusCode == 200) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(context, "Code Sent",1,Colors.green);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamed(context, MyRoutes.RegisterOtp, arguments: {
              "mobile": _emailController.text,
              "loginType": "email",
              "password": _passwordController.text,
              "phoneCode": ""
            });
          });
        } else {
          AppLoader.hideLoader(context);
          final responseBody = jsonDecode(response.body);
          AppLoader.showSnackbar(context, responseBody['message'], 3,Colors.red);
        }
      } catch (error) {
        print(error);
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
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //Email Id
            Container(
              constraints:const BoxConstraints(minHeight: 50),
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
                    return 'Please enter a valid email id';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: height * .03),
            //  Password
            Container(
              constraints: BoxConstraints(minHeight: height * .06),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "password"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  }if(value.contains(' ')){
                    return 'Value should not contain blank spaces';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  if (!RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>])')
                      .hasMatch(value)) {
                    return 'Password must contain at least one\nuppercase letter, one lowercase letter,\none number, and one special character';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: height * .03),
            // confirm password
            Container(
              constraints: BoxConstraints(minHeight: height * .06),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "confirm password"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter confirm password';
                  }if(value.contains(' ')){
                    return 'Value should not contain blank spaces';
                  }
                  if (_confirmPasswordController.text !=
                      _passwordController.text) {
                    return 'Confirm password not match with the Password';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: height * .05),
            // Register Button
            InkWell(
              onTap: () {
                validateField(context);
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
                child: const Text("Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
