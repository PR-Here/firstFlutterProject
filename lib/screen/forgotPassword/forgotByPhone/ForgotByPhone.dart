import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyRoutes.dart';

import '../../../utils/constant/MyImages.dart';

class ForgotByPhone extends StatefulWidget {
  const ForgotByPhone({Key? key}) : super(key: key);

  @override
  State<ForgotByPhone> createState() => _ForgotByPhoneState();
}

class _ForgotByPhoneState extends State<ForgotByPhone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _mobileTextEditingController = TextEditingController();
  String isMobileNumberEmpty = '';
  String phoneCode = '+91';

  //Field validation and Api call
  void validateField(context) async {
    if (_mobileTextEditingController.text.isEmpty) {
      setState(() {
        isMobileNumberEmpty = 'notEntered';
      });
    } else if (_mobileTextEditingController.text.length < 9) {
      setState(() {
        isMobileNumberEmpty = 'notValid';
      });
    } else {
      setState(() {
        isMobileNumberEmpty = 'valid';
      });
    }
    if (isMobileNumberEmpty == 'valid') {
      AppLoader.showLoader(context);
      try {
        final response = await ApiCall.forgotPasswordByEmail(
            _mobileTextEditingController.text, 'phone', phoneCode);
        if (response.statusCode == 200) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(response.body)['message'], 3, Colors.green);
          Navigator.pushNamed(context, MyRoutes.PasswordResetVerifyOtp,arguments: {
            "type": "phone",
            "mobile": _mobileTextEditingController.text,
            "phoneCode": phoneCode
          });
        } else {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(response.body)['message'], 3, Colors.red);
        }
      } catch (err) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(context, err.toString(), 3, Colors.red);
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: (){

          },
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width,
                          height: height * .20,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(MyImages.FORGOT_PASSSWORD))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: height * .10,
                        ),
                        Container(
                          width: width * .90,
                          padding: const EdgeInsets.only(bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * .03,
                                ),
                                //mobile number field
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: isMobileNumberEmpty ==
                                                  'notEntered' ||
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
                                            keyboardType:
                                                TextInputType.number,
                                            controller:
                                                _mobileTextEditingController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Mobile number"),
                                            onChanged: (text) {
                                              if (text.length == 10 ||
                                                  text.length > 12) {
                                                validateMobileNumber(context);
                                              }else if(text==''){
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
                                  height: height * .01,
                                ),
                                //Mobile Error Msg
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Visibility(
                                    visible:
                                        isMobileNumberEmpty == 'notEntered' ||
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
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
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
                                    height: 50,
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
                        ),
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
                              fontSize: 16,
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
      ),
    );
  }
}
