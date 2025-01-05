// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

// class Log {
//   static final analytics = FirebaseAnalytics.instance;

//   static onLogin(FirebaseAnalytics analytics) async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     analytics.setUserProperty(
//       name: 'user_Device',
//       value: androidInfo.toString(),
//     );
//   }

//   static void onTronClick(FirebaseAnalytics analytics) {
//     DateTime _now = DateTime.now();
//     analytics.logEvent(
//       name: 'tron_Click',
//       parameters: {
//         'timestamp':
//             '${_now.year}.${_now.month}.${_now.day}|${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}',
//       },
//     );
//   }
// }
