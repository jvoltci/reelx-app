import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelx/pages/social/whatsapp/controller/whatsapp_controller.dart';
import 'package:reelx/widgets/image_viewer.dart';

class WhatsAppImageTab extends StatelessWidget {
  const WhatsAppImageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final WhatsAppController whatsAppController = Get.find();

    if (whatsAppController.imageList.isNotEmpty) {
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
              itemCount: whatsAppController.imageList.length,
              itemBuilder: (context, index) {
                String imgPath = whatsAppController.imageList[index];
                return Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(
                          () => ImageViewer(
                              context: context,
                              paths: whatsAppController.imageList,
                              initialImageIndex: index),
                        ),
                        child: Container(
                          height: size.height * 0.18,
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color:
                                context.theme.textTheme.headlineMedium?.color,
                            shape: BoxShape.rectangle,
                          ),
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color:
                                context.theme.textTheme.headlineMedium?.color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            child: Image.file(
                              File(imgPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                    "No Image found.\n\n",
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
