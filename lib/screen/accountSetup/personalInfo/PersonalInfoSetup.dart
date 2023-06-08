import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interview_prep_flutter/utils/ApiCall/ApiCall.dart';
import 'package:interview_prep_flutter/utils/constant/AppLoader.dart';
import 'package:interview_prep_flutter/utils/constant/MyLocalStorage.dart';
import 'package:interview_prep_flutter/utils/popup/DatePickerPopup.dart';

import '../../../utils/constant/MyImages.dart';
import '../../../utils/constant/MyRoutes.dart';

class PersonalInfoSetup extends StatefulWidget {
  const PersonalInfoSetup({Key? key}) : super(key: key);

  @override
  State<PersonalInfoSetup> createState() => _PersonalInfoSetupState();
}

class _PersonalInfoSetupState extends State<PersonalInfoSetup> {
  final myDataStorage = MyLocalStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _mobileTextEditingController = TextEditingController();
  final _dobTextEditingController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String isMobileNumberEmpty = '';
  bool showDatePicker = false;
  String phoneCode = '+91';

  //Field validation and api call
  validateField(context, phoneCode) async {
    final storedObject = await myDataStorage.getObject();
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
    if (isMobileNumberEmpty == 'valid') {
      if (form!.validate()) {
        AppLoader.showLoader(context);
        try {
          final responce = await ApiCall.accountSetupPersonalInfo(
              _firstNameController.text,
              _lastNameController.text,
              _dobTextEditingController.text,
              _mobileTextEditingController.text,
              phoneCode,
              _emailController.text,
              storedObject!['token']);
          if (responce.statusCode == 200) {
            AppLoader.hideLoader(context);
            Navigator.pushNamed(context, MyRoutes.AddressSetup);
          } else {
            AppLoader.hideLoader(context);
            AppLoader.showSnackbar(
                context, jsonDecode(responce.body)['message'], 3, Colors.red);
          }
        } catch (err) {
          AppLoader.showSnackbar(context, err.toString(), 3, Colors.red);
        }
      }
    }
  }

  //Date picker Popup
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DatePickerPopup(
          message: 'Choose your D.O.B',
          onDialogClose: (date) {
            print({"STRING ... ", date.toString().substring(0, 11)});
            _dobTextEditingController.text = date.toString().substring(0, 11);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  //For not focus cursor on textFormField
  void _requestFocusOnAnotherWidget(BuildContext context) {
    FocusScope.of(context).unfocus();
    _focusNode.unfocus();
    setState(() {
      _showDialog(context);
    });
  }

  //Check Email validation
  bool validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  //Validate mobile number when user typing
  validateMobileNumber(context) async {
    AppLoader.showLoader(context);
    try {
      final response = await ApiCall.validateMobileNumber(
          _mobileTextEditingController.text, phoneCode ==''?'+91':phoneCode);
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
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final mobileKey = args?['mobile'];
    final loginTypeKey = args?['loginType'];
    phoneCode = args?['phoneCode'];

    //Set Value Directly into mobile and email field by condition.
    if (loginTypeKey == 'email') {
      _emailController.text = mobileKey;
    } else if (loginTypeKey == 'phone') {
      _mobileTextEditingController.text = mobileKey;
    }

    //get country code
    handleCountryCodeChange(CountryCode? countryCode) {
      setState(() {
        phoneCode = countryCode.toString();
      });
    }

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(MyImages.Background),
                  fit: BoxFit.fill,
                  opacity: 0.4)),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Stack(children: [
                    Column(
                      children: [
                        Container(
                          width: width,
                          height: height * .12,
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
                        //White area Border start from here
                        Container(
                          width: width * .90,
                          margin: const EdgeInsets.only(bottom: 20.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //  White border Area
                              SizedBox(
                                height: height * .04,
                              ),
                              const Text(
                                "Personal Information",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: height * .01,
                              ),
                              const Text(
                                "All the field marked with * are mandatory.",
                                style:
                                    TextStyle(color: Colors.black, fontSize: 11),
                              ),
                              SizedBox(
                                height: height * .04,
                              ),
                              //first Name
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                width: width * .80,
                                child: TextFormField(
                                  enabled: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  onTap: () {
                                    setState(() {
                                      showDatePicker = false;
                                    });
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z]')),
                                  ],
                                  decoration: const InputDecoration(
                                      labelText: 'First name *',
                                      border: OutlineInputBorder(),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10.0),
                                      hintText: "first name"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter first name';
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
                              //last name
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                width: width * .80,
                                child: TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  onTap: () {
                                    setState(() {
                                      showDatePicker = false;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Last name *',
                                      border: OutlineInputBorder(),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10.0),
                                      hintText: "last name"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    if (value.isNotEmpty && value.trimLeft().isEmpty) {
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
                              //dob
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                width: width * .80,
                                child: TextFormField(
                                  controller: _dobTextEditingController,
                                  onTap: () {
                                    _requestFocusOnAnotherWidget(context);
                                  },
                                  focusNode: _focusNode,
                                  decoration: const InputDecoration(
                                      labelText: 'D.O.B *',
                                      border: OutlineInputBorder(),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10.0),
                                      hintText: "d.o.b"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter D.O.B';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height * .03,
                              ),
                              //mobile no
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                width: width * .80,
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
                                      color: loginTypeKey == 'phone'
                                          ? Colors.grey[200]
                                          : Colors.white,
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
                                          enabled: loginTypeKey == 'phone'
                                              ? false
                                              : true,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          onTap: () {
                                            setState(() {
                                              showDatePicker = false;
                                            });
                                          },
                                          controller:
                                              _mobileTextEditingController,
                                          enabled: loginTypeKey == 'phone'
                                              ? false
                                              : true,
                                          keyboardAppearance: Brightness.light,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Mobile number *",
                                          ),
                                          onChanged: (text){
                                            if (text.length == 10 ||
                                                text.length > 12) {
                                              FocusScope.of(context).unfocus();
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
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
                              ),
                              SizedBox(
                                height: height * .03,
                              ),
                              //email id
                              Container(
                                constraints:
                                    BoxConstraints(minHeight: height * .06),
                                width: width * .80,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  onTap: () {
                                    setState(() {
                                      showDatePicker = false;
                                    });
                                  },
                                  enabled: loginTypeKey == 'email' ? false : true,
                                  decoration: InputDecoration(
                                    labelText: 'Email id *',
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    hintText: "email id",
                                    filled:
                                        loginTypeKey == 'email' ? true : false,
                                    fillColor: loginTypeKey == 'email'
                                        ? Colors.grey[200]
                                        : Colors.transparent,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter email id.';
                                    } else if (!validateEmail(value)) {
                                      return 'Please enter a valid email id.';
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
                                  validateField(context, phoneCode);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: width * .80,
                                  height: height * .06,
                                  margin: const EdgeInsets.only(bottom: 25.0),
                                  decoration: BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
