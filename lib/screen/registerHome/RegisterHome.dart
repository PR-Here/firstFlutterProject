import 'package:flutter/material.dart';
import 'package:interview_prep_flutter/screen/registerHome/registerByPhone/RegisterByPhone.dart';
import 'package:interview_prep_flutter/screen/registerHome/registerbyEmail/RegisterByEmail.dart';

import '../../utils/constant/MyImages.dart';
import '../../utils/constant/MyRoutes.dart';

class RegisterHome extends StatefulWidget {
  const RegisterHome({Key? key}) : super(key: key);

  @override
  State<RegisterHome> createState() => _RegisterHomeState();
}

class _RegisterHomeState extends State<RegisterHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
              child: Stack(alignment: Alignment.topCenter, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //image login
                    Container(
                      height: height * .15,
                      width: width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(MyImages.SIGNUP),
                            fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //login text
                    const Text(
                      "Register",
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
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Email Login
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              //Mobile Login
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
                          //Condition Here
                          Container(
                            // color: Colors.grey,
                            width: width,
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: index == 0
                                ? const RegisterByEmail()
                                : const RegisterByPhone(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * .02),
                    Text(
                      index == 0
                          ? "We will send you a confirmation code on above email."
                          : "We will send you a confirmation code on above Mobile Number.",
                      style: const TextStyle(color: Colors.black, fontSize: 11),
                    ),
                    //  text or login by
                    SizedBox(
                      height: height * .04,
                    ),
                  ],
                ),
                //Already have an account text bottom
                Positioned(
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, MyRoutes.loginHomeRoute);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.brown, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
