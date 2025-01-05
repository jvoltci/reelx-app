import 'package:flutter/services.dart';
import 'package:reelx/utils/contstants/channel_constants.dart';
import 'package:reelx/utils/contstants/path_constants.dart';
import 'package:saf/saf.dart';

const platform = MethodChannel(ChannelConstants.DEFAULT_CHANNEl);

syncWhatsApp(String dirLabel) async {
  await Saf.syncWith(PathConstants.foldersDock[dirLabel] as String);
}
