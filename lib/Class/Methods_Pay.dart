import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mailing/Class/Class_database.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/Login_Mailing.dart';
import 'package:mailing/Pages_File/PayPal_Page.dart';
import 'package:mailing/Pages_File/WebMoney_Payment.dart';
import 'package:mailing/l10n/applocal.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:mailing/main.dart';
import 'consumable_store.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

const bool _kAutoConsume = true;

class methods_pay extends StatefulWidget {
  const methods_pay({Key? key, required this.messaging, required this.member})
      : super(key: key);

  @override
  _methods_payState createState() => _methods_payState();

  final Member member;
  final Messaging messaging;
}

class _methods_payState extends State<methods_pay> {
  double WidthDevice = 0, HieghDevice = 0;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    // TODO: implement initState
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(<String>{
      widget.messaging.MessageDate
          .replaceAll('-', 'b')
          .replaceAll(':', 'a')
          .replaceAll(' ', '_')
    });
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isNotEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID ==
        widget.messaging.MessageDate
            .replaceAll('-', 'b')
            .replaceAll(':', 'a')
            .replaceAll(' ', '_')) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      setState(() {
        _purchasePending = false;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume &&
              purchaseDetails.productID ==
                  widget.messaging.MessageDate
                      .replaceAll('-', 'b')
                      .replaceAll(':', 'a')
                      .replaceAll(' ', '_')) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
          if(Platform.isAndroid){
            if(await PaymentComplate("g", member.getEmail, widget.messaging.MessageID.toString())){

            }
          }else{
            if(await PaymentComplate("i", member.getEmail, widget.messaging.MessageID.toString())){

            }
          }
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: widget.messaging.MessageDate
            .replaceAll('-', 'b')
            .replaceAll(':', 'a')
            .replaceAll(' ', '_'),
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id ==
            widget.messaging.MessageDate
                .replaceAll('-', 'b')
                .replaceAll(':', 'a')
                .replaceAll(' ', '_') &&
        purchases[widget.messaging.MessageDate
                .replaceAll('-', 'b')
                .replaceAll(':', 'a')
                .replaceAll(' ', '_')] !=
            null) {
      oldSubscription = purchases[widget.messaging.MessageDate
          .replaceAll('-', 'b')
          .replaceAll(':', 'a')
          .replaceAll(' ', '_')]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).textTheme.headline1!.color,
        title: Text(getLang(context, "method_pay")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              height: HieghDevice / 2.5,
              child: null,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/Untitled.png"),
                      fit: BoxFit.fill),
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
            ),
            Container(
                margin: EdgeInsets.only(top: HieghDevice * 0.22),
                height: HieghDevice * 0.35,
                child: ListView(
                    padding: EdgeInsets.only(
                        left: WidthDevice * 0.25,
                        right: WidthDevice * 0.25,
                        top: 20,
                        bottom: 20),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: WidthDevice * 0.6,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/paypal.png"),
                              fit: BoxFit.contain,
                            ),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 20)
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaypalPayment(
                                      onFinish: (number) async {
                                        print("order id:" + number);
                                      },
                                      messaging: widget.messaging,
                                      pay_type: "paypal",
                                    )));
                          },
                        ),
                      ),
                      SizedBox(
                        width: WidthDevice * 0.1,
                      ),
                      Container(
                        width: WidthDevice * 0.6,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/web_mony.png"),
                              fit: BoxFit.contain,
                            ),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 20)
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => webmoney_page(
                                        messaging: widget.messaging,
                                        onFinish: (number) async {
                                          print("order id:" + number);
                                        },
                                        pay_type: "webmoney")));
                          },
                        ),
                      ),
                      SizedBox(
                        width: WidthDevice * 0.1,
                      ),
                      Container(
                        width: WidthDevice * 0.6,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/itunes.png"),
                              fit: BoxFit.contain,
                            ),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 20)
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: GestureDetector(
                          onTap: () {
                            if (_notFoundIds.isNotEmpty) {
                              showtoast(getLang(context, "product_not_found"));
                              return;
                            }
                            if(Platform.isAndroid){
                              showtoast(getLang(context, "android"));
                              return;
                            }
                            final Map<String, PurchaseDetails> purchases =
                            Map<String, PurchaseDetails>.fromEntries(
                                _purchases.map((PurchaseDetails purchase) {
                                  if (purchase.pendingCompletePurchase) {
                                    _inAppPurchase.completePurchase(purchase);
                                  }
                                  return MapEntry<String, PurchaseDetails>(
                                      purchase.productID, purchase);
                                }));
                            late PurchaseParam purchaseParam;

                            if (Platform.isAndroid) {
                              // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                              // verify the latest status of you your subscription by using server side receipt validation
                              // and update the UI accordingly. The subscription purchase status shown
                              // inside the app may not be accurate.
                              final GooglePlayPurchaseDetails? oldSubscription =
                              _getOldSubscription(
                                  _products.first, purchases);

                              purchaseParam = GooglePlayPurchaseParam(
                                  productDetails: _products.first,
                                  applicationUserName: null,
                                  changeSubscriptionParam: (oldSubscription !=
                                      null)
                                      ? ChangeSubscriptionParam(
                                    oldPurchaseDetails: oldSubscription,
                                    prorationMode: ProrationMode
                                        .immediateWithTimeProration,
                                  )
                                      : null);
                            } else {
                              purchaseParam = PurchaseParam(
                                productDetails: _products.first,
                                applicationUserName: null,
                              );
                            }

                            if (_products.first.id ==
                                widget.messaging.MessageDate
                                    .replaceAll('-', 'b')
                                    .replaceAll(':', 'a')
                                    .replaceAll(' ', '_')) {
                              _inAppPurchase.buyNonConsumable(
                                  purchaseParam: purchaseParam);
                            } else {
                              _inAppPurchase.buyConsumable(
                                  purchaseParam: purchaseParam,
                                  autoConsume: _kAutoConsume || Platform.isIOS);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: WidthDevice * 0.1,
                      ),
                      Container(
                        width: WidthDevice * 0.6,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/googlplay.png"),
                                fit: BoxFit.contain),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 20)
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: GestureDetector(
                          onTap: () {
                            if (_notFoundIds.isNotEmpty) {
                              showtoast(getLang(context, "product_not_found"));
                              return;
                            }
                            if(Platform.isIOS){
                              showtoast(getLang(context, "ios"));
                              return;
                            }
                            final Map<String, PurchaseDetails> purchases =
                                Map<String, PurchaseDetails>.fromEntries(
                                    _purchases.map((PurchaseDetails purchase) {
                              if (purchase.pendingCompletePurchase) {
                                _inAppPurchase.completePurchase(purchase);
                              }
                              return MapEntry<String, PurchaseDetails>(
                                  purchase.productID, purchase);
                            }));
                            late PurchaseParam purchaseParam;

                            if (Platform.isAndroid) {
                              // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                              // verify the latest status of you your subscription by using server side receipt validation
                              // and update the UI accordingly. The subscription purchase status shown
                              // inside the app may not be accurate.
                              final GooglePlayPurchaseDetails? oldSubscription =
                                  _getOldSubscription(
                                      _products.first, purchases);

                              purchaseParam = GooglePlayPurchaseParam(
                                  productDetails: _products.first,
                                  applicationUserName: null,
                                  changeSubscriptionParam: (oldSubscription !=
                                          null)
                                      ? ChangeSubscriptionParam(
                                          oldPurchaseDetails: oldSubscription,
                                          prorationMode: ProrationMode
                                              .immediateWithTimeProration,
                                        )
                                      : null);
                            } else {
                              purchaseParam = PurchaseParam(
                                productDetails: _products.first,
                                applicationUserName: null,
                              );
                            }

                            if (_products.first.id ==
                                widget.messaging.MessageDate
                                    .replaceAll('-', 'b')
                                    .replaceAll(':', 'a')
                                    .replaceAll(' ', '_')) {
                              _inAppPurchase.buyNonConsumable(
                                  purchaseParam: purchaseParam);
                            } else {
                              _inAppPurchase.buyConsumable(
                                  purchaseParam: purchaseParam,
                                  autoConsume: _kAutoConsume || Platform.isIOS);
                            }
                          },
                        ),
                      )
                    ])),
            Container(
                margin: EdgeInsets.only(top: HieghDevice * 0.7),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10)
                            ]),
                        height: 60,
                        width: WidthDevice * 0.9,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaypalPayment(
                                      onFinish: (number) async {
                                        print("order id:" + number);
                                      },
                                      messaging: widget.messaging,
                                      pay_type: "paypal",
                                    )));
                          },
                          trailing: Icon(
                            Icons.payments_outlined,
                            size: 40,
                          ),
                          title: Text(
                              getLang(context, "paypal") +
                                  widget.messaging.MessagePrice.toString() +
                                  r" $",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color)),
                          subtitle: Text("Click Here",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color)),
                          leading: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/paypal.png"))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10)
                            ]),
                        height: 60,
                        width: WidthDevice * 0.9,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => webmoney_page(
                                        messaging: widget.messaging,
                                        onFinish: (number) async {
                                          print("order id:" + number);
                                        },
                                        pay_type: "webmoney")));
                          },
                          trailing: Icon(
                            Icons.payments_outlined,
                            size: 40,
                          ),
                          title: Text(
                              getLang(context, "web_money") +
                                  widget.messaging.MessagePrice.toString() +
                                  r" $",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color)),
                          subtitle: Text("Click Here",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color)),
                          leading: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/web_mony.png"))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10)
                            ]),
                        height: 60,
                        width: WidthDevice * 0.9,
                        child: ListTile(
                          onTap: () {
                            if (_notFoundIds.isNotEmpty) {
                              showtoast(getLang(context, "product_not_found"));
                              return;
                            }
                            if(Platform.isAndroid){
                              showtoast(getLang(context, "android"));
                              return;
                            }
                            final Map<String, PurchaseDetails> purchases =
                            Map<String, PurchaseDetails>.fromEntries(
                                _purchases.map((PurchaseDetails purchase) {
                                  if (purchase.pendingCompletePurchase) {
                                    _inAppPurchase.completePurchase(purchase);
                                  }
                                  return MapEntry<String, PurchaseDetails>(
                                      purchase.productID, purchase);
                                }));
                            late PurchaseParam purchaseParam;

                            if (Platform.isAndroid) {
                              // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                              // verify the latest status of you your subscription by using server side receipt validation
                              // and update the UI accordingly. The subscription purchase status shown
                              // inside the app may not be accurate.
                              final GooglePlayPurchaseDetails? oldSubscription =
                              _getOldSubscription(
                                  _products.first, purchases);

                              purchaseParam = GooglePlayPurchaseParam(
                                  productDetails: _products.first,
                                  applicationUserName: null,
                                  changeSubscriptionParam: (oldSubscription !=
                                      null)
                                      ? ChangeSubscriptionParam(
                                    oldPurchaseDetails: oldSubscription,
                                    prorationMode: ProrationMode
                                        .immediateWithTimeProration,
                                  )
                                      : null);
                            } else {
                              purchaseParam = PurchaseParam(
                                productDetails: _products.first,
                                applicationUserName: null,
                              );
                            }

                            if (_products.first.id ==
                                widget.messaging.MessageDate
                                    .replaceAll('-', 'b')
                                    .replaceAll(':', 'a')
                                    .replaceAll(' ', '_')) {
                              _inAppPurchase.buyNonConsumable(
                                  purchaseParam: purchaseParam);
                            } else {
                              _inAppPurchase.buyConsumable(
                                  purchaseParam: purchaseParam,
                                  autoConsume: _kAutoConsume || Platform.isIOS);
                            }
                          },
                          trailing: Icon(
                            Icons.payments_outlined,
                            size: 40,
                          ),
                          title: Text(
                              getLang(context, "itunes") +
                                  widget.messaging.MessagePrice.toString() +
                                  r" $",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color)),
                          subtitle: Text("Click Here",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color)),
                          leading: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/itunes.png"))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10)
                            ]),
                        height: 60,
                        width: WidthDevice * 0.9,
                        child: ListTile(
                          onTap: () {
                            if (_notFoundIds.isNotEmpty) {
                              showtoast(getLang(context, "product_not_found"));
                              return;
                            }
                            if(Platform.isIOS){
                              showtoast(getLang(context, "ios"));
                              return;
                            }

                            // This loading previous purchases code is just a demo. Please do not use this as it is.
                            // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
                            // We recommend that you use your own server to verify the purchase data.
                            final Map<String, PurchaseDetails> purchases =
                            Map<String, PurchaseDetails>.fromEntries(
                                _purchases.map((PurchaseDetails purchase) {
                                  if (purchase.pendingCompletePurchase) {
                                    _inAppPurchase.completePurchase(purchase);
                                  }
                                  return MapEntry<String, PurchaseDetails>(
                                      purchase.productID, purchase);
                                }));
                            late PurchaseParam purchaseParam;

                            if (Platform.isAndroid) {
                              // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                              // verify the latest status of you your subscription by using server side receipt validation
                              // and update the UI accordingly. The subscription purchase status shown
                              // inside the app may not be accurate.
                              final GooglePlayPurchaseDetails? oldSubscription =
                              _getOldSubscription(
                                  _products.first, purchases);

                              purchaseParam = GooglePlayPurchaseParam(
                                  productDetails: _products.first,
                                  applicationUserName: null,
                                  changeSubscriptionParam: (oldSubscription !=
                                      null)
                                      ? ChangeSubscriptionParam(
                                    oldPurchaseDetails: oldSubscription,
                                    prorationMode: ProrationMode
                                        .immediateWithTimeProration,
                                  )
                                      : null);
                            } else {
                              purchaseParam = PurchaseParam(
                                productDetails: _products.first,
                                applicationUserName: null,
                              );
                            }

                            if (_products.first.id ==
                                widget.messaging.MessageDate
                                    .replaceAll('-', 'b')
                                    .replaceAll(':', 'a')
                                    .replaceAll(' ', '_')) {
                              _inAppPurchase.buyNonConsumable(
                                  purchaseParam: purchaseParam);
                            } else {
                              _inAppPurchase.buyConsumable(
                                  purchaseParam: purchaseParam,
                                  autoConsume: _kAutoConsume || Platform.isIOS);
                            }
                          },
                          trailing: Icon(
                            Icons.payments_outlined,
                            size: 40,
                          ),
                          title: Text(
                            getLang(context, "google_play") +
                                widget.messaging.MessagePrice.toString() +
                                r" $",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          ),
                          subtitle: Text("Click Here",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color)),
                          leading: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/googlplay.png"))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ])),
            Container(
              margin: EdgeInsets.only(top: HieghDevice * 0.1),
              child: Text(
                getLang(context, "Price") +
                    " " +
                    widget.messaging.MessageSymbol +
                    ": " +
                    widget.messaging.MessagePrice.toString() +
                    r" $",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline1!.color),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

class button_pay_with_apay extends StatefulWidget {
  button_pay_with_apay({required this.messaging});

  final Messaging messaging;

  @override
  _button_pay_with_apayState createState() => _button_pay_with_apayState();
}

class _button_pay_with_apayState extends State<button_pay_with_apay> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
            height: 100,
            width: 100,
            child: Text(
              "almost",
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
            )));
  }
}
