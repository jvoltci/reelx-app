import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelx/pages/social/whatsapp/controller/whatsapp_controller.dart';
import 'package:reelx/utils/helper/get_saf_permission.dart';
import 'package:reelx/utils/helper/sync_whatsapp.dart';

permissionDialog(title, ctx, dirLabel) {
  Size size = MediaQuery.of(ctx).size;
  WhatsAppController w = Get.find();

  handlePermissionAndCache() async {
    var allowed = await getSafPermission(dirLabel);
    if (allowed) {
      w.updateAllowedDir(dirLabel);
      syncWhatsApp(dirLabel);
      Get.back();
    } else {
      Get.back();
    }
  }

  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: Theme.of(ctx).primaryColor,
    title: Text(
      title,
      style: TextStyle(
          color: Theme.of(ctx).textTheme.displayMedium?.color, fontSize: 17),
      textAlign: TextAlign.center,
    ),
    content: SizedBox(
      height: size.height * 0.2,
      width: size.width * 0.8,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Allow Access to ".Statuses" Folder',
              style: TextStyle(
                  color: Theme.of(ctx).textTheme.displayMedium?.color,
                  fontSize: 17),
            ),
          ),
          Expanded(
            child: Container(
              height: size.height * 0.2,
              width: size.width * 0.8,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/use_this_folder.png'),
                    fit: BoxFit.contain),
              ),
            ),
          ),
          Text(
            '*Required on Android 11 or Later',
            style: TextStyle(
              color: Theme.of(ctx).textTheme.displayMedium?.color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        child: Text(
          "Cancel",
          style: TextStyle(color: Theme.of(ctx).textTheme.displayMedium?.color),
        ),
        onPressed: () {
          w.updateDeniedDir(dirLabel);
          Get.back();
        },
      ),
      ElevatedButton(
        onPressed: handlePermissionAndCache,
        child: const Text("Grant Permission"),
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(ctx).colorScheme.background),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    ],
    actionsAlignment: MainAxisAlignment.spaceAround,
  );
}
