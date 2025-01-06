import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reelx/controller/main_controller.dart';
import 'package:reelx/pages/about/view/about.dart';
import 'package:reelx/pages/home/view/home.dart';
import 'package:reelx/pages/social/instagram/view/instagram.dart';
import 'package:reelx/pages/social/whatsapp/view/whatsapp.dart';
import 'package:reelx/utils/helper/ads.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reelx/utils/styles.dart';
import 'package:get/get.dart';
import 'package:reelx/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Ads.initializeAdmob();
  // await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Styles.appBarShadowColorDark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();

  await _precacheSvgAssets();

  runApp(const MyApp());
}

Future<void> _precacheSvgAssets() async {
  try {
    final svgPaths = [
      'assets/images/instagram_glass_reelx.svg',
      'assets/images/whatsapp_glass_reelx.svg',
      'assets/images/logo_reelx.svg',
    ];

    for (String path in svgPaths) {
      final loader = SvgAssetLoader(path);
      svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  } catch (error) {
    debugPrint('Error during SVG asset caching: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mc = Get.put(MainController());
    final box = GetStorage();
    final isDarkMode = box.read('reelx_mode') ?? false;

    return GetMaterialApp(
      title: 'ReelX',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(
          name: '/instagram',
          page: () => const InstagramScreen(),
          transition: Transition.zoom,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: '/whatsapp',
          page: () => const WhatsAppScreen(),
          transition: Transition.zoom,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: '/about',
          page: () => const AboutScreen(),
          transition: Transition.leftToRight,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
