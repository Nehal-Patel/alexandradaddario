import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperset/database/db.dart';
import 'package:wallpaperset/model/model_favorite.dart';
import 'package:wallpaperset/model/model_wallpaper.dart';
import 'package:wallpaperset/utils/constant.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin{
  RxBool isPopularLoading = false.obs;
  RxBool isLatestLoading = false.obs;
  RxList arrOfWallpaper = <ModelWallpaper>[].obs;
  RxList arrOfPopular = <ModelWallpaper>[].obs;
  RxList arrOfLatest = <ModelWallpaper>[].obs;
  RxList arrOfFavorite = <ModelFavorite>[].obs;

  RxInt selectedIndex = 0.obs;

  late AdmobBannerSize bannerSize;

  late SqliteService sqliteService;
  final ScrollController allWallpaperScrollController = ScrollController();
  final ScrollController popularScrollController = ScrollController();
  final ScrollController latestScrollController = ScrollController();

  int currentPage = 1;
  int currentPopularPage = 1;
  int currentLatestPage = 1;

  RxBool isWallpaperLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  var pageController = PageController(viewportFraction: 1 / 5);
  var largePageController = PageController();

  RxInt selected = 0.obs;
  RxBool isFavorite = false.obs;


  RxBool hasNextWallpaper = false.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController=TabController(length: 4, vsync: this);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });

    sqliteService = SqliteService();

    Admob.requestTrackingAuthorization();
    bannerSize = AdmobBannerSize.BANNER;

    allWallpaperScrollController.addListener(() {
      if (allWallpaperScrollController.offset >=
          allWallpaperScrollController.position.maxScrollExtent &&
          !allWallpaperScrollController.position.outOfRange) {
        if (hasNextWallpaper.value) {
          getWallpaper();
        }
      }
    });

    popularScrollController.addListener(() {
      if (popularScrollController.offset >=
          popularScrollController.position.maxScrollExtent &&
          !popularScrollController.position.outOfRange) {
        getPopularByCategory();
      }
    });

    latestScrollController.addListener(() {
      if (latestScrollController.offset >=
          latestScrollController.position.maxScrollExtent &&
          !latestScrollController.position.outOfRange) {
        getLatestByCategory();
      }
    });

    getWallpaper();
    getPopularByCategory();
    getLatestByCategory();
    getFavorite();
  }

  Future<void> getWallpaper() async {
    currentPage=currentPage+1;
    if (currentPage == 1) {
      isWallpaperLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    http.Response response = await http.get(Uri.parse(GET_WALLPAPER +
        "categoryId=307" +
        "&page=" +
        currentPage.toString() +
        ""));

    debugPrint(GET_WALLPAPER +
        "categoryId=307" +
        "&page=" +
        currentPage.toString() +
        "");

    try{
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          arrOfWallpaper.addAll((responseData['wallpaper'] as List)
              .map(
                  (data) => ModelWallpaper.fromJson(data as Map<String, dynamic>))
              .toList());

          if (responseData['hasNext']) {
            hasNextWallpaper.value = true;
          } else {
            hasNextWallpaper.value = false;
          }

          debugPrint('Size Of Wallpaper: ' + arrOfWallpaper.length.toString());
        }

        isWallpaperLoading.value = false;
        isLoadingMore.value = false;
      } else {
        currentPage=currentPage-1;
        isWallpaperLoading.value = false;
        isLoadingMore.value = false;
        debugPrint('Request failed with status: ${response.statusCode}.');
      }
    }catch(e){
      currentPage=currentPage-1;
      isWallpaperLoading.value = false;
      isLoadingMore.value = false;
      debugPrint('Opps Something went wrong');
    }
  }

  Future<void> getPopularByCategory() async {
    currentPopularPage = currentPopularPage + 1;
    if (currentPopularPage == 1) {
      isPopularLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    http.Response response =
        await http.get(Uri.parse(GET_POPULAR + currentPopularPage.toString()));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 1) {
        arrOfPopular.addAll((responseData['wallpaper'] as List)
            .map(
                (data) => ModelWallpaper.fromJson(data as Map<String, dynamic>))
            .toList());

        if (responseData['hasNext']) {
          hasNextWallpaper.value = true;
        } else {
          hasNextWallpaper.value = false;
        }
      }

      isPopularLoading.value = false;
      isLoadingMore.value = false;
    } else {
      currentPopularPage = currentPopularPage -1;
      isPopularLoading.value = false;
      isLoadingMore.value = false;
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getLatestByCategory() async {
    currentLatestPage = currentLatestPage + 1;
    if (currentLatestPage == 1) {
      isLatestLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    http.Response response =
    await http.get(Uri.parse(GET_POPULAR + currentLatestPage.toString()));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 1) {
        arrOfLatest.addAll((responseData['wallpaper'] as List)
            .map(
                (data) => ModelWallpaper.fromJson(data as Map<String, dynamic>))
            .toList());

        if (responseData['hasNext']) {
          hasNextWallpaper.value = true;
        } else {
          hasNextWallpaper.value = false;
        }
      }

      isLatestLoading.value = false;
      isLoadingMore.value = false;
    } else {
      currentLatestPage = currentLatestPage - 1;
      isLatestLoading.value = false;
      isLoadingMore.value = false;
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> checkFavorite(int index,int type) async {
    selected.value = index;
    isFavorite.value = await sqliteService.isFavorite(type==1?
        arrOfWallpaper[selected.value].id.toString()
        : type==2?arrOfPopular[selected.value].id.toString():type==3?arrOfLatest[selected.value].id.toString():arrOfFavorite[selected.value].id.toString());
    debugPrint("IsFavorite = " + isFavorite.toString());
  }

  Future<void> updateFavorite(int index) async {
    isFavorite.value =
        await sqliteService.isFavorite(arrOfFavorite[index].id.toString());
  }

  Future<void> getFavorite() async {
    arrOfFavorite.value = await sqliteService.getAllFavorite();
    arrOfFavorite.toList().reversed;
  }
}
