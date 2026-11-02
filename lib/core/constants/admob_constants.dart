import 'dart:io';

/// Official Google AdMob Test Advertisement IDs for Android & iOS.
/// Reference: https://developers.google.com/admob/android/test-ads
/// Reference: https://developers.google.com/admob/ios/test-ads
class AdMobConstants {
  // -------------------------------------------------------------
  // AdMob Sample Application IDs
  // -------------------------------------------------------------
  static const String testAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String testAppIdIOS = 'ca-app-pub-3940256099942544~1458602516';

  // -------------------------------------------------------------
  // Banner Ad Test Unit IDs
  // -------------------------------------------------------------
  static const String testBannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerIdIOS = 'ca-app-pub-3940256099942544/2934735716';

  // -------------------------------------------------------------
  // Interstitial Ad Test Unit IDs
  // -------------------------------------------------------------
  static const String testInterstitialIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialIdIOS = 'ca-app-pub-3940256099942544/4411468910';

  // -------------------------------------------------------------
  // Rewarded Video Ad Test Unit IDs
  // -------------------------------------------------------------
  static const String testRewardedIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String testRewardedIdIOS = 'ca-app-pub-3940256099942544/1712485313';

  // -------------------------------------------------------------
  // Rewarded Interstitial Ad Test Unit IDs
  // -------------------------------------------------------------
  static const String testRewardedInterstitialIdAndroid = 'ca-app-pub-3940256099942544/5354046379';
  static const String testRewardedInterstitialIdIOS = 'ca-app-pub-3940256099942544/6978759866';

  // -------------------------------------------------------------
  // Native Advanced Ad Test Unit IDs
  // -------------------------------------------------------------
  static const String testNativeIdAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const String testNativeIdIOS = 'ca-app-pub-3940256099942544/3986624511';

  // -------------------------------------------------------------
  // App Open Ad Test Unit IDs
  // -------------------------------------------------------------
  static const String testAppOpenIdAndroid = 'ca-app-pub-3940256099942544/9257395921';
  static const String testAppOpenIdIOS = 'ca-app-pub-3940256099942544/5575463023';

  // -------------------------------------------------------------
  // Platform-Aware Resolvers
  // -------------------------------------------------------------
  static String get appId {
    if (Platform.isIOS) return testAppIdIOS;
    return testAppIdAndroid;
  }

  static String get bannerAdUnitId {
    if (Platform.isIOS) return testBannerIdIOS;
    return testBannerIdAndroid;
  }

  static String get interstitialAdUnitId {
    if (Platform.isIOS) return testInterstitialIdIOS;
    return testInterstitialIdAndroid;
  }

  static String get rewardedAdUnitId {
    if (Platform.isIOS) return testRewardedIdIOS;
    return testRewardedIdAndroid;
  }

  static String get rewardedInterstitialAdUnitId {
    if (Platform.isIOS) return testRewardedInterstitialIdIOS;
    return testRewardedInterstitialIdAndroid;
  }

  static String get nativeAdUnitId {
    if (Platform.isIOS) return testNativeIdIOS;
    return testNativeIdAndroid;
  }

  static String get appOpenAdUnitId {
    if (Platform.isIOS) return testAppOpenIdIOS;
    return testAppOpenIdAndroid;
  }
}
