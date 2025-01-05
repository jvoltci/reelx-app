import 'package:flutter/material.dart';

class TabHead extends StatelessWidget {
  final whatsappTabController;
  const TabHead({required this.whatsappTabController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: const EdgeInsets.only(bottom: 10),
      controller: whatsappTabController,
      indicatorColor: const Color(0xff4dcb5b),
      labelColor: const Color(0xff4dcb5b),
      unselectedLabelColor: Theme.of(context).textTheme.headlineMedium?.color,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
      isScrollable: false,
      unselectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
      tabs: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.photo_library),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('IMAGES'),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.live_tv),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('VIDEOS'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
