import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reelx/pages/home/cotroller/home_controller.dart';
import 'package:reelx/utils/contstants/path_constants.dart';
import 'package:reelx/utils/helper/ads.dart';
import 'package:reelx/utils/helper/encode_path_to_name.dart';
import 'package:reelx/utils/helper/generate_thumbnail.dart';
import 'package:reelx/utils/helper/get_file_name.dart';
import 'package:reelx/utils/helper/save_file.dart';
import 'package:reelx/widgets/permission_dialog.dart';
import 'package:share_plus/share_plus.dart';

HomeController h = Get.find();

final Directory reelxWhatsAppCache =
    Directory(h.base.value + PathConstants.reelxWhatsAppCache);

final Directory thumbDir =
    Directory(h.base.value + PathConstants.reelxwhatsappThumbPath);
final Directory dir = Directory(h.base.value + PathConstants.reelxWhatsappPath);

class WhatsAppController extends GetxController {
  final box = GetStorage();
  late BuildContext context;

  var currentImagePathIndex = 0.obs;
  var isGranted = false.obs;
  var allowedDirLabel = <String>[].obs;
  var deniedDir = <String>[].obs;
  var visibleDirLabel = <String>[].obs;
  var showGrantPermission = false.obs;

  InterstitialAd? wpInterstitialAd;
  late BannerAd wpBottomBannerAd;
  var isWpBottomBannerAdLoaded = false.obs;
  var maxFailedLoadAttempts = 3;
  var interstitialLoadAttempts = 0.obs;

  List<String> imageList = [];
  List<String> videoList = [];

  WhatsAppController(this.context);

  @override
  void onInit() async {
    super.onInit();
    createWpBottomBannerAd();
    getPrefs('isGranted');
    await getPrefs('allowedDirLabel').then((_) => loadAssets());
    getPrefs('visibleDirLabel');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    if (!thumbDir.existsSync()) {
      thumbDir.createSync(recursive: true);
    }
    createWpInterstitialAd();
  }

  @override
  void onClose() async {
    wpBottomBannerAd.dispose();
    wpInterstitialAd?.dispose();
    super.onClose();
  }

