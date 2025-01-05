import 'dart:io';

import 'package:get/get.dart';
import 'package:reelx/pages/home/cotroller/home_controller.dart';
import 'package:reelx/utils/api/serve_api.dart';
import 'package:reelx/utils/contstants/path_constants.dart';

HomeController h = Get.find();

String reelxWhatsappPath = h.base.value + PathConstants.reelxWhatsappPath;

Future<void> saveFile(String filePath, {social = "whatsapp"}) async {
  switch (social) {
    case 'whatsapp':
      try {
        String basePath = reelxWhatsappPath;
        File originalFile = File(filePath);

        List pathFolderList = filePath.split('/');
        String fileName = pathFolderList[pathFolderList.length - 1];

        String newFile = "$basePath/$fileName";

        await originalFile.copy(newFile);
      } catch (e) {}
      break;
    case 'instagram':
      try {
        String basePath = reelxWhatsappPath;
        File originalFile = File(filePath);

        List pathFolderList = filePath.split('/');
        String fileName = pathFolderList[pathFolderList.length - 1];

        String newFile = "$basePath/$fileName";

        await originalFile.copy(newFile);
      } catch (e) {}
      break;
    default:
      break;
  }
  await updateDownloadHit(social);
}
