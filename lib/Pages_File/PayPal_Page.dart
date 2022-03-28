import 'package:flutter/material.dart';
import 'package:mailing/Class/Class_database.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  const PaypalPayment({required this.onFinish,required this.messaging,required this.pay_type});

  @override
  _PaypalPaymentState createState() => _PaypalPaymentState();
  final Function onFinish;
  final Messaging messaging;
  final String pay_type;
}

class _PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PayPalServices services = PayPalServices();
  late Map<dynamic, dynamic> defaultCurrency;
  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultCurrency = {
      "symbol": "USD ",
      "decimalDigits": widget.messaging.MessagePrice,
      "symbolBeforeTheNumber": true,
      "currency": "USD"
    };
    Future.delayed(Duration.zero,()async{
      try{
        accessToken = await services.getAccessToken();
        final transactions = getOrderParams();
        final res = await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      }catch(ex){
        print('exception: ' + ex.toString());
        final snackBar = SnackBar(
          content: Text(ex.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
              Navigator.pop(context);
            },
          ),
        );
        // ignore: deprecated_member_use
        _scaffoldkey.currentState!.showSnackBar(snackBar);
      }
    });
  }
  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": widget.messaging.MessageSymbol,
        "quantity": 1,
        "price": widget.messaging.MessagePrice.toString(),
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = widget.messaging.MessagePrice.toString();
    String subTotalAmount = widget.messaging.MessagePrice.toString();
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'MHD EYAD';
    String userLastName = 'ABD ALNASR ABAS';
    String addressCity = 'macca';
    String addressStreet = 'jubail al sharkiya';
    String addressZipCode = '24231';
    String addressCountry = 'Saudi Arabia';
    String addressState = 'macca';
    String addressPhoneNumber = '+966550021135';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": widget.pay_type},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services.executePayment(executeUrl, payerID, accessToken)
                    .then((id) async{
                      if(await PaymentComplate("p", member.getEmail, widget.messaging.MessageID.toString())){

                      }
                  widget.onFinish(id);
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
