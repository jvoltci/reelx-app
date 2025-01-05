import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reelx/utils/contstants/api_constants.dart';
import 'package:reelx/utils/contstants/channel_constants.dart';
import 'package:get/get.dart';
import 'package:reelx/widgets/video_player.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

const String key = ApiConstants.key;
const String downloadHitApi = ApiConstants.downloadHit;

class MainController extends GetxController {
  var isDarkMode = false.obs;
  var downloadHit = '😊'.obs;
  var dataShared = ''.obs;
  final platform = const MethodChannel(ChannelConstants.DEFAULT_CHANNEl);
  // final analytics = Log.analytics;

  final storage = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    await GetStorage.init();
    getPrefs('downloadHit');
    getSharedText();
    // Log.onLogin(analytics);
    initializeClosedLocalNotification();
  }

  @override
  void onReady() async {
    super.onReady();
    getDownloadHit();
  }

  getPrefs(String property) async {
    switch (property) {
      case 'downloadHit':
        downloadHit.value = storage.read('reelx_hit') ?? '😊';
        break;
      case 'mode':
        isDarkMode.value = storage.read('reelx_mode') ?? false;
        break;
      default:
        break;
    }
  }

  setPrefs(String property) async {
    switch (property) {
      case 'downloadHit':
        storage.write('reelx_hit', downloadHit.value);
        break;
      case 'mode':
        storage.write('reelx_mode', !isDarkMode.value);
        break;
      default:
        break;
    }
  }

  getDownloadHit() async {
    try {
      final dio = Dio();
      final response = await dio.get('$downloadHitApi/?api=$key');
      Map<String, dynamic> result = jsonDecode(response.toString());
      downloadHit.value = result['data']['hit'].toString();
      setPrefs('downloadHit');
    } catch (e) {}
  }

  Future<void> getSharedText() async {
    var sharedData = await platform.invokeMethod('getSharedText');
    if (sharedData != null) {
      dataShared.value = sharedData;
      Get.toNamed('/instagram', arguments: dataShared.value);
    }
  }

  toggleMode() {
    if (isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.dark);
      isDarkMode.value = false;
      setPrefs('mode');
    } else {
      Get.changeThemeMode(ThemeMode.light);
      isDarkMode.value = true;
      setPrefs('mode');
    }
    update();
  }

  initializeClosedLocalNotification() async {
    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initSetttings =
    //     InitializationSettings(android: initializationSettingsAndroid);
    // await FlutterLocalNotificationsPlugin().initialize(initSetttings);
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await FlutterLocalNotificationsPlugin()
            .getNotificationAppLaunchDetails();
    String? payload = notificationAppLaunchDetails.toString();
    final path = payload?.split('~')[0];
    final isVideo = payload?.split('~')[1];
    if (payload != null) {
      switch (isVideo) {
        case "true":
          Get.to(() => ReelxVideoPlayer(path: path!));
          break;
        case "url":
          launchUrl(Uri(path: path!));
          break;
        default:
          break;
      }
    }
  }
}
