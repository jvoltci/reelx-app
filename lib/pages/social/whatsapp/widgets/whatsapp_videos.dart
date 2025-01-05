import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelx/pages/social/whatsapp/controller/whatsapp_controller.dart';
import 'package:reelx/utils/helper/get_file_name.dart';
import 'package:reelx/widgets/video_player.dart';

class WhatsAppVideoTab extends StatelessWidget {
  WhatsAppVideoTab({Key? key}) : super(key: key);
  final WhatsAppController whatsAppController = Get.find();

  void _modalBottomSheetMenu(BuildContext context, Size size, String vidPath) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        context: context,
        builder: (builder) {
          return SizedBox(
              height: size.height * 0.15,
              child: Container(
                padding: const EdgeInsets.all(40),
                width: size.width * 0.8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        enableFeedback: false,
                        elevation:
                            WidgetStateProperty.resolveWith((states) => 15),
                        shape: WidgetStateProperty.resolveWith(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => context.theme.colorScheme.background),
                        fixedSize: WidgetStateProperty.resolveWith(
                          (states) => Size.fromWidth(size.width * 0.2),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        whatsAppController.share(vidPath);
                      },
                      child: const Icon(Icons.share),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        enableFeedback: false,
                        elevation:
                            WidgetStateProperty.resolveWith((states) => 15),
                        shape: WidgetStateProperty.resolveWith(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => const Color(0xff4dcb5b)),
                        fixedSize: WidgetStateProperty.resolveWith(
                          (states) => Size.fromWidth(size.width * 0.30),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        Get.to(() => ReelxVideoPlayer(path: vidPath));
                      },
                      child: const Icon(Icons.play_arrow),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        enableFeedback: false,
                        elevation:
                            WidgetStateProperty.resolveWith((states) => 15),
                        shape: WidgetStateProperty.resolveWith(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => context.theme.colorScheme.background),
                        fixedSize: WidgetStateProperty.resolveWith(
                          (states) => Size.fromWidth(size.width * 0.2),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        whatsAppController.showWpInterstitialAd(vidPath);
                      },
                      child: const Icon(Icons.download),
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (whatsAppController.videoList.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: size.width / size.height * 1.8,
              ),
              itemCount: whatsAppController.videoList.length,
              itemBuilder: (context, index) {
                String vidPath = whatsAppController.videoList[index];
                String thumbnailPath =
                    '${thumbDir.path}${getFileName(vidPath)}.png';

                return Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            _modalBottomSheetMenu(context, size, vidPath),
                        child: Stack(
                          children: [
                            Container(
                              height: size.height * 0.18,
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: context
                                    .theme.textTheme.headlineMedium?.color,
                                shape: BoxShape.rectangle,
                              ),
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: context
                                    .theme.textTheme.headlineMedium?.color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                child: Image.file(
                                  File(thumbnailPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "No Video found.\n\n",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily:
                            context.theme.textTheme.bodySmall?.fontFamily,
                        fontWeight: FontWeight.w100,
                        color: context.theme.textTheme.displaySmall?.color),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    "Watch whatsApp status \nand come back here!",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily:
                            context.theme.textTheme.bodySmall?.fontFamily,
                        fontWeight: FontWeight.w100,
                        color: context.theme.textTheme.displaySmall?.color),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
