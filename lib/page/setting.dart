import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaperset/controller/home_controller.dart';
import 'package:wallpaperset/page/privacy_policy.dart';

class SettingTab extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting".toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("Share App"),
            onTap: () async {
              await FlutterShare.share(
                linkUrl:
                    'https://play.google.com/store/apps/details?id=com.kyliejenner.kyliejenner',
                text: 'Kylie Jenner HD Wallpaper',
                title: 'Download Now',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps_rounded),
            title: const Text("More App"),
            onTap: () async {
              String _url =
                  "https://play.google.com/store/apps/developer?id=Classic+Club";
              if (!await launch(_url)) throw 'Could not launch $_url';
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy Policy"),
            onTap: () {
              Get.to(const PrivacyPolicy());
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Exit"),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 1000), () {
                exit(0);
              });
              // Navigator.pop(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 40,
        child: AdmobBanner(
          adUnitId: "ca-app-pub-3940256099942544/6300978111",
          adSize: controller.bannerSize,
          listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
            // handleEvent(event, args, 'Banner');
          },
          onBannerCreated: (AdmobBannerController controller) {
            // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
            // Normally you don't need to worry about disposing this yourself, it's handled.
            // If you need direct access to dispose, this is your guy!
            // controller.dispose();
          },
        ),
      ),
    );
  }
  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
