import 'dart:convert';

import 'package:bankingapp/banking/model/UserModel.dart';
import 'package:bankingapp/banking/screen/BankingSignIn.dart';
import 'package:bankingapp/banking/screen/BankingTermsCondition.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class BankingMenu extends StatefulWidget {
  static var tag = "/BankingMenu";

  @override
  _BankingMenuState createState() => _BankingMenuState();
}

class _BankingMenuState extends State<BankingMenu> {
  UserModel? userLoggedIn;
  var client = http.Client();
  bool isLoading = true;

  TextEditingController _namaController = TextEditingController(text: '');
  TextEditingController _profesiController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    getUserLoggedIn();
  }

  getUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    userLoggedIn = UserModel.fromJson(
        jsonDecode(prefs.getString('user_logged_in').toString()));
    _namaController = TextEditingController(text: userLoggedIn?.nama);
    _profesiController = TextEditingController(text: userLoggedIn?.profesi);
    _emailController = TextEditingController(text: userLoggedIn?.email);
    setState(() {
      isLoading = false;
    });
  }

  submit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    var formData = jsonEncode({
      "iduser": userLoggedIn?.iduser,
      "nama": _namaController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "profesi": _profesiController.text
    });

    print(formData);

    var response = await client.put(Uri.parse(baseUrl + '/PUTprofile'),
        body: formData, headers: {"Content-Type": "application/json"});

    print(formData);
    print(response.body.copyToClipboard());
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Something wrong..",
            style: TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.amber[600]));
      setState(() {
        isLoading = false;
      });
    } else {
      prefs.setString(
          'user_logged_in',
          jsonEncode({
            "nama": _namaController.text,
            "email": _emailController.text,
            "profesi": _profesiController.text
          }));
      prefs.setString('user_name', _namaController.text);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Berhasil update profil", style: TextStyle(fontSize: 13)),
        backgroundColor: Colors.greenAccent[400],
      ));

      getUserLoggedIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    10.height,
                    Text('Profile',
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 35)),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              5.height,
                              Text(userLoggedIn?.nama.toString() ?? '',
                                  style: boldTextStyle(
                                      color: Banking_TextColorPrimary,
                                      size: 18)),
                              5.height,
                              Text(userLoggedIn?.profesi.toString() ?? '',
                                  style: primaryTextStyle(
                                      color: Banking_TextColorSecondary,
                                      size: 16,
                                      fontFamily: fontMedium)),
                              5.height,
                              Text(Banking_lbl_app_Name,
                                  style: primaryTextStyle(
                                      color: Banking_TextColorSecondary,
                                      size: 16,
                                      fontFamily: fontMedium)),
                            ],
                          ).expand()
                        ],
                      ),
                    ),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
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
                              text: "Password Baru",
                              isPassword: true,
                              isSecure: true,
                              mController: _passwordController),
                          8.height,
                          BankingButton(
                            textContent: 'Ubah Profile',
                            onPressed: () {
                              submit();
                            },
                          )
                        ],
                      ),
                    ),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          bankingOption(Banking_ic_Logout, Banking_lbl_Logout,
                                  Banking_pinkColor)
                              .onTap(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => CustomDialog(),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          16.height,
          Text(Banking_lbl_Confirmation_for_logout,
                  style: primaryTextStyle(size: 18))
              .onTap(() {
            finish(context);
          }).paddingOnly(top: 8, bottom: 8),
          Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Cancel", style: primaryTextStyle(size: 18)).onTap(() {
                finish(context);
              }).paddingRight(16),
              Container(width: 1.0, height: 40, color: Banking_greyColor)
                  .center(),
              Text("Logout",
                      style: primaryTextStyle(size: 18, color: Banking_Primary))
                  .onTap(() async {
                finish(context);
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);
                prefs.remove('user_name');
                prefs.remove('user_id');
                prefs.remove('user_logged_in');

                BankingSignIn().launch(context, isNewTask: true);
              }).paddingLeft(16)
            ],
          ),
          16.height,
        ],
      ));
}
