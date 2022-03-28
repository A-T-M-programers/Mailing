import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Home_Page.dart';

InterstitialAd? _interstitialAd;
BannerAd? bannerAd;
bool inlineAdLoaded = false;

void loadAdInterstitialAd(){
  if(!checkadmin){
    InterstitialAd.load(
        adUnitId: Platform.isAndroid ? "ca-app-pub-2528981580397714/9236448348" : "ca-app-pub-2528981580397714/1918385045" ,
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

void loadAdBannerAd(){
  if(!checkadmin){
    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid ? "ca-app-pub-2528981580397714/9428020033" : "ca-app-pub-2528981580397714/1932673395" ,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad){
          inlineAdLoaded = true;
        },
        onAdFailedToLoad: (ad,error){
          ad.dispose();
          bannerAd = null;
          bannerAd!.load();
          print("ad failed to load ${error.message}");
        },
        onAdClosed: (ad){
          bannerAd = null;
          bannerAd!.load();
          print("ad is closed");
        }
      ),
    );
    bannerAd!.load();
  }
}

void showAdInterstitialAd(){
  if(_interstitialAd == null){
    print("trying to show before loading");
    loadAdInterstitialAd();
    return;
  }
  _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('%ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      _interstitialAd = null;
      loadAdInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      _interstitialAd = null;
      loadAdInterstitialAd();
    },
    onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
  );
  _interstitialAd!.show();
}