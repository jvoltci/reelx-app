import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reelx/controller/main_controller.dart';
import 'package:reelx/utils/api/serve_api.dart';
import 'package:reelx/utils/contstants/api_constants.dart';
import 'package:reelx/utils/contstants/path_constants.dart';
import 'package:reelx/utils/helper/ads.dart';
import 'package:reelx/utils/helper/get_android_version.dart';
import 'package:reelx/utils/helper/push_notification.dart';
import 'package:reelx/utils/helper/sync_whatsapp.dart';

MainController m = Get.find();

const String key = ApiConstants.key;
const String downloadHitApi = ApiConstants.downloadHit;

class HomeController extends GetxController {
  late BannerAd homeBottomBannerAd;
  var isSAFAllowed = false.obs;
  var isHomeBottomBannerAdLoaded = false.obs;

  var message = ''.obs;
  var allowedDirLabel = <String>[].obs;
  var androidVersion = 28.obs;
  var base = "".obs;
  var tron = false.obs;
  var tronType = ''.obs; // image/text
  var tronMeta = {}.obs;

  final firebaseMessaging = FCM();

  final storage = GetStorage();

  @override
  void onInit() {
    createHomeBottomBannerAd();
    getPrefs("allowedDirLabel");
    PathConstants().getRoot().then((b) {
      base.value = b;
      firebaseMessaging.setNotifications();
      firebaseMessaging.initializePushNotification(b);
    });
    initiateTron();
    super.onInit();
  }

  @override
  void onClose() async {
    homeBottomBannerAd.dispose();
    super.onClose();
  }

  void createHomeBottomBannerAd() {
    homeBottomBannerAd = BannerAd(
      adUnitId: Ads.bannerAdUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isHomeBottomBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    homeBottomBannerAd.load();
  }

  @override
  void onReady() async {
    super.onReady();
    await Permission.storage.request();
    var version = await getAndroidVersion();
    if (version > 29) {
      syncWhatsAppNow(); /* Sync Starts Here */
    }
    androidVersion.value = version;
  }

  Future<void> getPrefs(String property) async {
    switch (property) {
      case 'allowedDirLabel':
        allowedDirLabel.value = storage.read('reelx_allowedDirLabel') ?? [];
        break;
      case "tron":
        var encodedMap = storage.read('reelx_tron') ?? "{}";
        Map<String, dynamic> decodedMap = json.decode(encodedMap);
        if (decodedMap.containsKey("tron")) {
          tron.value = decodedMap["tron"];
          tronType.value = decodedMap["type"];
          tronMeta.value = decodedMap["meta"];
        }
        break;
    }
  }

  setPrefs(String property) async {
    switch (property) {
      case 'allowedDirLabel':
        storage.write('reelx_allowedDirLabel', allowedDirLabel);
        break;
      case 'tron':
        Map<String, dynamic> tronDataMap = {
          "tron": tron.value,
          "type": tronType.value,
          "meta": tronMeta,
        };
        String encodedMap = json.encode(tronDataMap);
        storage.write('reelx_tron', encodedMap);
        break;
    }
  }

  syncWhatsAppNow() async {
    for (var label in allowedDirLabel) {
      syncWhatsApp(label);
    }
  }

  initiateTron() async {
    await getPrefs('tron');
    var data = await getTronAPIData();
    if (data != null) {
      tron.value = true;
      tronType.value = data["type"];
      tronMeta.value = data["meta"];
      setPrefs('tron');
    } else {
      tron.value = false;
      setPrefs('tron');
    }
  }
}
