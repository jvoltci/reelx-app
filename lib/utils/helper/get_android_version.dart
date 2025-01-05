import 'package:flutter/services.dart';
import 'package:reelx/utils/contstants/channel_constants.dart';

const platform = MethodChannel(ChannelConstants.DEFAULT_CHANNEl);
getAndroidVersion() async {
  var version = await platform.invokeMethod('androidVersion');
  return version;
}
