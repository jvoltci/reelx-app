import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reelx/pages/social/instagram/controller/instagram_controller.dart';
import 'package:reelx/pages/social/instagram/widgets/my_elevated_button.dart';

class InstagramScreen extends StatelessWidget {
  const InstagramScreen({Key? key}) : super(key: key);

  void dismissOnScreenKeyboard(BuildContext ctx) {
    FocusScopeNode currentFocus = FocusScope.of(ctx);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String sharedText = Get.arguments ?? '';
    final size = MediaQuery.of(context).size;
    final instagramController = Get.put(InstagramController(context));
    if (sharedText.isNotEmpty) {
      instagramController.updateUrlController(sharedText);
    }

    Container spinkit = Container(
      margin: const EdgeInsets.only(top: 23),
      child: const SpinKitHourGlass(
        color: Color(0xff00008b),
        size: 50.0,
      ),
    );

    return GestureDetector(
      onTap: () => dismissOnScreenKeyboard(context),
      child: Scaffold(
        backgroundColor: context.theme.primaryColor,
        body: SafeArea(
          child: GetBuilder<InstagramController>(builder: (inst) {
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
                      'assets/images/logo_reelx.svg',
                      height: size.height * 0.30,
                    ),
                    if (inst.androidVersion > 29 &&
                        inst.isreelxGranted.value == false)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () => instagramController
                                    .handleWhatsAppPermissions(),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    const Color(0xffbc2a8d),
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
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.03),
                              child: Text(
                                'Paste link here...',
                                style: TextStyle(
                                    color: context
                                        .theme.textTheme.displaySmall?.color,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context
                                      .theme.textTheme.displayMedium?.color,
                                ),
                                onChanged: (value) => instagramController
                                    .updateUrlController(value, input: false),
                                controller: instagramController.urlController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                      color: context.theme.textTheme
                                          .headlineSmall!.color!,
                                      width: 2.0,
                                    ),
                                  ),
                                  fillColor: context.theme.primaryColor,
                                  filled: true,
                                  suffixIcon: IconButton(
                                      color: context.theme.textTheme
                                          .headlineSmall!.color!,
                                      onPressed: () {
                                        instagramController
                                            .updateUrlController('');
                                      },
                                      icon: const Icon(
                                        Icons.insights,
                                      )),
                                  prefixIcon: SvgPicture.asset(
                                    'assets/images/instagram_glass_reelx.svg',
                                    height: 0.02,
                                  ),
                                  hintText: 'e.g. Reels | Post | Status',
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff848484),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: size.width * 0.8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyElevatedButton(
                                    text: 'Paste',
                                    onPressed: () =>
                                        instagramController.pasteIt(),
                                  ),
                                  Obx(
                                    () => MyElevatedButton(
                                      text: 'Download',
                                      onPressed: () async {
                                        dismissOnScreenKeyboard(context);
                                        instagramController
                                            .showInstaInterstitialAd();
                                      },
                                      disable: instagramController
                                              .isDownloadButtonDisabled.value ||
                                          instagramController.processing.value,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Obx(
                              () => instagramController.processing.value
                                  ? (instagramController.showSpin.value
                                      ? spinkit
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Downloading... ${instagramController.progress} MB',
                                            style: const TextStyle(
                                                color: Color(0xff4dcb5b),
                                                fontSize: 20),
                                          ),
                                        ))
                                  : const SizedBox(),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ],
            );
          }),
        ),
        bottomNavigationBar: SizedBox(
          height:
              instagramController.instaBottomBannerAd.size.height.toDouble(),
          width: instagramController.instaBottomBannerAd.size.width.toDouble(),
          child: AdWidget(ad: instagramController.instaBottomBannerAd),
        ),
      ),
    );
  }
}
