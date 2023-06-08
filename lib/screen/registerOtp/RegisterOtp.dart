import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyRoutes.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../utils/constant/MyImages.dart';
import '../../utils/constant/MyLocalStorage.dart';

var empty = 'Please enter OTP';
var notValid = 'Please enter a valid OTP';

class RegisterOtp extends StatefulWidget {
  const RegisterOtp({Key? key}) : super(key: key);

  @override
  State<RegisterOtp> createState() => _RegisterOtpState();
}

class _RegisterOtpState extends State<RegisterOtp> {
  final myDataStorage = MyLocalStorage();
  final otpController = OtpFieldController();
  String isOtpFill = '';
  String setOtp = '';

  //Otp field validation and Otp verify Api
  validateField(context, String mobile, String loginType, String password,
      String phoneCode) async {
    if (isOtpFill != '' && isOtpFill == 'ok') {
      AppLoader.showLoader(context);
      try {
        final response = await ApiCall.registerByOtp(
            mobile, password, phoneCode, setOtp, loginType);
        if (response.statusCode == 201) {
          AppLoader.hideLoader(context);
          var userDetails = {
            'token': jsonDecode(response.body)['token'],
            'email': jsonDecode(response.body)['data']['email'],
            'roleLength': jsonDecode(response.body)['data']['role']?.length,
            'availabilityStatus':
                jsonDecode(response.body)['data']['availabilityStatus'],
            'currentRole': jsonDecode(response.body)['data']['currentRole'],
            'ratingsAverage': jsonDecode(response.body)['data']['ratingsAverage'],
            'currentLanguage': jsonDecode(response.body)['data']['currentLanguage'],
          };
          print({'response.body', jsonDecode(response.body)['data']});
          myDataStorage.storeObject(userDetails);
          Navigator.pushNamed(context, MyRoutes.PersonalInfoSetup, arguments: {
            "phoneCode": phoneCode,
            "mobile": mobile,
            "loginType": loginType
          });
          otpController.clear();
          setState(() {
            isOtpFill = '';
            setOtp = '';
          });
        } else {
          AppLoader.hideLoader(context);
          final responseBody = jsonDecode(response.body);
          AppLoader.showSnackbar(
              context, responseBody['message'], 3, Colors.red);
        }
      } catch (err) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(context, err.toString(), 2, Colors.red);
      }
    }
  }

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
  void resendOtp(context, String email, String password, String phoneCode,
      String type) async {
    AppLoader.showLoader(context);
    try {
      final response =
          await ApiCall.registerApiSendOtp(email, password, phoneCode, type);
      if (response.statusCode == 200) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(
            context, "Resend Otp to : $email successfully", 2, Colors.green);
        _secondsRemaining = 60;
        startTimer();
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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final mobileKey = args?['mobile'];
    final loginTypeKey = args?['loginType'];
    final passwordKey = args?['password'];
    final phoneCodeKey = args?['phoneCode'];

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(MyImages.Background),
                  fit: BoxFit.fill,
                  opacity: 0.4)),
          child: SafeArea(
            child: Stack(alignment: Alignment.topCenter, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      height: height * .30,
                      width: width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(MyImages.OTP_VERIFY))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Register Otp",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    OTPTextField(
                        controller: otpController,
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        style: TextStyle(fontSize: 17),
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
                          print("Completed: " + pin);
                        }),
                    SizedBox(
                      height: height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Visibility(
                        visible:
                            isOtpFill != '' && isOtpFill == 'ok' ? false : true,
                        child: Text(
                          setOtp.isEmpty
                              ? "Please enter OTP"
                              : setOtp.length != 4
                                  ? "Please enter a valid OTP"
                                  : "",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .04,
                    ),
                    InkWell(
                      onTap: () {
                        validateField(context, mobileKey, loginTypeKey,
                            passwordKey, phoneCodeKey);
                      },
                      child: Container(
                        width: width * .90,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // Apply shadow offset
                            ),
                          ],
                        ),
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
                                : "Please enter the confirmation code sent on your mobile number.",
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
                                resendOtp(context, mobileKey, passwordKey,
                                    phoneCodeKey, loginTypeKey);
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
                  bottom: 30,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
