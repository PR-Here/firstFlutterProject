import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../utils/constant/MyImages.dart';
import '../../utils/constant/MyRoutes.dart';

var empty = 'Please enter OTP';
var notValid = 'Please enter a valid OTP';

class PasswordResetVerifyOtp extends StatefulWidget {
  const PasswordResetVerifyOtp({Key? key}) : super(key: key);

  @override
  State<PasswordResetVerifyOtp> createState() => _PasswordResetVerifyOtp();
}

class _PasswordResetVerifyOtp extends State<PasswordResetVerifyOtp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final otpController = OtpFieldController();
  String isOtpFill = '';
  String setOtp = '';
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  //Resend Otp Api
  void resendOtp(context, String email, String type) async {
    _secondsRemaining = 60;
    startTimer();
    AppLoader.showLoader(context);
    try {
      final response = await ApiCall.forgotPasswordByEmail(email, type,'');
      if (response.statusCode == 200) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context, "Resend Otp to : $email successfully", 2,Colors.green);
      } else {
        AppLoader.hideLoader(context);
      }
    } catch (err) {
      AppLoader.hideLoader(context);
      AppLoader.showSnackbar(context, err.toString(), 3,Colors.red);
    }

    // Call your resend OTP function here
  }

  //Field Validation And Verify Otp Api
  void validateField(
      context, String mobile, String type, String phoneCode) async {
    if (isOtpFill != '' && isOtpFill == 'ok') {
      AppLoader.showLoader(context);
      try {
        final response = await ApiCall.forgotPasswordOtpVerify(
            setOtp, mobile, phoneCode, type);
        print(response.statusCode);
        if (response.statusCode == 201) {
          AppLoader.hideLoader(context);
          Navigator.pushNamed(context, MyRoutes.ResetPassword,
              arguments: {"mobile": mobile, "otp": setOtp});
          setOtp = '';
          isOtpFill = '';
        } else {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(response.body)['message'], 3,Colors.red);
        }
      } catch (error) {
        print({error});
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(context, error.toString(), 3,Colors.red);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final mobileKey = args?['mobile'];
    final loginTypeKey = args?['type'];
    final phoneCodeKey = args?['phoneCode'];

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
                                image: AssetImage(MyImages.OTP_VERIFY))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "OTP Verify",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: height * .10,
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: height * .06),
                        child: OTPTextField(
                            controller: otpController,
                            length: 4,
                            width: width,
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldWidth: 45,
                            fieldStyle: FieldStyle.box,
                            outlineBorderRadius: 15,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            onChanged: (pin) {
                              if (pin.isEmpty) {
                                setState(() {
                                  isOtpFill = empty;
                                  setOtp = pin;
                                });
                              } else if (pin.length != 4) {
                                setState(() {
                                  isOtpFill = notValid;
                                  setOtp = pin;
                                });
                              } else {
                                setState(() {
                                  isOtpFill = 'ok';
                                  setOtp = pin;
                                });
                              }
                            },
                            onCompleted: (pin) {
                              FocusScope.of(context).unfocus();
                            }),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Visibility(
                          visible: isOtpFill != '' && isOtpFill == 'ok'
                              ? false
                              : true,
                          child: Text(
                            setOtp.isEmpty
                                ? "Please enter OTP"
                                : setOtp.length != 4
                                    ? "Please enter a valid OTP"
                                    : "",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .05,
                      ),
                      //  Verify Otp Button
                      InkWell(
                        onTap: () {
                          validateField(
                              context, mobileKey, loginTypeKey, phoneCodeKey);
                        },
                        child: Container(
                          width: width * .90,
                          constraints: BoxConstraints(minHeight: height * .06),
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
                            "Verify Otp",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .04,
                      ),
                      //Timer Here
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Text(
                              loginTypeKey == 'email'
                                  ? 'Please enter the confirmation code sent on your email.'
                                  : ""
                                      "Please enter the confirmation code sent on your mobile number.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              height: height * .04,
                            ),
                            InkWell(
                              onTap: () {
                                if (_secondsRemaining == 0) {
                                  if (_timer != null && _timer!.isActive) {
                                    _timer!.cancel();
                                  }

                                  resendOtp(context, mobileKey, loginTypeKey);
                                }
                              },
                              child: Text(
                                _secondsRemaining > 9
                                    ? '00:$_secondsRemaining Resend Code'
                                    : '00:0$_secondsRemaining Resend Code',
                                style: GoogleFonts.getFont('Sen'),
                              ),
                            ),
                          ],
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
