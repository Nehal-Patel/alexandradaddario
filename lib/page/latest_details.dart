
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:pinch_zoom/pinch_zoom.dart';

import 'package:wallpaperset/controller/home_controller.dart';
import 'package:wallpaperset/controller/wallpaper_controller.dart';
import 'package:wallpaperset/utils/constant.dart';

class LatestDetails extends GetView<HomeController> {
  late AdmobInterstitial interstitialAd;

  // late AdmobReward rewardAd;
  bool isAdsLaded = false;
  int currentIndex = 0;
  late BuildContext context;

  WallpaperController wallpaperController = Get.find();

  LatestDetails() {
    loadAds();
    controller.checkFavorite(controller.selected.value,3);
    Future.delayed(Duration(seconds: 2), () {
      controller.pageController.animateToPage(controller.selected.value,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized);
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => Column(
        children: [
          Expanded(child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                PinchZoom(
                  resetDuration: const Duration(seconds: 3),
                  child: CachedNetworkImage(
                    imageUrl: controller
                        .arrOfLatest[controller.selected.value].image,
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    placeholder: (context, url) =>
                        Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            color:
                            Colors.grey.withOpacity(0.20),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            color:
                            Colors.grey.withOpacity(0.20),
                          ),
                        ),
                  ),
                  // Image.network(controller
                  //     .arrOfLatest[controller.selected.value].image,
                  //   height: double.maxFinite,
                  //   width: double.maxFinite,
                  //   fit: BoxFit.contain,
                  // ),
                ),
                Container(
                  // color: Colors.green,
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(left: 8, top: 40),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        padding: EdgeInsets.all(2),
                        // color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),

            child: SizedBox(
              height: 65,
              // width: 400,
              child: PageView.builder(
                // pageSnapping: true,
                  controller: controller.pageController,
                  itemCount: controller.arrOfLatest.length,
                  onPageChanged: (index) {
                    controller.selected.value = index;
                    controller.checkFavorite(index,3);
                  },
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
                              controller.selected.value = index;
                              controller.checkFavorite(index,3);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      width: controller.selected.value ==
                                          index
                                          ? 3
                                          : 0)),
                              margin: const EdgeInsets.only(right: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl:  controller.arrOfLatest[index]
                                      .image,
                                  height: 60,
                                  width: 55,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                  const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4),child: AdmobBanner(
            adUnitId: bannerId,
            adSize: controller.bannerSize,
            listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
              // handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController controller) {},
          ),)
        ],
      )
      ),
      bottomNavigationBar:

      Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Obx(()=>Row(
          children: [

            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(left: 16,right: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: IconButton(
                  onPressed: () async {
                    if (!controller.isFavorite.value) {
                      int id = await controller.sqliteService
                          .addToFavorite(controller.arrOfLatest[
                      controller.selected.value]);
                      controller
                          .checkFavorite(controller.selected.value,3);
                    } else {
                      controller.sqliteService.removeFromFavorite(controller
                          .arrOfLatest[
                      controller.selected.value]
                          .id
                          .toString());
                      controller
                          .checkFavorite(controller.selected.value,3);
                    }
                  },
                  icon: Icon(
                    controller.isFavorite.value
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: controller.isFavorite.value
                        ? Colors.red
                        : Colors.grey,
                  ),
                  padding: EdgeInsets.all(2),
                  // color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: IconButton(
                  onPressed: () {
                    if (totalClickCount == countClick) {
                      // showRewardDialog(context);
                      if (isAdsLaded) {
                        interstitialAd.show();
                      } else {
                        totalClickCount = 0;
                        interstitialAd.load();
                      }
                    } else {
                      if (!wallpaperController
                          .isDownloading.value) {
                        wallpaperController.downloadWallpaper(
                            context,controller
                            .arrOfLatest[
                        controller.selected.value]
                            .image);
                      }
                    }
                  },
                  icon: wallpaperController.isDownloading.value
                      ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 1,
                      ),
                    ),
                  )
                      : Icon(Icons.download),

                  padding: EdgeInsets.all(2),
                  // color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: IconButton(
                  onPressed: () async {
                    if (totalClickCount == countClick) {
                      // showRewardDialog(context);
                      if (isAdsLaded) {
                        interstitialAd.show();
                      } else {
                        totalClickCount = 0;
                        interstitialAd.load();
                      }
                    } else {
                      if (!wallpaperController
                          .isShareLoading.value) {
                        wallpaperController.shareWallpaper(controller
                            .arrOfLatest[
                        controller.selected.value]
                            .image);
                      }
                    }
                  },
                  icon: wallpaperController.isShareLoading.value
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 1,
                    ),
                  )
                      : Icon(
                    Icons.share,
                  ),

                  padding: EdgeInsets.all(2),
                  // color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (totalClickCount == countClick) {
                    // showRewardDialog(context);
                    if (isAdsLaded) {
                      interstitialAd.show();
                    } else {
                      totalClickCount = 0;
                      interstitialAd.load();
                    }
                  } else {
                    if (!wallpaperController.isSetWallpaper.value) {
                      wallpaperController.setWallpaper(controller
                          .arrOfLatest[
                      controller.selected.value]
                          .image);
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(right: 16),
                  height: 50,
                  child: wallpaperController.isSetWallpaper.value
                      ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 1,
                      ),
                    ),
                  )
                      : Center(
                    child: Text(
                      "APPLY",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      )
    );
  }

  Future<void> loadAds() async {
    await Admob.requestTrackingAuthorization();

    interstitialAd = AdmobInterstitial(
      adUnitId: interstitialId,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();

    // rewardAd = AdmobReward(
    //   adUnitId: rewardId,
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) rewardAd.load();
    //     handleEvent(event, args, 'Reward');
    //   },
    // );

    // rewardAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        isAdsLaded = true;
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.closed:
        totalClickCount = 0;
        isAdsLaded = true;
        break;
      case AdmobAdEvent.failedToLoad:
        isAdsLaded = false;
        break;
      case AdmobAdEvent.rewarded:
        // showToast(context, "Download Unlock");

        // rewardAd.load();
        break;
      default:
    }
  }

  void showRewardDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Unlock Download",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          content: Text(
              "You have reach to your download limit,please watch video to unlock more hd wallpaper"),
          actions: [
            TextButton(
              child: Text("Unlock".toUpperCase()),
              onPressed: () async {
                //   if (await rewardAd.isLoaded) {
                //     Navigator.of(context).pop();
                //     rewardAd.show();
                //   } else {
                //     Navigator.of(context).pop();
                //     rewardAd.load();
                //   }
              },
            ),
            TextButton(
              child: Text("Cancel".toUpperCase()),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