  void createWpBottomBannerAd() {
    wpBottomBannerAd = BannerAd(
      adUnitId: Ads.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isWpBottomBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    wpBottomBannerAd.load();
  }

  void createWpInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Ads.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          wpInterstitialAd = ad;
          interstitialLoadAttempts.value = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialLoadAttempts.value += 1;
          wpInterstitialAd = null;
          if (interstitialLoadAttempts.value <= maxFailedLoadAttempts) {
            createWpInterstitialAd();
          } else {}
        },
      ),
    );
  }

  void showWpInterstitialAd(String path) {
    if (wpInterstitialAd != null) {
      wpInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          save(path);
          ad.dispose();
          createWpInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          save(path);
          createWpInterstitialAd();
        },
      );
      wpInterstitialAd!.show();
    } else {
      save(path);
    }
  }

  void share(path) => Share.share(path);

  void save(path) {
    saveFile(path, social: 'whatsapp');
    Get.snackbar(
      'Downloaded',
      'location: ~Internal storage/Download/Reelx/WhatsAppreelx',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: context.theme.colorScheme.background,
      colorText: context.theme.textTheme.displayLarge?.color,
    );
  }

  _loadimage() async {
    if (h.androidVersion > 29) {
      for (String eachWpDirLabel in allowedDirLabel) {
        var cacheDirectoryPath = h.base.value +
            PathConstants.reelxWhatsAppCache +
            encodePathToName(
                PathConstants.foldersDock[eachWpDirLabel] as String);
        Directory cacheDirectory = Directory(cacheDirectoryPath);
        if (cacheDirectory.existsSync()) {
          imageList += cacheDirectory
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith(".jpg"))
              .toList(growable: false);
        }
      }
    } else {
      for (var data in PathConstants.whatsappFolders) {
        var path = h.base.value + data['wp']!['path'].toString();
        var easchWpDir = Directory(path);
        if (easchWpDir.existsSync()) {
          imageList += easchWpDir
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith(".jpg"))
              .toList(growable: false);
        }
      }
    }
  }

  _loadthumb() async {
    try {
      if (h.androidVersion > 29) {
        for (String eachWpDirLabel in allowedDirLabel) {
          var cacheDirectoryPath = h.base.value +
              PathConstants.reelxWhatsAppCache +
              encodePathToName(
                  PathConstants.foldersDock[eachWpDirLabel] as String);
          Directory cacheDirectory = Directory(cacheDirectoryPath);
          if (cacheDirectory.existsSync()) {
            videoList += cacheDirectory
                .listSync()
                .map((item) => item.path)
                .where((item) => item.endsWith(".mp4"))
                .toList(growable: false);
          }
        }
      } else {
        for (var data in PathConstants.whatsappFolders) {
          var path = h.base.value + data['wp']!['path'].toString();
          var eachWpDir = Directory(path);
          if (eachWpDir.existsSync()) {
            videoList += eachWpDir
                .listSync()
                .map((item) => item.path)
                .where((item) => item.endsWith(".mp4"))
                .toList(growable: false);
          }
        }
      }
      for (var vidPath in videoList) {
        String thumbnailPath = '${thumbDir.path}${getFileName(vidPath)}.png';
        if (!File('${thumbDir.path}${getFileName(vidPath)}.png').existsSync()) {
          await genrateThumb(vidPath, thumbnailPath);
        }
      }
    } catch (e) {}
  }

  Future<void> getPrefs(String property) async {
    switch (property) {
      case 'isGranted':
        isGranted.value = box.read('reelx_isGranted') ?? false;
        break;
      case 'allowedDirLabel':
        allowedDirLabel.value =
            box.read('reelx_allowedDirLabel')?.cast<String>() ?? [];
        break;
      case 'visibleDirLabel':
        visibleDirLabel.value =
            box.read('reelx_visibleDirLabel')?.cast<String>() ?? [];
        break;
      default:
        break;
    }
  }

  setPrefs(String property) async {
    final box = GetStorage();

    switch (property) {
      case 'isGranted':
        box.write('reelx_isGranted', isGranted.value);
        break;
      case 'allowedDirLabel':
        box.write('reelx_allowedDirLabel', allowedDirLabel);
        break;
      case 'visibleDirLabel':
        box.write('reelx_visibleDirLabel', visibleDirLabel);
        break;
      default:
        break;
    }
  }

  updateAllowedDir(String label) {
    if (!allowedDirLabel.contains(label)) {
      allowedDirLabel.add(label);
      setPrefs('allowedDirLabel');
    }
    update();
  }

  toggleShowGrantPermission() {
    showGrantPermission.value = true;
    update();
  }

  loadVisibleDir() {
    if (visibleDirLabel.isEmpty) {
      for (var data in PathConstants.whatsappFolders) {
        var path = h.base.value + data['wp']!['path'].toString();
        var label = data['wp']!['label'];
        var dir = Directory(path);
        if (dir.existsSync()) {
          visibleDirLabel.add(label!);
        }
      }
      update();
      setPrefs('visibleDirLabel');
    }
  }

  loadAssets() {
    _loadimage();
    _loadthumb();
  }

  handleWhatsAppPermissions(context) {
    for (var data in PathConstants.whatsappFolders) {
      var dirLabel = data['wp']!['label'];
      var title = data['wp']!['title'];
      loadVisibleDir();
      if (visibleDirLabel.contains(dirLabel) &&
          !allowedDirLabel.contains(dirLabel) &&
          !deniedDir.contains(dirLabel)) {
        return showDialog(
          context: context,
          builder: (_) => permissionDialog(
            title,
            context,
            dirLabel,
          ),
        );
      }
    }
    isGranted.value = allowedDirLabel.isNotEmpty;
    loadAssets(); // Bug in this line Duplicate images
    deniedDir.value = [];
    showGrantPermission.value = false;
    setPrefs('isGranted');
    setPrefs('visibleDirLabel');
    setPrefs('allowedDirLabel');
    update();
  }

  updateDeniedDir(String dir) {
    if (!deniedDir.contains(dir)) {
      deniedDir.add(dir);
    }
    update();
  }

  updateSelectedImageIndex(idx) {
    currentImagePathIndex.value = idx;
  }
}
