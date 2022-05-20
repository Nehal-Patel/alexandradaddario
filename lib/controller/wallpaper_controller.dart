import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaperset/utils/constant.dart';

class WallpaperController extends GetxController{

  RxBool isDownloading = false.obs;
  RxBool isShareLoading = false.obs;
  RxBool isSetWallpaper = false.obs;

  static const platform = MethodChannel('wallpaper');

  Future<void> setWallpaper(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      isSetWallpaper.value = true;

      var response = await Dio().get(url,
          options: Options(responseType: ResponseType.bytes));

      final temp = await getTemporaryDirectory();
      String file = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      String path = '${temp.path}/$file';
      File(path).writeAsBytesSync(Uint8List.fromList(response.data));

      isSetWallpaper.value = false;

      try {
        final int result =
        await platform.invokeMethod('setWallpaper', {"url": path});
        debugPrint(result.toString());
        totalClickCount = totalClickCount + 1;
        if (totalClickCount == 5) {
          isReachToDownloadLimit = true;
        }
      } on PlatformException catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> shareWallpaper(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      isShareLoading.value = true;

      var response = await Dio().get(
          url,
          options: Options(responseType: ResponseType.bytes));

      final temp = await getTemporaryDirectory();
      String path = '${temp.path}/image1.jpg';
      File(path).writeAsBytesSync(Uint8List.fromList(response.data));

      isShareLoading.value = false;

      totalClickCount = totalClickCount + 1;
      if (totalClickCount == 5) {
        isReachToDownloadLimit = true;
      }

      await FlutterShare.shareFile(
        title: 'Bollywood Actress Wallpaper',
        text: 'Download App Now',
        filePath: path,
      );
    }
  }

  Future<void> downloadWallpaper(BuildContext context,String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      isDownloading.value = true;

      var response = await Dio().get(
          url,
          options: Options(responseType: ResponseType.bytes));

      var filename=DateTime.now().millisecondsSinceEpoch.toString();
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: filename);
      if (result['isSuccess']) {
        showToast(context, "Downlode Successfully");
        totalClickCount = totalClickCount + 1;
        if (totalClickCount == 5) {
          isReachToDownloadLimit = true;
        }
      } else {
        showToast(context, "Please Try Aagin");
      }

      isDownloading.value = false;
    }
  }

}