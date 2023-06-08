import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLoader {
  static showLoader(BuildContext context) {
    EasyLoading.show(status: 'Please wait...');
  }

  static hideLoader(BuildContext context) {
    EasyLoading.dismiss();
  }

//  Snackbar
  static void showSnackbar(BuildContext context, String message, int duration,Color color) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Align(
          alignment: Alignment.topCenter,
          child: Text(
            message,
            style: GoogleFonts.getFont('Sen'),
          ),
        ),
        backgroundColor: color,
        duration: Duration(seconds: duration),
        behavior: SnackBarBehavior.floating,
        // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      ),
    );
  }
}
