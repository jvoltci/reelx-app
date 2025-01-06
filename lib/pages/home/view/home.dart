import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reelx/pages/home/cotroller/home_controller.dart';
import 'package:reelx/pages/home/widgets/appbar_section.dart';
import 'package:reelx/pages/home/widgets/drawer_section.dart';
import 'package:reelx/pages/home/widgets/social_card.dart';
import 'package:get/get.dart';
import 'package:reelx/pages/home/widgets/tron_container.dart';
import 'package:reelx/pages/social/whatsapp/controller/whatsapp_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController homeController;
  @override
  void initState() {
    Get.put(WhatsAppController(context));
    homeController = Get.put(HomeController());
    super.initState();
  }

  Widget? renderAdType() {
    return GetX<HomeController>(
      builder: (hm) {
        if (homeController.tron.value) {
          return tronContainer(hm)!;
        } else {
          return AdWidget(ad: hm.homeBottomBannerAd);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      drawer: Drawer(
        backgroundColor: context.theme.primaryColor,
        child: const DrawerSection(),
      ),
      drawerEdgeDragWidth: size.width * 0.8,
      drawerDragStartBehavior: DragStartBehavior.start,
      body: Builder(
        builder: (context) {
          return const SafeArea(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  AppBarSection(),
                  SocialCard(
                      asset: 'assets/images/instagram_glass_reelx.svg',
                      title: 'Instagram',
                      route: '/instagram'),
                  SocialCard(
                      asset: 'assets/images/whatsapp_glass_reelx.svg',
                      title: 'WhatsApp',
                      route: '/whatsapp'),
                  // GetX<HomeController>(
                  //   builder: (h) {
                  //     if (h.tron.value) {R
                  //       return Tron(hm: h);
                  //     } else {
                  //       return const SizedBox();
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: homeController.homeBottomBannerAd.size.height.toDouble(),
        width: homeController.homeBottomBannerAd.size.width.toDouble(),
        child: renderAdType(),
      ),
    );
  }
}
