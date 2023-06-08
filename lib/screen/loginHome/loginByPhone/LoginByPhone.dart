import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/utils/constant/MyLocalStorage.dart';
import '../../../utils/ApiCall/ApiCall.dart';
import '../../../utils/constant/AppLoader.dart';
import '../../../utils/constant/MyRoutes.dart';

class LoginByPhone extends StatefulWidget {
  const LoginByPhone({Key? key}) : super(key: key);

  @override
  State<LoginByPhone> createState() => _LoginByPhoneState();
}

class _LoginByPhoneState extends State<LoginByPhone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _mobiletextEditingController = TextEditingController();
  final _passwordController = TextEditingController();

  String isMobileNumberEmpty = '';
  String phoneCode = '+91';

  //Field validation and Api Call
  void validateField(context) async {
    FocusScope.of(context).unfocus();
    final myDataStorage= await MyLocalStorage();
    final FormState? form = _formKey.currentState;
    if (_mobiletextEditingController.text.isEmpty) {
      setState(() {
        isMobileNumberEmpty = 'notEntered';
      });
    } else if (_mobiletextEditingController.text.length < 10) {
      setState(() {
        isMobileNumberEmpty = 'notValid';
      });
    } else {
      setState(() {
        isMobileNumberEmpty = 'valid';
      });
    }
    if (form!.validate()) {
      if (isMobileNumberEmpty == 'valid') {
        AppLoader.showLoader(context);
        try {
          final response = await ApiCall.userLoginByMobileApi(
              _mobiletextEditingController.text, _passwordController.text,phoneCode);
          if (response.statusCode == 200) {
            AppLoader.hideLoader(context);
            AppLoader.showSnackbar(
                context, jsonDecode(response.body)['status'], 1, Colors.green);
            //create a object to store locally after login successfully
            var userDetails = {
              'token': jsonDecode(response.body)['token'],
              'email': jsonDecode(response.body)['data']['currentUser']['email'],
              'roleLength': jsonDecode(response.body)['data']['currentUser']
              ['role']
                  ?.length,
              'availabilityStatus': jsonDecode(response.body)['data']
              ['availabilityStatus'],
              'currentRole': jsonDecode(response.body)['data']['currentUser']
              ['currentRole'],
              'ratingsAverage': jsonDecode(response.body)['data']['currentUser']
              ['ratingsAverage'],
              'currentLanguage': jsonDecode(response.body)['data']['currentUser']
              ['currentLanguage'],
            };
            print({'response.body', jsonDecode(response.body)['data']});
            myDataStorage.storeObject(userDetails);
            //Check here AccountSetup true or false and navigate accordingly
            if (jsonDecode(response.body)['data']['isAccountSetup']) {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyRoutes.DashboardMap, (r) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyRoutes.PersonalInfoSetup, (r) => false, arguments: {
                "phoneCode": phoneCode,
                "mobile": _mobiletextEditingController.text,
                "loginType": 'phone'
              });
            }
          } else {
            AppLoader.hideLoader(context);
            AppLoader.showSnackbar(
                context, jsonDecode(response.body)['message'], 1, Colors.red);
          }
        } catch (err) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(context, err.toString(), 3, Colors.red);
        }
      }
    }
  }

  //get country code
  handleCountryCodeChange(CountryCode? countryCode) {
    setState(() {
      phoneCode = countryCode.toString();
    });
  }

  //Validate mobile number when user typing
  validateMobileNumber(context) async {
    AppLoader.showLoader(context);
    try {
      final response = await ApiCall.validateMobileNumber(
          _mobiletextEditingController.text, phoneCode);
      print(response.statusCode);
      if (response.statusCode == 200) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context, 'Mobile number verified', 3, Colors.green);
        setState(() {
          isMobileNumberEmpty = 'valid';
        });
      } else {
        setState(() {
          isMobileNumberEmpty = 'notValid';
        });
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context,
            'This is Not a valid Mobile number. Please check with Country code and try again!!',
            3,
            Colors.red);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Mobile no
            Container(
              height: 50,
              alignment: Alignment.center,
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
                        favorite: const ['+91', 'IN'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _mobiletextEditingController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Mobile number"),
                        onChanged: (text) {
                          if (text.length == 10 || text.length > 12) {
                            validateMobileNumber(context);
                          } else {
                            setState(() {
                              isMobileNumberEmpty = 'notValid';
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
              height: height * .01,
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
              constraints: BoxConstraints(
                minHeight: height * .06,
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  hintText: "password",
                  errorStyle: TextStyle(
                    color: Colors.red,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  } else if (value.length < 8) {
                    return 'Password should be minimum 8 digit.';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: height * .01),
            //Forgot Password Text
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.ForgotByPhone);
                },
                child: const Text(
                  "Forgot Password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * .04),
            //Login Button
            InkWell(
              onTap: () {
                validateField(context);
              },
              splashColor: Colors.red,
              highlightColor: Colors.red,
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
    );
  }
}
