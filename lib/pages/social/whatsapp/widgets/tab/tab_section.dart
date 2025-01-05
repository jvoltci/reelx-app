import 'package:flutter/cupertino.dart';
import 'package:reelx/pages/social/whatsapp/widgets/tab/tab_body.dart';
import 'package:reelx/pages/social/whatsapp/widgets/tab/tab_head.dart';

List<Widget> tabSection(_whatsappTabController) {
  List<Widget> list = [
    TabHead(whatsappTabController: _whatsappTabController),
    TabBody(whatsappTabController: _whatsappTabController),
  ];
  return list;
}
