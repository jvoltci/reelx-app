import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reelx/utils/helper/ads.dart';

class AboutController extends GetxController {
  late BannerAd aboutBottomBannerAd;
  var isAboutBottomBannerAdLoaded = false.obs;

  @override
  void onInit() async {
    super.onInit();
    createAboutBottomBannerAd();
  }

  @override
  void onClose() async {
    aboutBottomBannerAd.dispose();
    super.onClose();
  }

  void createAboutBottomBannerAd() {
    aboutBottomBannerAd = BannerAd(
      adUnitId: Ads.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isAboutBottomBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    aboutBottomBannerAd.load();
  }
}
