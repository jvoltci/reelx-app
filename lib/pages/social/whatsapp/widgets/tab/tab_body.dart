import 'package:flutter/material.dart';
import 'package:reelx/pages/social/whatsapp/widgets/whatsapp_images.dart';
import 'package:reelx/pages/social/whatsapp/widgets/whatsapp_videos.dart';

class TabBody extends StatelessWidget {
  final whatsappTabController;
  const TabBody({required this.whatsappTabController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: whatsappTabController,
        children: [
          const WhatsAppImageTab(), // Do not make this const else image will not load as normal
          WhatsAppVideoTab(),
        ],
      ),
    );
  }
}
