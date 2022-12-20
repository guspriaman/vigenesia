import 'dart:convert';

import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/BankingHome1.dart';
import 'package:bankingapp/banking/screen/BankingSignUp.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class BankingSignIn extends StatefulWidget {
  static var tag = "/BankingSignIn";

  @override
  _BankingSignInState createState() => _BankingSignInState();
}

class _BankingSignInState extends State<BankingSignIn> {
  bool isLoading = false;
  var client = http.Client();
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
  }

  signIn() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    var formData = jsonEncode(
        {"email": _emailController.text, "password": _passwordController.text});

    var response = await client.post(Uri.parse(baseUrl + "/login"),
        body: formData, headers: {"Content-Type": "application/json"});
    var data = jsonDecode(response.body);
    if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            data ?? "Something wrong..",
            style: TextStyle(fontSize: 13),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.amber[600]));
      setState(() {
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login berhasil", style: TextStyle(fontSize: 13)),
        duration: Duration(milliseconds: 300),
        backgroundColor: Colors.greenAccent[400],
      ));

      prefs.setBool('isLoggedIn', true);
      prefs.setString('user_name', data['data']['nama']);
      prefs.setString('user_id', data['data']['iduser']);
      prefs.setString('user_logged_in', jsonEncode(data['data']));
      setState(() {
        isLoading = false;
      });
      BankingDashboard().launch(context, isNewTask: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(Banking_lbl_SignIn, style: boldTextStyle(size: 30)),
                      EditText(
                        text: "Email",
                        isPassword: false,
                        mController: _emailController,
                      ),
                      8.height,
                      EditText(
                        text: "Password",
                        isPassword: true,
                        isSecure: true,
                        mController: _passwordController,
                      ),
                      8.height,
                      16.height,
                      BankingButton(
                        textContent: Banking_lbl_SignIn,
                        onPressed: () {
                          signIn();
                        },
                      ),
                      16.height,
                      Column(
                        children: [
                          Text('Belum punya akun ?',
                              style: primaryTextStyle(
                                  size: 16, color: Banking_TextColorSecondary)),
                          16.height,
                          Text("Sign Up",
                                  style: primaryTextStyle(
                                      size: 16,
                                      color: Banking_TextColorSecondary))
                              .onTap(() {
                            BankingSignUp().launch(context, isNewTask: true);
                          }),
                        ],
                      ).center(),
                    ],
                  ).center(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(Banking_lbl_app_Name.toUpperCase(),
                style: primaryTextStyle(
                    size: 16, color: Banking_TextColorSecondary)),
          ).paddingBottom(16),
        ],
      ),
    );
  }
}
