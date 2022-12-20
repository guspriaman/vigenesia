import 'dart:async';
import 'dart:convert';

import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/model/MotivasiModel.dart';
import 'package:bankingapp/banking/model/UserModel.dart';
import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/BankingHome1.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class BankingMotivasiForm extends StatefulWidget {
  static String tag = '/BangkingMotivasiForm';

  @override
  BankingMotivasiFormState createState() => BankingMotivasiFormState();
}

class BankingMotivasiFormState extends State<BankingMotivasiForm> {
  int currentIndexPage = 0;
  int? pageLength;
  var client = http.Client();
  late List<BankingHomeModel> mList1;
  late List<BankingHomeModel2> mList2;

  late List<MotivasiModel> motivasi;

  bool isLoading = false;

  String? idUser;
  UserModel? userLoggedIn;

  TextEditingController _isiMotivasiController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    getLoggedInUser();
    currentIndexPage = 0;
    pageLength = 3;
    mList1 = bankingHomeList1();
    mList2 = bankingHomeList2();
  }

  getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('user_id');
    userLoggedIn = UserModel.fromJson(
        jsonDecode(prefs.getString('user_logged_in').toString()));
  }

  submit() async {
    setState(() {
      isLoading = true;
    });

    var formData = {
      "iduser": idUser,
      "isi_motivasi": _isiMotivasiController.text
    };

    print(formData);

    var response = await client.post(Uri.parse(baseUrl + '/dev/POSTmotivasi'),
        body: formData);

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Motivasi berhasil disimpan", style: TextStyle(fontSize: 13)),
        backgroundColor: Colors.greenAccent[400],
      ));

      setState(() {
        isLoading = false;
      });
      BankingDashboard().launch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: false,
              pinned: true,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Banking_Primary,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              title: Container(
                padding: EdgeInsets.fromLTRB(16, 42, 16, 42),
                margin: EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tambah Motivasi Baru',
                            style: primaryTextStyle(
                                color: Banking_TextColorWhite,
                                size: 16,
                                fontFamily: fontRegular)),
                      ],
                    ).expand(),
                    Icon(Icons.arrow_back,
                            size: 20, color: Banking_whitePureColor)
                        .onTap(() {
                      BankingDashboard().launch(context, isNewTask: true);
                    })
                  ],
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            color: Banking_app_Background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              EditText(
                                  text: "Isi Motivasi",
                                  isPassword: false,
                                  mController: _isiMotivasiController,
                                  multiLine: true),
                              8.height,
                              BankingButton(
                                textContent: 'Simpan',
                                onPressed: () {
                                  submit();
                                },
                              ),
                              16.height,
                            ],
                          ).center(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
