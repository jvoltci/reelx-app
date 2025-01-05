import 'package:flutter/services.dart';
import 'package:reelx/utils/contstants/channel_constants.dart';
import 'package:reelx/utils/contstants/path_constants.dart';
import 'package:saf/saf.dart';

const platform = MethodChannel(ChannelConstants.DEFAULT_CHANNEl);

Future<bool> getSafPermission(dirLabel) async {
  Saf saf = Saf(PathConstants.foldersDock[dirLabel] as String);
  var isAllowed = await saf.getDirectoryPermission();
  if (isAllowed != null && isAllowed) {
    return true;
  } else {
    return false;
  }
}
