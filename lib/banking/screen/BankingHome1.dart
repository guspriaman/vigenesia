import 'dart:async';
import 'dart:convert';

import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/model/MotivasiModel.dart';
import 'package:bankingapp/banking/model/UserModel.dart';
import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/BankingMotivasiForm.dart';
import 'package:bankingapp/banking/screen/BankingMotivasiFormEdit.dart';
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

class BankingHome1 extends StatefulWidget {
  static String tag = '/BankingHome1';

  @override
  BankingHome1State createState() => BankingHome1State();
}

class BankingHome1State extends State<BankingHome1> {
  int currentIndexPage = 0;
  int? pageLength;
  var client = http.Client();
  late List<BankingHomeModel> mList1;
  late List<BankingHomeModel2> mList2;

  late List<MotivasiModel> motivasi;

  bool isLoading = true;

  String? idUser;
  UserModel? userLoggedIn;

  @override
  void initState() {
    super.initState();
    currentIndexPage = 0;
    pageLength = 3;
    mList1 = bankingHomeList1();
    mList2 = bankingHomeList2();
    fetchMotivasi();
  }

  fetchMotivasi() async {
    final prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString('user_id');
    userLoggedIn = UserModel.fromJson(
        jsonDecode(prefs.getString('user_logged_in').toString()));

    setState(() {
      isLoading = true;
    });
    var response = await client
        .get(Uri.parse(baseUrl + '/Get_motivasi?iduser=' + idUser.toString()));

    var data = jsonDecode(response.body);

    motivasi =
        (data as List).map((row) => MotivasiModel.fromJson(row)).toList();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isLoading = false;
      });
      // Do something
    });
  }

  deleteMotivasi(String id, context) async {
    setState(() {
      isLoading = true;
    });

    var response = await client.delete(
        Uri.parse(baseUrl + '/dev/DELETEmotivasi'),
        body: {"id": id},
        headers: {"Content-Type": "application/x-www-form-urlencoded"});

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text("Motivasi berhasil dihapus", style: TextStyle(fontSize: 13)),
      backgroundColor: Colors.greenAccent[400],
    ));

    Navigator.pop(context, 'Ya');

    fetchMotivasi();

    setState(() {
      isLoading = false;
    });
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
                    CircleAvatar(
                        backgroundImage: AssetImage(Banking_ic_user1),
                        radius: 24),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(userLoggedIn?.nama ?? '',
                            style: primaryTextStyle(
                                color: Banking_TextColorWhite,
                                size: 16,
                                fontFamily: fontRegular)),
                        Text(userLoggedIn?.profesi ?? '',
                            style: primaryTextStyle(
                                color: Banking_TextColorWhite,
                                size: 16,
                                fontFamily: fontRegular)),
                      ],
                    ).expand(),
                    Icon(Icons.add_comment,
                            size: 30, color: Banking_whitePureColor)
                        .onTap(() {
                      BankingMotivasiForm().launch(context);
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
                Text("Motivasi",
                    style: primaryTextStyle(
                        size: 16,
                        color: Banking_TextColorSecondary,
                        fontFamily: fontRegular)),
                Divider(),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: motivasi.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          MotivasiModel data = motivasi[index];
                          return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(top: 8, bottom: 8),
                            decoration: boxDecorationRoundedWithShadow(8,
                                backgroundColor: Banking_whitePureColor,
                                spreadRadius: 0,
                                blurRadius: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                10.width,
                                Text(data.isiMotivasi!,
                                        style: primaryTextStyle(
                                            size: 16,
                                            color: Banking_TextColorPrimary,
                                            fontFamily: fontRegular))
                                    .expand(),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit).onTap(() {
                                          BankingMotivasiFormEdit(
                                                  data.isiMotivasi.toString(),
                                                  data.id.toString())
                                              .launch(context);
                                        }),
                                        TextButton(
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Icon(
                                                  Icons.warning_rounded),
                                              content: const Text(
                                                  'Apakah anda yakin akan menghapus motivasi ini ?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Batal'),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteMotivasi(
                                                        data.id.toString(),
                                                        context);
                                                  },
                                                  child: const Text('Ya'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.black87,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
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
            Text('Apakah anda yakin akan menghapus motivasi ini ?',
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
                        style:
                            primaryTextStyle(size: 18, color: Banking_Primary))
                    .onTap(() async {
                  finish(context);
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', false);
                  prefs.remove('user_name');
                  prefs.remove('user_id');
                  prefs.remove('user_logged_in');

                  BankingDashboard().launch(context, isNewTask: true);
                }).paddingLeft(16)
              ],
            ),
            16.height,
          ],
        ));
  }
}
