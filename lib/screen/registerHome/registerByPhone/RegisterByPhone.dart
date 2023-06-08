import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyRoutes.dart';

class RegisterByPhone extends StatefulWidget {
  const RegisterByPhone({Key? key}) : super(key: key);

  @override
  State<RegisterByPhone> createState() => _RegisterByPhoneState();
}

class _RegisterByPhoneState extends State<RegisterByPhone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _mobileTextEditingController = TextEditingController();
  String isMobileNumberEmpty = '';
  String phoneCode = '+91';

  //filed validation here
  void validateField(context) async {
    FocusScope.of(context).unfocus();
    final FormState? form = _formKey.currentState;
    if (_mobileTextEditingController.text.isEmpty) {
      setState(() {
        isMobileNumberEmpty = 'notEntered';
      });
    } else if (_mobileTextEditingController.text.length < 6) {
      setState(() {
        isMobileNumberEmpty = 'notValid';
      });
    } else {
      setState(() {
        isMobileNumberEmpty = 'valid';
      });
    }
    if (form!.validate()) {
      AppLoader.showLoader(context);
      try {
        final responce = await ApiCall.registerApiSendOtp(
            _mobileTextEditingController.text,
            _passwordController.text,
            phoneCode,'phone');

        if (responce.statusCode == 200) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(context, 'Code Sent', 1,Colors.green);
          Navigator.pushNamed(context, MyRoutes.RegisterOtp, arguments: {
            "mobile": _mobileTextEditingController.text,
            "loginType": "phone",
            "password": _passwordController.text,
            "phoneCode": phoneCode
          });
        } else {
          AppLoader.hideLoader(context);
          final responseBody = jsonDecode(responce.body);
          AppLoader.showSnackbar(context, responseBody['message'], 3,Colors.red);
        }
      } catch (error) {
        AppLoader.showSnackbar(context, error.toString(), 1,Colors.red);
      }
    }
  }

  //get country code
  handleCountryCodeChange(CountryCode? countryCode) {
    // print({"countryCode... ",countryCode});
    setState(() {
      phoneCode = countryCode.toString();
    });
  }
  //Validate mobile number when user typing
  validateMobileNumber(context) async {
    AppLoader.showLoader(context);
    try {
      final response = await ApiCall.validateMobileNumber(
          _mobileTextEditingController.text, phoneCode);
      print(response.statusCode);
      if (response.statusCode == 200) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context, 'Mobile number verified', 3, Colors.green);
        setState(() {
          isMobileNumberEmpty='valid';
        });
      } else {
        setState(() {
          isMobileNumberEmpty='notValid';
        });
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context, 'Not a valid Mobile number. Please check with Country code and try again!!', 3, Colors.red);
      }
    } catch (err) {
      AppLoader.hideLoader(context);
      AppLoader.showSnackbar(context, err.toString(), 3, Colors.red);
    }
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
        child: Stack(
          children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Mobile no
              Container(
                height:50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white,
                  border: Border.all(
                    color: isMobileNumberEmpty == 'notEntered' ||
                            isMobileNumberEmpty == 'notValid'
                        ? Colors.red
                        : Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CountryCodePicker(
                          onChanged: handleCountryCodeChange,
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          showFlag: true,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _mobileTextEditingController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Mobile number"),
                          onChanged: (text) {
                            if (text.length == 10 ||
                                text.length > 12) {
                              validateMobileNumber(context);
                            }else{
                              setState(() {
                                isMobileNumberEmpty='notValid';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .0,
              ),
              //Mobile Error Msg
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Visibility(
                  visible: isMobileNumberEmpty == 'notEntered' ||
                          isMobileNumberEmpty == 'notValid'
                      ? true
                      : false,
                  child: Text(
                    isMobileNumberEmpty == 'notEntered'
                        ? "Please enter mobile number"
                        : isMobileNumberEmpty == 'notValid'
                            ? "Please enter a valid mobile number."
                            : "",
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: height * .03),
              //  Password
              Container(
                constraints: BoxConstraints(minHeight: height * .06),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "password",
                      errorStyle: TextStyle(color: Colors.red)),
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
              //  confirm password
              Container(
                constraints: BoxConstraints(minHeight: height * .06),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "confirm password",
                      errorStyle: TextStyle(color: Colors.red)),
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
        ]),
      ),
    );
  }
}
