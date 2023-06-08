import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyRoutes.dart';

import '../../utils/constant/MyImages.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void validateField(context, String password, String conPassword, String otp,
      String mobile) async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      AppLoader.showLoader(context);
      try {
        final response = await ApiCall.forgotResetPasswordApi(
            otp, mobile, conPassword, password);
        print(response.body);
        if (response.statusCode == 200) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(response.body)['message'], 1,Colors.green);
          Future.delayed(const Duration(seconds: 2),
              () => {Navigator.pushNamed(context, MyRoutes.loginHomeRoute)});
        } else {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(response.body)['message'], 2,Colors.red);
        }
      } catch (error) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(context, error.toString(), 3,Colors.red);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final otp = args?['otp'];
    final mobile = args?['mobile'];

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(MyImages.Background),
                  fit: BoxFit.cover,
                  opacity: 0.4)),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Stack(alignment: Alignment.topCenter, children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width,
                        height: height * .20,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(MyImages.RESET_PASSWORD))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Password Reset",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: height * .10,
                      ),
                      Container(
                        width: width * .90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * .03,
                              ),
                              //new password
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  decoration: const InputDecoration(
                                      labelText: 'New Password',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      hintText: "Enter new password"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter new password.';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters long';
                                    }
                                    if (!RegExp(
                                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>])')
                                        .hasMatch(value)) {
                                      return 'Password must contain at least one \nuppercase letter, one lowercase letter, one number, and one \nspecial character';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              //confirm new password
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: true,
                                  controller: _confirmPasswordController,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm New Password',
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    hintText: "Enter new confirm password",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter confirm new password.';
                                    } else if (_confirmPasswordController
                                            .text !=
                                        _passwordController.text) {
                                      return 'Confirm password not match with the Password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height * .03,
                              ),
                              //  Verify Otp Button
                              InkWell(
                                onTap: () {
                                  validateField(
                                      context,
                                      _passwordController.text,
                                      _confirmPasswordController.text,
                                      otp,
                                      mobile);
                                },
                                child: Container(
                                  width: width * .90,
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  height: height * .06,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.circular(3.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.brown.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        )
                                      ]),
                                  child: const Text(
                                    "Done",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: width,
                      height: 50,
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
