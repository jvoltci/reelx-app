import 'package:flutter/material.dart';
import 'package:reelx/controller/main_controller.dart';
import 'package:reelx/widgets/gradient_text.dart';
import 'package:get/get.dart';

class AppBarSection extends StatelessWidget {
  const AppBarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.22,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: context.theme.colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: context.theme.appBarTheme.shadowColor!,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Center(
                    child: GradientText(
                      'Reelx',
                      style: TextStyle(
                        fontFamily:
                            context.theme.textTheme.bodySmall?.fontFamily,
                        fontSize: 50,
                        color: context.theme.textTheme.displayLarge?.color,
                      ),
                      gradient: const LinearGradient(colors: [
                        Colors.blue,
                        Colors.amberAccent,
                        Colors.redAccent,
                        Colors.purple,
                        Colors.white,
                      ]),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Center(
                    child: Text(
                      'Total Download so far...',
                      style: TextStyle(
                        fontFamily:
                            context.theme.textTheme.bodySmall?.fontFamily,
                        fontSize: 25,
                        color: context.theme.textTheme.displayLarge?.color,
                      ),
                    ),
                  ),
                  Center(
                      child: Obx(
                    () => Text(
                      mainController.downloadHit.value.toString(),
                      style: TextStyle(
                        fontFamily:
                            context.theme.textTheme.bodySmall?.fontFamily,
                        fontSize: 45,
                        color: context.theme.textTheme.displayLarge?.color,
                      ),
                    ),
                  ))
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 3,
          left: 3,
          child: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(
              Icons.menu,
              size: 40,
              color: context.theme.textTheme.displayLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
