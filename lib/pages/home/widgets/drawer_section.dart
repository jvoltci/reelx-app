import 'package:flutter/material.dart';
import 'package:reelx/controller/main_controller.dart';
import 'package:reelx/utils/helper/send_feedback.dart';
import 'package:get/get.dart';
import 'package:reelx/widgets/gradient_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainController m = Get.find();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.theme.primaryColor,
              image: const DecorationImage(
                repeat: ImageRepeat.repeat,
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/images/reelx_logo.png',
                ),
              ),
            ),
          ),
          accountName: const Text(''),
          accountEmail: GradientText(
            'Reelx',
            style: TextStyle(
              fontFamily: context.theme.textTheme.bodySmall?.fontFamily,
              fontSize: 50,
              color: context.theme.textTheme.displayLarge?.color,
            ),
            gradient: const LinearGradient(colors: [
              Colors.blue,
              Colors.amberAccent,
              Colors.redAccent,
              Colors.purple,
              Colors.white,
            ]),
          ),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.background,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ListTile(
            leading: Icon(
              Icons.camera_alt_outlined,
              color: context.theme.textTheme.displaySmall?.color,
            ),
            title: Text(
              'Instagram',
              style: TextStyle(
                fontSize: 40,
                fontFamily: context.theme.textTheme.bodySmall?.fontFamily,
                color: context.theme.textTheme.displaySmall?.color,
              ),
            ),
            onTap: () => Get.toNamed('/instagram'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: ListTile(
            leading: Icon(
              Icons.whatshot,
              color: context.theme.textTheme.displaySmall?.color,
            ),
            title: Text(
              'WhatsApp',
              style: TextStyle(
                fontSize: 40,
                fontFamily: context.theme.textTheme.bodySmall?.fontFamily,
                color: context.theme.textTheme.displaySmall?.color,
              ),
            ),
            onTap: () => Get.toNamed('/whatsapp'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              color: context.theme.textTheme.displaySmall?.color,
            ),
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 40,
                fontFamily: context.theme.textTheme.bodySmall?.fontFamily,
                color: context.theme.textTheme.displaySmall?.color,
              ),
            ),
            onTap: () => Get.toNamed('/about'),
          ),
        ),
        const Divider(
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
            leading: Icon(
              Icons.badge,
              color: Colors.greenAccent[400],
              size: 18,
            ),
            title: Text(
              'Tron',
              style: TextStyle(
                fontSize: 16,
                color: Colors.greenAccent[400],
              ),
            ),
            onTap: () => launchUrl(Uri(path: 'https://jvoltci.github.io/tron')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
            leading: Icon(
              Icons.email,
              color: context.theme.textTheme.displaySmall?.color,
              size: 14,
            ),
            title: Text(
              'Feedback',
              style: TextStyle(
                fontSize: 12,
                color: context.theme.textTheme.displaySmall?.color,
              ),
            ),
            onTap: () => sendFeedback(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
            leading: Icon(
              Icons.share,
              color: context.theme.textTheme.displaySmall?.color,
              size: 14,
            ),
            title: Text(
              'Share',
              style: TextStyle(
                fontSize: 12,
                color: context.theme.textTheme.displaySmall?.color,
              ),
            ),
            onTap: () => Share.share(
                'https://play.google.com/store/apps/details?id=com.ivehement.reelx&hl=en_IN&gl=US',
                subject:
                    "Reelx - Download Reels, Stories, Status, and many more one the go"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
            leading: Icon(
              Icons.star,
              color: context.theme.textTheme.displaySmall?.color,
              size: 14,
            ),
            title: Text(
              'Rate us',
              style: TextStyle(
                fontSize: 12,
                color: context.theme.textTheme.displaySmall?.color,
              ),
            ),
            onTap: () => launchUrl(Uri(
                path:
                    'https://play.google.com/store/apps/details?id=com.ivehement.reelx&hl=en_IN&gl=US')),
          ),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ListTile(
              title: !m.isDarkMode.value
                  ? IconButton(
                      iconSize: 40.0,
                      onPressed: () => m.toggleMode(),
                      icon: const Icon(
                        Icons.light_mode,
                        color: Colors.yellow,
                      ),
                    )
                  : IconButton(
                      iconSize: 40.0,
                      onPressed: () => m.toggleMode(),
                      icon: const Icon(
                        Icons.nights_stay,
                        color: Color(0xff00008b),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
