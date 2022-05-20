import 'package:flutter/material.dart';

const String GET_WALLPAPER="https://codinghouse.in/wallpaper/api/getWallpaper?";
const String GET_POPULAR="https://codinghouse.in/wallpaper/api/getPopularByCategory?categoryId=307&page=";
const String CATEGORY_ID="307";

int categoryClickCount=0;

int totalClickCount=0;
int countClick=2;
bool isReachToDownloadLimit=false;

String bannerId="ca-app-pub-7606304676433349/6751923606";
String interstitialId="ca-app-pub-7606304676433349/9179325133";

void showToast(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: new Text(text),
  ));
}