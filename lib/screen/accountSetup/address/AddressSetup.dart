import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyLocalStorage.dart';

import '../../../utils/constant/MyImages.dart';
import '../../../utils/constant/MyRoutes.dart';

class AddressSetup extends StatefulWidget {
  const AddressSetup({Key? key}) : super(key: key);

  @override
  State<AddressSetup> createState() => _AddressSetupState();
}

class _AddressSetupState extends State<AddressSetup> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _houseNameController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _roadNameController = TextEditingController();

  //Field validation and Api Call
  validateField(context) async {
    FocusScope.of(context).unfocus();
    final myDataStorage = await MyLocalStorage().getObject();
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      AppLoader.showLoader(context);
      String city = _cityController.text;
      String roadName = _roadNameController.text;
      String zipCode = _zipCodeController.text;
      String houseName = _houseNameController.text;
      String latitude = '28.00000';
      String longitude = '7869.048';
      try {
        final response = await ApiCall.addressSetupApi(city, roadName, zipCode,
            houseName, latitude, longitude, myDataStorage!['token']);

        if (response.statusCode == 200) {
          AppLoader.hideLoader(context);
          AppLoader.showSnackbar(
              context, jsonDecode(response.body)['message'], 2, Colors.green);
          Future.delayed(const Duration(seconds: 1),()=>  Navigator.pushNamedAndRemoveUntil(context, MyRoutes.DashboardMap, (r) => false));
        }
      } catch (error) {
        AppLoader.hideLoader(context);
        AppLoader.showSnackbar(context, error.toString(), 3, Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(MyImages.Background),
                fit: BoxFit.fill,
                opacity: 0.4)),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: height * .15,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(MyImages.PERSONAL_SETUP))),
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    const Text(
                      "Account Setup",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height * .04,
                    ),
                    Container(
                      width: width * .90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: [
                          //  White border Area
                          SizedBox(
                            height: height * .03,
                          ),
                          const Text(
                            "Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          const Text(
                            "All the field marked with * are mandatory.",
                            style: TextStyle(color: Colors.black, fontSize: 11),
                          ),
                          SizedBox(
                            height: height * .04,
                          ),
                          //Road Name
                          Container(
                            constraints: BoxConstraints(
                              minHeight: height * .06,
                            ),
                            width: width * .80,
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,

                              decoration: const InputDecoration(
                                  labelText: 'Road name *',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "Road Name/Area/Colony"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter road name';
                                }
                                if (value.contains(' ')) {
                                  return 'Value should not contain blank spaces';
                                }
                                if (value.contains(
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                  return 'Value should not contain special characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .03,
                          ),
                          //House name
                          Container(
                            constraints: BoxConstraints(
                              minHeight: height * .06,
                            ),
                            width: width * .80,
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(
                              //       RegExp('[a-zA-Z]')),
                              // ],
                              decoration: const InputDecoration(
                                  labelText: 'House name',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "House No./Building Name"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter house name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .03,
                          ),
                          //Zipcode
                          Container(
                            constraints: BoxConstraints(
                              minHeight: height * .06,
                            ),
                            width: width * .80,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Zipcode *',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "Zip code/Postal Code"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter zipcode';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .03,
                          ),
                          //City
                          Container(
                            constraints: BoxConstraints(
                              minHeight: height * .06,
                            ),
                            width: width * .80,
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(
                              //       RegExp('[a-zA-Z]')),
                              // ],
                              decoration: const InputDecoration(
                                  labelText: 'City *',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "City"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter City.';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .04,
                          ),
                          //Continue Button
                          InkWell(
                            onTap: () {
                              validateField(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: width * .80,
                              height: height * .06,
                              margin: const EdgeInsets.only(bottom: 20.0),
                              decoration: BoxDecoration(
                                  color: Colors.brown,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context, MyRoutes.DashboardMap, (r) => false);
                        },
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
