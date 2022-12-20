import 'dart:convert';

import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/BankingSignIn.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class BankingSignUp extends StatefulWidget {
  static var tag = "/BankingSignUp";

  @override
  _BankingSignUpState createState() => _BankingSignUpState();
}

class _BankingSignUpState extends State<BankingSignUp> {
  bool isLoading = false;
  var client = http.Client();

  TextEditingController _namaController = TextEditingController(text: '');
  TextEditingController _profesiController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
  }

  signUp() async {
    setState(() {
      isLoading = true;
    });
    var formData = jsonEncode({
      "nama": _namaController.text,
      "profesi": _profesiController.text,
      "email": _emailController.text,
      "password": _passwordController.text
    });

    var response = await client.post(Uri.parse(baseUrl + "/registrasi"),
        body: formData, headers: {"Content-Type": "application/json"});

    var decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            decodedResponse ?? "Something wrong..",
            style: TextStyle(fontSize: 13),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.amber[600]));
      setState(() {
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign Up berhasil, silahkan login untuk memulai sesi.",
            style: TextStyle(fontSize: 13)),
        backgroundColor: Colors.greenAccent[400],
      ));

      setState(() {
        isLoading = false;
      });
      BankingSignIn().launch(context, isNewTask: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: isLoading
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(Banking_lbl_SignUp,
                              style: boldTextStyle(size: 30)),
                          EditText(
                              text: "Nama",
                              isPassword: false,
                              mController: _namaController),
                          8.height,
                          EditText(
                              text: "Profesi",
                              isPassword: false,
                              mController: _profesiController),
                          8.height,
                          EditText(
                              text: "Email",
                              isPassword: false,
                              mController: _emailController),
                          8.height,
                          EditText(
                              text: "Password",
                              isPassword: true,
                              isSecure: true,
                              mController: _passwordController),
                          8.height,
                          BankingButton(
                            textContent: Banking_lbl_SignUp,
                            onPressed: () {
                              signUp();
                            },
                          ),
                          16.height,
                          Column(
                            children: [
                              Text("Sudah punya akun ?",
                                  style: primaryTextStyle(
                                      size: 16,
                                      color: Banking_TextColorSecondary)),
                              16.height,
                              Text("Sign In",
                                      style: primaryTextStyle(
                                          size: 16,
                                          color: Banking_TextColorSecondary))
                                  .onTap(() {
                                BankingSignIn()
                                    .launch(context, isNewTask: true);
                              }),
                            ],
                          ).center(),
                        ],
                      ).center(),
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(Banking_lbl_app_Name.toUpperCase(),
                style: primaryTextStyle(
                    size: 16, color: Banking_TextColorSecondary)),
          ).paddingBottom(8),
        ],
      ),
    );
  }
}
