import 'package:flutter/services.dart';
import 'package:reelx/utils/contstants/channel_constants.dart';

MethodChannel platform = const MethodChannel(ChannelConstants.DEFAULT_CHANNEl);

sendFeedback() async {
  await platform.invokeMethod('feedback');
}
