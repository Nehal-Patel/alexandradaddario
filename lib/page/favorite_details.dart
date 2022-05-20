import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pinch_zoom/pinch_zoom.dart';

import 'package:wallpaperset/controller/home_controller.dart';
import 'package:wallpaperset/controller/wallpaper_controller.dart';
import 'package:wallpaperset/utils/constant.dart';

class FavoriteDetails extends GetView<HomeController> {
  late AdmobInterstitial interstitialAd;
  late AdmobReward rewardAd;
  bool isAdsLaded = false;
  late BuildContext context;

  WallpaperController wallpaperController = Get.find();

  FavoriteDetails() {
    loadAds();
    controller.updateFavorite(controller.selected.value);
    Future.delayed(Duration(seconds: 2), () {
      controller.pageController.animateToPage(controller.selected.value,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => controller.arrOfFavorite.isEmpty
          ? Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            const Center(
              child: Text(
                "No Favorite Wallpaper Found",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              // color: Colors.green,
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(left: 16, top: 50),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: IconButton(
                    onPressed: () {
                      controller.getFavorite();
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
      )
          : Stack(
        fit: StackFit.expand,
        children: [
          PinchZoom(
            resetDuration: const Duration(seconds: 5),
            child:  CachedNetworkImage(
              imageUrl: controller
                  .arrOfFavorite[controller.selected.value].image,
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
            // Image.network(
            //   controller.arrOfFavorite[controller.selected.value].image,
            //   height: double.maxFinite,
            //   width: double.maxFinite,
            //   fit: BoxFit.contain,
            // ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        child: IconButton(
                          onPressed: () async {
                            await controller.sqliteService
                                .removeFromFavorite(controller
                                .arrOfFavorite[
                            controller.selected.value]
                                .id
                                .toString());
                            controller.updateFavorite(
                                controller.selected.value);

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
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
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
                                    context,
                                    controller
                                        .arrOfFavorite[
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
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
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
                                wallpaperController.shareWallpaper(
                                    controller
                                        .arrOfFavorite[
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
                  ),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16, right: 16),
                        height: 50,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {},
                            child: Center(
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
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
                                      if (!wallpaperController
                                          .isSetWallpaper.value) {
                                        wallpaperController.setWallpaper(
                                            controller
                                                .arrOfFavorite[
                                            controller.selected.value]
                                                .image);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                    child: wallpaperController
                                        .isSetWallpaper.value
                                        ? Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                        CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                    )
                                        : Text(
                                      "APPLY",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              margin: EdgeInsets.only(bottom: 80),
              child: SizedBox(
                height: 65,
                // width: 400,
                child: PageView.builder(
                  // pageSnapping: true,
                    controller: controller.pageController,
                    itemCount: controller.arrOfFavorite.length,
                    onPageChanged: (index) {
                      controller.selected.value = index;
                      controller.updateFavorite(index);
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          controller.selected.value = index;
                          controller.updateFavorite(index);
                          controller.pageController.animateToPage(
                              controller.selected.value,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color: Colors.white,
                                  width:
                                  controller.selected.value == index
                                      ? 3
                                      : 0)),
                          margin: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child:CachedNetworkImage(
                              imageUrl: controller
                                  .arrOfFavorite[index].image,
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

                            // Image.network(
                            //   controller.arrOfFavorite[index].thumbnail,
                            //   height: 65,
                            //   width: 40,
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Container(
            // color: Colors.green,
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(left: 16, top: 50),
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
          ),
        ],
      )),
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

  Future<void> getFavorite() async {
    controller.arrOfFavorite = await controller.sqliteService.getAllFavorite();
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
        isAdsLaded = true;
        break;
      case AdmobAdEvent.failedToLoad:
        isAdsLaded = false;
        break;
      case AdmobAdEvent.rewarded:
        showToast(context, "Download Unlock");
        totalClickCount = 0;
        rewardAd.load();
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
                if (await rewardAd.isLoaded) {
                  Navigator.of(context).pop();
                  rewardAd.show();
                } else {
                  Navigator.of(context).pop();
                  rewardAd.load();
                }
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
