import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/screen/loginHome/loginByEmail/LoginbyEmail.dart';
import 'package:interview_prep_flutter/screen/loginHome/loginByPhone/LoginByPhone.dart';
import 'dart:io' show Platform;

import '../../utils/constant/MyImages.dart';
import '../../utils/constant/MyRoutes.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // print({"width... ", Platform.isIOS ? width : 0, "height...  ", height});
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: GestureDetector(
        onTap: (){  FocusScope.of(context).unfocus();},
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(MyImages.Background),
                  fit: BoxFit.cover,
                  opacity: 0.3)),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //image login
                  Container(
                    height: height * .20,
                    width: width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(MyImages.Login), fit: BoxFit.contain),
                    ),
                  ),
                   SizedBox(
                    height: height * .03,
                  ),
                  //login text
                  const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  //White border Area
                  Container(
                    // height: height == 667.0 ? height * .50 : height * .42,
                    constraints:  BoxConstraints(
                      // minHeight:height == 667.0 ? height * .48 : height * .42,
                      minWidth:width * .90,
                    ),
                    width: width * .90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Apply shadow offset
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                         SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Email Login text
                            Container(
                              width: width * .30,
                              height: height * .05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: index == 0
                                      ? Colors.greenAccent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    index = 0;
                                  });
                                },
                                child: const Text(
                                  "Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            //Mobile Login Text
                            Container(
                              width: width * .30,
                              height: height * .05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: index == 1
                                      ? Colors.greenAccent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    index = 1;
                                  });
                                },
                                child: const Text(
                                  "Mobile",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 1,
                          width: width * .85,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: width,
                          margin:const EdgeInsets.only(bottom: 20.0),
                          constraints:  BoxConstraints(
                            minWidth:width * .90,
                          ),
                          child: index == 0
                              ? const LoginByEmail()
                              : const LoginByPhone(),
                        )
                      ],
                    ),
                  ),
                  //  text or login by
                   SizedBox(
                    height:  height *.03,
                  ),
                  const Text("Or login with"),
                   SizedBox(
                    height:  height *.03,
                  ),
                  //  social login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //  Google
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 60,
                          width: 60,
                          color: Colors.transparent,
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100/2))),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                  MyImages.GOOGLE,
                                  width: 30,
                                  height: 30,
                                ),
                              ))),
                        ),
                      ),
                       SizedBox(
                        width:  height *.01,
                      ),
                      //  Apple
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 60,
                          width: 60,
                          color: Colors.transparent,
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100/2))),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                  MyImages.APPLE,
                                  width: 30,
                                  height: 30,
                                ),
                              ))),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(
                    height: height * .03,
                  ),
                  //  Don't have account text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MyRoutes.RegisterHomeRoute);
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.brown, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
