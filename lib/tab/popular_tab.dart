import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaperset/controller/home_controller.dart';
import 'package:wallpaperset/page/popular_details.dart';
import 'package:wallpaperset/utils/constant.dart';

class PopularTab extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: RefreshIndicator(
      onRefresh: () async {
        controller.currentPopularPage = 0;
        controller.getPopularByCategory();
        await Future.delayed(Duration(milliseconds: 1500));
      },
      child:NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if(!controller.isLoadingMore.value)
              controller.getPopularByCategory();
              return true;
            }
            return false;
          },
          child: Obx(()=>Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              shrinkWrap: true,
              children: [
                MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: controller.isPopularLoading.value
                        ? Container(
                      color: Colors.white,
                      height: Get.height * 0.80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1 / 1.5,
                      children: List.generate(
                          controller.arrOfPopular.length, (index) {
                        return Container(
                          // color: Colors.black,
                          child: Stack(
                            children: [
                              InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: controller
                                        .arrOfPopular[index].image,
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
                                ),
                                onTap: () {
                                  controller.selected.value = index;
                                  controller.checkFavorite(index, 2);
                                  Get.to(PopularDetails());
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    )),
                controller.isLoadingMore.value
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 1,
                    ),
                  ),
                )
                    : SizedBox.shrink()
              ],
            ),
          )))
    ),
      bottomNavigationBar: AdmobBanner(
        adUnitId: bannerId,
        adSize: controller.bannerSize,
        listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
          // handleEvent(event, args, 'Banner');
        },
        onBannerCreated: (AdmobBannerController controller) {},
      ),
    );
  }
}
