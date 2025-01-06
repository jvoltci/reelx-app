import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathConstants {
  PathConstants();

  static const String reelxPath = 'Download/Reelx';
  static const String reelxWhatsAppCache =
      'Android/data/com.ivehement.reelx/files/';

  static const String whatsappOldPath = 'WhatsApp/Media/.Statuses';
  static const String whatsappNewPath =
      'Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
  static const String whatsappBusinessOldPath =
      'Android/WhatsApp Business/Media/.Statuses';
  static const String whatsappBusinessNewPath =
      'Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
  static const String whatsappGBOldPath = 'GBWhatsApp/Media/.Statuses';

  static const String reelxWhatsappPath = 'Download/Reelx/WhatsApp';
  static const String reelxwhatsappThumbPath =
      'Download/Reelx/.thumbs/.whatsapp/';

  static const String reelxInstagramPath = 'Download/Reelx/Instagram';
  static const String reelxInstagramThumbPath =
      'Download/Reelx/.thumbs/.instagram/';

  static const whatsappFolders = [
    {
      'wp': {
        "path": 'WhatsApp/Media/.Statuses',
        "label": 'oldwhatsapp',
        'title': 'WhatsApp'
      },
    },
    {
      'wp': {
        'path': 'Android/media/com.whatsapp/WhatsApp/Media/.Statuses',
        'label': 'newwhatsapp',
        'title': 'WhatsApp'
      }
    },
    {
      'wp': {
        'path': 'Android/WhatsApp Business/Media/.Statuses',
        'label': 'oldwhatsappbusiness',
        'title': 'WhatsApp Business'
      }
    },
    {
      'wp': {
        'path':
            'Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses',
        'label': 'newwhatsappbusiness',
        'title': 'WhatsApp Business'
      }
    },
    {
      'wp': {
        'path': 'GBWhatsApp/Media/.Statuses',
        'label': 'oldgbwhatsapp',
        'title': 'GB WhatsApp',
      }
    }
  ];

  static const foldersDock = {
    "reelx": 'Download/Reelx',
    "oldwhatsapp": 'WhatsApp/Media/.Statuses',
    'newwhatsapp': 'Android/media/com.whatsapp/WhatsApp/Media/.Statuses',
    'oldwhatsappbusiness': 'Android/WhatsApp Business/Media/.Statuses',
    'newwhatsappbusiness':
        'Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses',
    'oldgbwhatsapp': 'GBWhatsApp/Media/.Statuses',
  };

  Future<String> getRoot() async {
    var ext = await getExternalStorageDirectory();
    Directory? abs = ext?.absolute;
    String? root = abs?.path.split('Android')[0];
    return root!;
  }
}
