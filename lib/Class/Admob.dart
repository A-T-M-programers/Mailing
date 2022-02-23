import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Home_Page.dart';

InterstitialAd? _interstitialAd;

void loadAd(){
  if(!checkadmin){
    InterstitialAd.load(
        adUnitId: Platform.isAndroid ? "ca-app-pub-4118903766826893/6004668397" : "ca-app-pub-4118903766826893/9810027949" ,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }
}

void showAd(){
  if(_interstitialAd == null){
    print("trying to show before loading");
    loadAd();
    return;
  }
  _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('%ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      _interstitialAd = null;
      loadAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      _interstitialAd = null;
      loadAd();
    },
    onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
  );
  _interstitialAd!.show();
}