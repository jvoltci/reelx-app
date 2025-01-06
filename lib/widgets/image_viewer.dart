import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reelx/pages/social/whatsapp/controller/whatsapp_controller.dart';
import 'package:reelx/utils/helper/save_file.dart';
import 'dart:io';

import 'package:reelx/utils/styles.dart';
import 'package:reelx/widgets/fab_with_icons.dart';
import 'package:share_plus/share_plus.dart';

class ImageViewer extends StatelessWidget {
  final WhatsAppController whatsAppController = Get.find();
  final BuildContext context;
  final List<String> paths;
  final String social;
  final int? initialImageIndex;
  ImageViewer(
      {required this.context,
      required this.paths,
      this.social = 'whatsapp',
      this.initialImageIndex,
      Key? key})
      : super(key: key);

  void share() =>
      Share.share(paths[whatsAppController.currentImagePathIndex.value]);

  void save() {
    saveFile(paths[whatsAppController.currentImagePathIndex.value]);
    Get.snackbar(
      'Downloaded',
      'location: ~Internal storage/Download/Reelx',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Styles.secondaryBackgrondColor,
      colorText: Styles.headline1Color,
    );
  }

  Container showAd(WhatsAppController w) {
    final AdWidget adWidget = AdWidget(ad: w.wpBottomBannerAd);
    final Container adContainer = Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      alignment: Alignment.center,
      child: adWidget,
      height: w.wpBottomBannerAd.size.height.toDouble(),
      width: w.wpBottomBannerAd.size.width.toDouble(),
    );
    return adContainer;
  }

  Widget _buildFab(BuildContext context, String social) {
    if (social == 'instagram') {
      final backgroundColor = context.theme.colorScheme.background;
      final foregroundColor = context.theme.textTheme.displayLarge?.color;
      return FloatingActionButton(
        onPressed: () => share(),
        backgroundColor: backgroundColor,
        child: Icon(
          Icons.share,
          color: foregroundColor,
        ),
      );
    }
    final icons = [Icons.share, Icons.download];
    return FabWithIcons(
      icons: icons,
      onIconTapped: (index) {
        if (index == 0) {
          share();
        }
        if (index == 1) {
          save();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    whatsAppController.updateSelectedImageIndex(initialImageIndex);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: size.height,
                viewportFraction: 1.0,
                initialPage: initialImageIndex ?? 0,
                onPageChanged: (i, _) =>
                    whatsAppController.updateSelectedImageIndex(i),
              ),
              items: paths.map((path) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            image: DecorationImage(
                              image: Image.file(File(path)).image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          height: size.height,
                          width: size.width,
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            Positioned(
              child: showAd(whatsAppController),
              top: size.height * 0.004,
              right: 2,
            ),
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_left),
              iconSize: 60,
              color: context.theme.textTheme.displaySmall?.color,
            ),
          ],
        ),
        floatingActionButton: _buildFab(context, social),
      ),
    );
  }
}
