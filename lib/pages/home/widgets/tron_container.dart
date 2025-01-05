import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget? tronContainer(h) {
  if (h.tron.value) {
    switch (h.tronType.value) {
      case "text":
        return GestureDetector(
          onTap: () => launchUrl(h.tronMeta["link"]!),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Color(
              int.parse("0xff${h.tronMeta["bgColor"]}"),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  h.tronMeta["text"]!,
                  style: TextStyle(
                    color: Color(
                      int.parse("0xff${h.tronMeta["color"]}"),
                    ),
                    fontSize: h.tronMeta["fontSize"] + 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      case "image":
        return GestureDetector(
          onTap: () => launchUrl(h.tronMeta["link"]!),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Color(int.parse("0xff${h.tronMeta["bgColor"]}")),
            child: Image.network(
              h.tronMeta["imageUrl"]!,
              fit: BoxFit.fill,
            ),
          ),
        );
      default:
        break;
    }
  }
  return const SizedBox();
}
