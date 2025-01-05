import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelx/pages/home/cotroller/home_controller.dart';
import 'package:reelx/pages/home/widgets/tron_container.dart';

class Tron extends StatelessWidget {
  final HomeController hm;
  const Tron({
    required this.hm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.15,
      width: size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: context.theme.shadowColor,
        elevation: 10,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            child: tronContainer(hm)!,
            height: size.height * 0.1,
            width: size.width,
            color: Colors.transparent,
          ),
        ),
        color: context.theme.cardColor,
      ),
    );
  }
}
