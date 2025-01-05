import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reelx/pages/about/controller/about_controller.dart';
import 'package:reelx/widgets/gradient_text.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final a = Get.put(AboutController());
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_left),
                    iconSize: 60,
                    color: context.textTheme.displaySmall?.color,
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/images/logo_reelx.svg',
                height: size.height * 0.40,
              ),
              Center(
                child: Text(
                  "About",
                  style: TextStyle(
                    fontSize: 40,
                    color: context.textTheme.displayMedium?.color,
                    fontFamily: context.theme.textTheme.bodySmall?.fontFamily,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: size.height * 0.1),
                child: Divider(
                  color: context.theme.indicatorColor,
                  thickness: 2,
                  indent: size.width * 0.3,
                  endIndent: size.width * 0.3,
                ),
              ),
              SizedBox(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "App Version",
                      style: TextStyle(
                        fontSize: 20,
                        color: context.textTheme.displayMedium?.color,
                      ),
                    ),
                    Text(
                      "1.4.0",
                      style: TextStyle(
                        fontSize: 20,
                        color: context.textTheme.displayMedium?.color,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Developed By",
                      style: TextStyle(
                        fontSize: 20,
                        color: context.textTheme.displayMedium?.color,
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GradientText(
                          "JAI &",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.redAccent,
                              Colors.purple,
                            ],
                          ),
                        ),
                        GradientText(
                          "RAHUL",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.redAccent,
                              Colors.purple,
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: size.height * 0.0001,
        child: AdWidget(ad: a.aboutBottomBannerAd),
      ),
    );
  }
}
