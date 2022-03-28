import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mailing/Class/Class_database.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/main.dart';

class webmoney_page extends StatefulWidget {
  const webmoney_page(
      {required this.messaging,
      required this.onFinish,
      required this.pay_type});

  @override
  _webmoney_pageState createState() => _webmoney_pageState();
  final Function onFinish;
  final Messaging messaging;
  final String pay_type;
}

class _webmoney_pageState extends State<webmoney_page> {
  @override
  Widget build(BuildContext context) {
    double price = widget.messaging.MessagePrice;
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(),
            body: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      "https://merchant.wmtransfer.com/lmi/payment_utf.asp"),
                  method: 'POST',
                  headers: {
                    'accept-charset': 'UTF-8',
                    'content-type': 'application/x-www-form-urlencoded'
                  },
                  body: Uint8List.fromList(utf8.encode(
                      "LMI_PAYMENT_AMOUNT=${price.toStringAsFixed(2)}&"
                      "LMI_PAYMENT_DESC=Signals on ${widget.messaging.MessageSymbol}&"
                      "LMI_PAYEE_PURSE=Z427090876639&"
                      "LMI_RESULT_URL=https://merchant.webmoney.ru/conf/result.html&"
                      "LMI_SUCCESS_URL=https://merchant.webmoney.ru/conf/success.html&"
                      "LMI_SUCCESS_METHOD=2&"
                      "LMI_FAIL_URL=https://merchant.webmoney.ru/conf/fail.html&"
                      "LMI_FAIL_METHOD=2&"
                      "LMI_MODE	=0&"
                      "FIELD_1=VALUE_1&"
                      "FIELD_2=VALUE_2&"
                      "FIELD_N=VALUE_N"))),
              onWebViewCreated: (controller) {
                print(controller);
              },
              onLoadHttpError: (controler, uri, statuscode, description) {
                print(controler);
                print(uri);
                print(statuscode);
                print(description);
              },
              onLoadError: (controler, uri, code, description) {
                print(controler);
                print(uri);
                print(code);
                print(description);
              },
              androidOnRenderProcessResponsive: (controler, uri) async {
                print(controler);
                print(uri);
              },
              onCloseWindow: (controler) {
                print(controler);
              },
              onLoadStop: (controler,uri)async{
                print(controler);
                print(uri);
                if(uri.toString().contains("success.html")){
                  if(await PaymentComplate("w", member.getEmail, widget.messaging.MessageID.toString())){

                  }
                }
              },
            )),
        onWillPop: () async {
          print("HI");
          Navigator.pop(context);
          return true;
        });
  }
}
