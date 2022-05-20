import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wallpaperset/controller/home_controller.dart';
import 'package:wallpaperset/page/favorite_details.dart';
import 'package:wallpaperset/page/latest_details.dart';
import 'package:wallpaperset/page/popular_details.dart';
import 'package:wallpaperset/page/setting.dart';
import 'package:wallpaperset/page/wallpaper_details.dart';
import 'package:wallpaperset/tab/all_tab.dart';
import 'package:wallpaperset/tab/favorite_tab.dart';
import 'package:wallpaperset/tab/latest_tab.dart';
import 'package:wallpaperset/tab/popular_tab.dart';
import 'package:wallpaperset/utils/constant.dart';

class Home extends GetView<HomeController> {
  late AdmobInterstitial interstitialAd;
  bool isAdsLaded = false;
  int currentIndex = 0;

  List<String> filterList = ['All', 'Popular', 'Latest', 'Favorite'];

  Home() {
    loadAds();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Kylie Jenner".toUpperCase(),
          style: TextStyle(
              letterSpacing: 2,
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: IconButton(
              onPressed: () {
                Get.to(SettingTab());
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              // color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: filterList.length,
              itemBuilder: (context, index) {
                return Obx(() => InkWell(
                      onTap: () {
                        controller.selectedIndex.value = index;
                        controller.tabController.index=index;
                        if (index == filterList.length - 1) {
                          controller.getFavorite();
                        }
                      },
                      child: Container(
                        constraints:
                            BoxConstraints(minWidth: 80, minHeight: 55),
                        margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                        decoration: BoxDecoration(
                          border: controller.selectedIndex.value == index
                              ? Border.all(
                                  color: Colors.grey.withOpacity(0.50),
                                  width: 1,
                                )
                              : Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Center(
                          child: Text(
                            filterList[index].toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 2.0,
                              color: controller.selectedIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
          Expanded(
              child: TabBarView(
                  controller: controller.tabController,
                  children: [
                AllTab(),
                PopularTab(),
                LatestTab(),
                FavoriteTab()
              ]))
        ],
      ),

    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        isAdsLaded = true;
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.failedToLoad:
        isAdsLaded = false;
        break;
      case AdmobAdEvent.rewarded:
        break;
      default:
    }
  }

  Future<void> loadAds() async {
    await Admob.requestTrackingAuthorization();

    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }
}
