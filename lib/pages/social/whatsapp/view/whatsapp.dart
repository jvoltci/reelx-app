import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reelx/pages/home/cotroller/home_controller.dart';
import 'package:reelx/pages/social/whatsapp/controller/whatsapp_controller.dart';
import 'package:reelx/pages/social/whatsapp/widgets/tab/tab_section.dart';

class WhatsAppScreen extends StatefulWidget {
  const WhatsAppScreen({Key? key}) : super(key: key);

  @override
  State<WhatsAppScreen> createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends State<WhatsAppScreen>
    with TickerProviderStateMixin {
  late TabController _whatsappTabController;

  @override
  void initState() {
    Get.put(WhatsAppController(context));
    loadFirstTab();
    _whatsappTabController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  void loadFirstTab() {
    Timer(const Duration(milliseconds: 100), () {
      setState(() => _whatsappTabController.animateTo(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    HomeController h = Get.find();

    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: SafeArea(
        child: GetBuilder<WhatsAppController>(
          builder: (wx) {
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_left),
                          iconSize: 60,
                          color: context.theme.textTheme.displaySmall?.color,
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/whatsapp_glass_reelx.svg',
                      height: size.height * 0.25,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'STATUS',
                        style: TextStyle(
                          color: context.theme.textTheme.displaySmall?.color,
                          fontSize: 18,
                          fontFamily:
                              context.theme.textTheme.bodySmall?.fontFamily,
                        ),
                      ),
                    ),
                    if (h.androidVersion.value > 29 &&
                        (!wx.isGranted.value || wx.showGrantPermission.value))
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () =>
                                    wx.handleWhatsAppPermissions(context),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    const Color(0xff4dcb5b),
                                  ),
                                  elevation: WidgetStateProperty.all(8.0),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                  fixedSize: WidgetStateProperty.all(
                                    Size.fromWidth(size.width * 0.5),
                                  ),
                                ),
                                child: SizedBox(
                                  height: size.height * 0.03,
                                  child: const FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Grant Permissions',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...tabSection(_whatsappTabController)
                  ],
                ),
                if (wx.allowedDirLabel.length < wx.visibleDirLabel.length)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.check_circle_sharp,
                        color: Color(0xff4dcb5b),
                      ),
                      onPressed: () => wx.toggleShowGrantPermission(),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
