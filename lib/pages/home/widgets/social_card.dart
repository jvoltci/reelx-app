import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SocialCard extends StatelessWidget {
  final String asset;
  final String title;
  final String route;
  const SocialCard({
    required this.asset,
    required this.title,
    required this.route,
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
        color: context.theme.cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(route),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                asset,
                height: 70,
              ),
              Container(
                padding: const EdgeInsets.only(right: 50),
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.theme.textTheme.displayMedium?.color,
                    fontFamily: context.theme.textTheme.bodySmall?.fontFamily,
                    fontSize: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
