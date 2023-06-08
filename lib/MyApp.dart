import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_prep_flutter/screen/accountSetup/address/AddressSetup.dart';
import 'package:interview_prep_flutter/screen/accountSetup/personalInfo/PersonalInfoSetup.dart';
import 'package:interview_prep_flutter/screen/dashboard/dashboardMap/DashboardMap.dart';
import 'package:interview_prep_flutter/screen/forgotPassword/forgotByEmail/ForgotByEmail.dart';
import 'package:interview_prep_flutter/screen/forgotPassword/forgotByPhone/ForgotByPhone.dart';
import 'package:interview_prep_flutter/screen/loginHome/LoginHome.dart';
import 'package:interview_prep_flutter/screen/registerHome/RegisterHome.dart';
import 'package:interview_prep_flutter/screen/registerOtp/RegisterOtp.dart';
import 'package:interview_prep_flutter/screen/resetPassword/ResetPassword.dart';
import 'package:interview_prep_flutter/screen/resetPasswordrveifyOtp/PasswordResetVerifyOtp.dart';
import 'package:interview_prep_flutter/utils/constant/MyLocalStorage.dart';
import 'package:interview_prep_flutter/utils/constant/MyRoutes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> routes = {
      MyRoutes.loginHomeRoute: (_) => const LoginHome(),
      MyRoutes.RegisterHomeRoute: (context) => const RegisterHome(),
      MyRoutes.ForgotByEmail: (context) => const ForgotByEmail(),
      MyRoutes.ForgotByPhone: (context) => const ForgotByPhone(),
      MyRoutes.PasswordResetVerifyOtp: (context) =>
          const PasswordResetVerifyOtp(),
      MyRoutes.ResetPassword: (context) => const ResetPassword(),
      MyRoutes.RegisterOtp: (context) => const RegisterOtp(),
      MyRoutes.PersonalInfoSetup: (context) => const PersonalInfoSetup(),
      MyRoutes.AddressSetup: (context) => const AddressSetup(),
      MyRoutes.DashboardMap: (context) => const DashBoardMap(),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Interview Prep...',
      theme: ThemeData(
        fontFamily: GoogleFonts.sen().fontFamily,
      ),
      home: FutureBuilder(
        future: MyLocalStorage().getObject(),
        builder: (context, authResult) {
          if (authResult.connectionState == ConnectionState.waiting) {
            return (const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            ));
          } else {
            // ignore: unrelated_type_equality_checks
            if (authResult.data == true) {
              return const DashBoardMap();
            }
            return const LoginHome();
          }
        },
      ),
      initialRoute: MyRoutes.InitialRoute,
      routes: routes,
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child!);
      },
    );
  }
}
