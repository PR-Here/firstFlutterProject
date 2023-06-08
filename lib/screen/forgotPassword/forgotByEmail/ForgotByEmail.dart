import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyRoutes.dart';

import '../../../utils/constant/MyImages.dart';

class ForgotByEmail extends StatefulWidget {
  const ForgotByEmail({Key? key}) : super(key: key);

  @override
  State<ForgotByEmail> createState() => _ForgotByEmailState();
}

class _ForgotByEmailState extends State<ForgotByEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void validateField(context) async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      AppLoader.showLoader(context);
      try {
        final responce =
            await ApiCall.forgotPasswordByEmail(_emailController.text,'email','');
        print(responce.statusCode);
        if (responce.statusCode == 200) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(context, 'Code Sent', 2,Colors.green);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamed(context, MyRoutes.PasswordResetVerifyOtp,
                arguments: {
                  "type": "email",
                  "mobile": _emailController.text,
                  "phoneCode": ""
                });
          });
        } else {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(responce.body)['message'], 3,Colors.red);
        }
      } catch (err) {
        AppLoader.showSnackbar(context, err.toString(), 3,Colors.red);
      }
    } else {}
  }

  //Check Email validation
  bool validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                                image: AssetImage(MyImages.FORGOT_PASSSWORD))),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      const Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: height * .10,
                      ),
                      //white border side
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
                              //email id field
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                      labelText: 'Email Id',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      hintText: "Enter registered email id"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter registered email id';
                                    } else if (!validateEmail(value)) {
                                      return 'Please enter a valid email id';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height * .03,
                              ),
                              //  Send Otp Button
                              InkWell(
                                onTap: () {
                                  validateField(context);
                                },
                                child: Container(
                                  width: width * .90,
                                  height: height * .06,
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.circular(3.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.brown,
                                          blurRadius: 0,
                                          offset: Offset(0, 1),
                                        )
                                      ]),
                                  child: const Text(
                                    "Send Otp",
                                    style: TextStyle(color: Colors.white),
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
                            fontSize: 18,
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
