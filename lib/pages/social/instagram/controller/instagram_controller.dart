import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reelx/pages/home/cotroller/home_controller.dart';
import 'package:reelx/utils/api/serve_api.dart';
import 'package:reelx/utils/contstants/api_constants.dart';
import 'package:reelx/utils/contstants/path_constants.dart';
import 'package:reelx/utils/helper/ads.dart';
import 'package:reelx/utils/helper/generate_thumbnail.dart';
import 'package:reelx/utils/helper/get_saf_permission.dart';
import 'package:reelx/utils/helper/get_file_name.dart';
import 'package:reelx/utils/helper/get_hash_name.dart';
import 'package:reelx/widgets/image_viewer.dart';
import 'package:reelx/widgets/video_player.dart';
import 'package:saf/saf.dart';
import 'package:url_launcher/url_launcher.dart';

HomeController h = Get.find();

var reelxDir = Directory(h.base.value + PathConstants.reelxPath);
var dir = Directory(h.base.value + PathConstants.reelxInstagramPath);
Directory thumbDir =
    Directory(h.base.value + PathConstants.reelxInstagramThumbPath);

const String key = ApiConstants.key;
const String instagramApi = ApiConstants.downloadInstagramMeta;

class InstagramController extends GetxController {
  late BuildContext context;

  InterstitialAd? instaInterstitialAd;
  var maxFailedLoadAttempts = 3;
  var interstitialLoadAttempts = 0.obs;
  late BannerAd instaBottomBannerAd;
  var isInstaBottomBannerAdLoaded = false.obs;

  var isreelxGranted = false.obs;
  final androidVersion = h.androidVersion.value;
  var url = ''.obs;
  var isDownloadButtonDisabled = true.obs;
  var progress = 0.00.obs;
  var processing = false.obs;
  var sharedText = ''.obs;
  var isShared = false.obs;
  var showSpin = false.obs;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final urlController = TextEditingController();

  InstagramController(this.context);

  @override
  void onInit() async {
    super.onInit();
    createInstaBottomBannerAd();
    reelxDir.createSync(recursive: true);
    checkReelxPermission();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    if (!thumbDir.existsSync()) {
      thumbDir.createSync(recursive: true);
    }
    createInstaInterstitialAd();
    intializeNotificationPlugin();
  }

  @override
  void onClose() async {
    instaBottomBannerAd.dispose();
    instaInterstitialAd?.dispose();
    showSpin.value = false;
    super.dispose();
  }

  createInstaInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Ads.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          instaInterstitialAd = ad;
          interstitialLoadAttempts.value = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialLoadAttempts.value += 1;
          instaInterstitialAd = null;
          if (interstitialLoadAttempts.value <= maxFailedLoadAttempts) {
            createInstaInterstitialAd();
          }
        },
      ),
    );
  }

  void showInstaInterstitialAd() {
    if (instaInterstitialAd != null) {
      instaInterstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          downloadInstagramMedia();
          ad.dispose();
          createInstaInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          if (interstitialLoadAttempts.value > maxFailedLoadAttempts) {
            downloadInstagramMedia();
          }
          ad.dispose();
          createInstaInterstitialAd();
        },
      );
      instaInterstitialAd!.show();
    } else {
      downloadInstagramMedia();
    }
  }

  createInstaBottomBannerAd() {
    instaBottomBannerAd = BannerAd(
      adUnitId: Ads.bannerAdUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isInstaBottomBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    instaBottomBannerAd.load();
  }

  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Denied',
        'You need to grant notification permissions to receive download notifications.',
        backgroundColor: context.theme.colorScheme.background,
        colorText: context.theme.textTheme.displayLarge?.color,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void updateUrlController(val, {input = true}) {
    val.toString().replaceAll(RegExp(r'(\n){3,}'), '');
    val.toString().replaceAll(RegExp(r'\?igshid=.*'), '');
    if (input) {
      urlController.text =
          val.toString().replaceAll(RegExp(r'\?igshid=.*'), '');
    }
    url.value = val;
    updateDownloadButtonDisableStatus();
  }

  void updateDownloadButtonDisableStatus() {
    if (url.value.length > 1) {
      isDownloadButtonDisabled.value = false;
    } else {
      isDownloadButtonDisabled.value = true;
    }
  }

  bool validateURL(List<String> urls) {
    String pattern = r'^((http(s)?:\/\/)?((w){3}.)?instagram?(\.com)?\/|).+$';
    RegExp regex = RegExp(pattern);

    for (var url in urls) {
      if (!regex.hasMatch(url)) {
        return false;
      }
    }
    return true;
  }

  void pasteIt() async {
    try {
      Map<String, dynamic> result =
          await SystemChannels.platform.invokeMethod('Clipboard.getData');
      result['text'] =
          result['text'].toString().replaceAll(RegExp(r'\?igshid=.*'), '');
      result['text'] = result['text'].toString();
      urlController.text =
          result['text'].toString().replaceAll(RegExp(r'\?igshid=.*'), '');
      url.value = urlController.text;
      updateDownloadButtonDisableStatus();
    } catch (e) {}
  }

  Future<String> _startDownload() async {
    final dio = Dio();
    try {
      var fileUrl = '';
      var isVideo = true;
      var linkEdit = url.value.replaceAll(" ", "").split("/");
      if (!linkEdit[3].contains('reel') &&
          !linkEdit[3].contains('p') &&
          !linkEdit[3].contains('tv')) {
        linkEdit[4] = linkEdit[5];
      }
      final link = '${linkEdit[0]}//${linkEdit[2]}/p/${linkEdit[4]}';

      try {
        // Native Download
        var response = await dio.get('$link/?__a=1');
        var data = response.data;
        var graphql = data['graphql'];
        var shortcodeMedia = graphql['shortcode_media'];
        if (shortcodeMedia['__typename'] == 'GraphImage') {
          isVideo = false;
        }
        fileUrl = shortcodeMedia['video_url'];
        String type = isVideo ? "video" : "image";
        final fileName = getHashName(url.value);
        final fileExtension = isVideo ? '.mp4' : '.jpg';

        String savePath = '${dir.path}/$fileName$fileExtension';

        showSpin.value = false;
        await dio.download(fileUrl, savePath,
            onReceiveProgress: (actualBytes, totalBytes) {
          var mB = actualBytes / 998809.5;
          progress.value = mB.toPrecision(2);
        }).then((_) async => await updateInstagram(url.value, fileUrl, type));
        return savePath;
      } catch (e) {
        var response =
            await dio.post(instagramApi, data: {'url': link, "api": key});
        Map<String, dynamic> result = jsonDecode(response.toString());
        if (result['message'] == 'success') {
          fileUrl = result['data']['file_url'];
          isVideo = result['data']['type'] == 'image' ? false : true;
          final fileName = getHashName(url.value);
          final fileExtension = isVideo ? '.mp4' : '.jpg';
          String savePath = '${dir.path}/$fileName$fileExtension';

          showSpin.value = false;
          await dio.download(fileUrl, savePath,
              onReceiveProgress: (actualBytes, totalBytes) {
            var mB = actualBytes / 998809.5;
            progress.value = mB.toPrecision(2);
          });
          return savePath;
        }
      }
      return '';
    } catch (e) {
      //print(e);
    }
    return '';
  }

  downloadInstagramMedia() async {
    if (url.value == '') return;

    // Request permission before showing notifications
    await requestNotificationPermission();

    processing.value = true;
    showSpin.value = true;

    try {
      String path;
      await _startDownload().then((value) async {
        if (value == '') throw ('Link generating error');
        path = value;
        String thumbnailPath = '${thumbDir.path}${getFileName(path)}.png';
        final generated = await genrateThumb(path, thumbnailPath);

        BigPictureStyleInformation bigPictureStyleInformation;
        if (generated) {
          bigPictureStyleInformation = BigPictureStyleInformation(
            FilePathAndroidBitmap(thumbnailPath),
            largeIcon: FilePathAndroidBitmap(thumbnailPath),
            contentTitle: '<b>Reelx</b>',
            htmlFormatContentTitle: true,
            summaryText: '<i>Download Reels | Post | Status</i>',
            htmlFormatSummaryText: true,
          );
        } else {
          bigPictureStyleInformation = BigPictureStyleInformation(
            FilePathAndroidBitmap(path),
            largeIcon: FilePathAndroidBitmap(path),
            contentTitle: '<b>Reelx</b>',
            htmlFormatContentTitle: true,
            summaryText: '<i>Download Reels | Post | Status</i>',
            htmlFormatSummaryText: true,
          );
        }

        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'reelx',
          'reelx instagram',
          channelDescription: 'Instagram Media Downloader',
          icon: '@mipmap/ic_launcher',
          color: context.theme.primaryColor,
          enableLights: true,
          styleInformation: bigPictureStyleInformation,
          importance: Importance.max,
          priority: Priority.high,
          channelAction: AndroidNotificationChannelAction.createIfNotExists,
          ticker: 'ticker',
        );
        NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        await flutterLocalNotificationsPlugin.show(
          0,
          'Downloaded',
          'location: ~Internal storage/Download/Reelx',
          platformChannelSpecifics,
          payload: '$path~$generated',
        );
      });
    } catch (e) {
      log('Error: $e');
      Get.snackbar(
        'Oops! Issues might be',
        "Invalid Link | No Internet | Private Post | Server Down\nTry again in sometime",
        backgroundColor: context.theme.colorScheme.background,
        colorText: context.theme.textTheme.displayLarge?.color,
        duration: const Duration(seconds: 3),
      );
    }

    processing.value = false;
    progress.value = 0.00;
  }

  intializeNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
    );
  }

  void selectNotification(NotificationResponse response) async {
    final payload = response.payload!;
    final path = payload.split('~')[0];
    final isVideo = payload.split('~')[1];
    if (payload != null) {
      switch (isVideo) {
        case "true":
          Get.to(() => ReelxVideoPlayer(path: path!));
          break;
        case "false":
          List<String> paths = [];
          paths.add(path!);
          Get.to(() => ImageViewer(
                context: context,
                paths: paths,
                social: 'instagram',
                initialImageIndex: 0,
              ));
          break;
        case "url":
          launchUrl(Uri(path: path));
          break;
        default:
          break;
      }
    }
  }

  void updateSharedText(String text) {
    sharedText.value = text;
    isShared.value = true;
  }

  handleWhatsAppPermissions() async {
    await getSafPermission('reelx').then((_) => checkReelxPermission());
  }

  checkReelxPermission() async {
    var allowedDirectories = await Saf.getPersistedPermissionDirectories();
    if (allowedDirectories != null &&
        allowedDirectories.contains(PathConstants.reelxPath)) {
      isreelxGranted.value = true;
    } else {
      isreelxGranted.value = false;
    }
    if (allowedDirectories != null) update();
  }
}
