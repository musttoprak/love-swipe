import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  BannerAd? _bannerAd;

  void loadInterstitialAd({bool showAfterLoad = false, Function? onAdDismissed, Function? onAdFailedToShow}) {
    InterstitialAd.load(
      adUnitId: KAdStrings.interstitialAd1,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          if (showAfterLoad) {
            showInterstitialAd(onAdDismissed: onAdDismissed, onAdFailedToShow: onAdFailedToShow);
          }
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  void showInterstitialAd({Function? onAdDismissed, Function? onAdFailedToShow}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          onAdDismissed?.call();
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          onAdFailedToShow?.call();
          ad.dispose();
        },
      );
      _interstitialAd!.show();
    }
  }

  void loadRewardedAd({bool showAfterLoad = false, Function? onRewardReceived}) {

    RewardedAd.load(
        adUnitId: KAdStrings.rewardedAd,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            if (showAfterLoad) showRewardedAd(onRewardReceived!);
          }, //showRewardedAd(onRewardReceived);
          onAdFailedToLoad: (LoadAdError error) {
          },
        ));
  }

  void showRewardedAd(Function onRewardReceived) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        onRewardReceived();

      });
    }
  }

  void loadRewardedInterstitialAd({bool showAfterLoad = false, Function? onAdDismissed, Function? onAdFailedToShow}) {
    RewardedInterstitialAd.load(
        adUnitId: KAdStrings.rewardedInterstitialAd,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedInterstitialAd = ad;
            if (showAfterLoad) showRewardedInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
          },
        ));
  }

  void showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(onUserEarnedReward: (ad, reward) {
        // Kullanıcının ödülü kazandığı yere bu kod bloğu içerisine yazabilirsiniz.
      });
    }
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: KAdStrings.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  Widget getBannerAdWidget() {
    if (_bannerAd == null) {
      return Container(height: 0);
    }
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }



}

class KAdStrings {
  static const String interstitialAd1 = "";
  static const String rewardedAd = "ca-app-pub-5809888631902815/8907089207";
  static const String rewardedInterstitialAd = "";
  static const String bannerAd = "";
}

class GoogleAds2 {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  BannerAd? _bannerAd;

  void loadInterstitialAd({bool showAfterLoad = false}) {
    InterstitialAd.load(adUnitId: KAdStrings.interstitialAd1, request: const AdRequest(), adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
        if (showAfterLoad) showInterstitialAd();
      },
      onAdFailedToLoad: (LoadAdError error) {},
    ));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  void loadRewardedAd({bool showAfterLoad = false, Function? onRewardReceived}) {

    RewardedAd.load(
        adUnitId: KAdStrings.rewardedAd,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            if (showAfterLoad) showRewardedAd(onRewardReceived!);
          }, //showRewardedAd(onRewardReceived);
          onAdFailedToLoad: (LoadAdError error) {
          },
        ));
  }

  void showRewardedAd(Function onRewardReceived) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        onRewardReceived();

      });
    }
  }

  void loadRewardedInterstitialAd({bool showAfterLoad = false, Function? onAdClosed}) {
    RewardedInterstitialAd.load(
      adUnitId: KAdStrings.rewardedInterstitialAd,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          if (showAfterLoad) showRewardedInterstitialAd(onAdClosed);
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  void showRewardedInterstitialAd(Function? onAdClosed) {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(onUserEarnedReward: (ad, reward) {
        // Reklam izlendikten sonra yapılacak işlemler
      }).then((_) {
        if (onAdClosed != null) {
          onAdClosed();
        }
      });
    }
  }
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: KAdStrings.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  Widget getBannerAdWidget() {
    if (_bannerAd == null) {
      return Container(height: 0);
    }
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class GoogleAds3 {
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  BannerAd? _bannerAd;

  void loadRewardedAd({bool showAfterLoad = false, Function? onRewardReceived}) {

    RewardedAd.load(
        adUnitId: KAdStrings.rewardedAd,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            if (showAfterLoad) showRewardedAd(onRewardReceived!);
          }, //showRewardedAd(onRewardReceived);
          onAdFailedToLoad: (LoadAdError error) {
          },
        ));
  }

  void showRewardedAd(Function onRewardReceived) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        onRewardReceived(

        );

      });
    }
  }

  void loadRewardedInterstitialAd({bool showAfterLoad = false}) {
    RewardedInterstitialAd.load(
        adUnitId: KAdStrings.rewardedInterstitialAd,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedInterstitialAd = ad;
            if (showAfterLoad) showRewardedInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }

  void showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(onUserEarnedReward: (ad, reward) {
        // Kullanıcının ödülü kazandığı yere bu kod bloğu içerisine yazabilirsiniz.
      });
    }
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: KAdStrings.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  Widget getBannerAdWidget() {
    if (_bannerAd == null) {
      return Container(height: 0);
    }
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}