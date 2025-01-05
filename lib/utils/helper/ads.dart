import 'package:google_mobile_ads/google_mobile_ads.dart';

// Admob Ad IDs
const testAdmobBannerId = 'ca-app-pub-3940256099942544/6300978111';
const testAdmobInterstitialId = 'ca-app-pub-3940256099942544/8691691433';
const admobBannerId = 'ca-app-pub-6205159634548411/4767223902';
const admobInterstitialId = 'ca-app-pub-6205159634548411/1277543210';

class Ads {
  static var maxAdFailedLoadAttempts = 1;

  static initializeAdmob() {
    MobileAds.instance.initialize();
  }

  static String get bannerAdUnitId {
    return admobBannerId;
  }

  static String get interstitialAdUnitId {
    return admobInterstitialId;
  }
}
