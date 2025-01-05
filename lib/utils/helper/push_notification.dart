import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reelx/utils/contstants/path_constants.dart';
import 'package:reelx/utils/helper/get_hash_name.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  // if (message.data.containsKey('url')) {
  //   // Handle data message
  //   launchUrl(message.data['url']);
  // }

  // if (message.data.containsKey('notification')) {
  //   // Handle notification message
  //   final notification = message.data['notification'];
  // }
}

class FCM {
  // final _firebaseMessaging = FirebaseMessaging.instance;

  // final streamCtlr = StreamController<String>.broadcast();
  // final titleCtlr = StreamController<String>.broadcast();
  // final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    // FirebaseMessaging.onMessage.listen(
    //   (message) async {
    //     if (message.notification != null) {
    //       launchUrl(message.data['url']);
    //     }
    //     if (message.data.containsKey('url')) {
    //       // Handle data message
    //       launchUrl(message.data['url']);
    //       //streamCtlr.sink.add(message.data['data']);
    //     }
    //     if (message.data.containsKey('notification')) {
    //       // Handle notification message
    //       streamCtlr.sink.add(message.data['notification']);
    //     }
    //     // Or do other work.
    //     titleCtlr.sink.add(message.notification!.title!);
    //     bodyCtlr.sink.add(message.notification!.body!);
    //   },
    // );
    // With this token you can test it easily on your phone
    // _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  Future<void> initializePushNotification(base) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description,
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        var imagePath = await downloadImage(base, message.data['image']);
        // launchUrl(message.data['url']);
        // String _payload;
        // if (message.data['url']) {
        //   _payload = '${message.data['url']}~url';
        // } else {
        //   _payload = '~url';
        // }
        var bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          largeIcon: FilePathAndroidBitmap(imagePath),
          contentTitle: '<b>${notification.body}</b>',
          summaryText: '<i>${notification.body}</i>',
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
        );

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              styleInformation: bigPictureStyleInformation,
              //ledColor: Colors.pink.shade400,
            ),
          ),
          // payload: _payload,
        );
      }
    });
  }

// refactor
  downloadImage(base, url) async {
    var dir = Directory(base + PathConstants.reelxInstagramThumbPath);
    final fileName = getHashName(url);
    String savePath = '${dir.path}/$fileName.jpg';
    try {
      await Dio().download(url, savePath);
    } catch (e) {}
    return savePath;
  }

  // Future<void> setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }

  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // void _handleMessage(RemoteMessage message) {
  //   if (message.data['type'] == 'chat') {}
  // }

  // dispose() {
  //   streamCtlr.close();
  //   bodyCtlr.close();
  //   titleCtlr.close();
  // }
}
