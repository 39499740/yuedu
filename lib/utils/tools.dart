import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';

class ScreenTools {
  static double getScreenWidth() {
    return ScreenUtil.getInstance().screenWidth;
  }

  static double getScreenBottomBarHeight() {
    return ScreenUtil.getInstance().bottomBarHeight;
  }

  static double getSize(double inSize) {
    return ScreenUtil.getInstance().getAdapterSize(inSize);
  }

  static double getSizeAddSafeTop(double inSize) {
    return ScreenUtil.getInstance().getAdapterSize(inSize) +
        ScreenUtil.getInstance().statusBarHeight;
  }

  static double getStatusBarHeight() {
    return ScreenUtil.getInstance().statusBarHeight;
  }

  static double getAppBarHeight(){
    return ScreenUtil.getInstance().appBarHeight;
  }

  //获取比屏幕小XXX的宽度
  static double getWidthFromScreen(double width) {
    return ScreenUtil.getInstance().screenWidth -
        ScreenUtil.getInstance().getAdapterSize(width);
  }

  static double getScreenHeight() {
    return ScreenUtil.getInstance().screenHeight;
  }


}

class Utils {
  static dynamic deepCopy(dynamic old) {
    var str = JsonUtil.encodeObj(old);
    return json.decode(str!);
  }
}

class Network {
  static Dio dio = Dio(BaseOptions(
      // baseUrl: "http://192.168.0.43:33315/",
      // baseUrl: "http://127.0.0.1:33315/",
      // baseUrl: "http://192.144.135.34:33315/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: Headers.formUrlEncodedContentType));

  static post(String path, Map<String, dynamic> body) async {
    BotToast.showLoading();
    try {
      Response res = await dio.post(path, data: body);
      BotToast.closeAllLoading();
      return res;
    } on DioError catch (e) {
      print(e);
      BotToast.closeAllLoading();
      BotToast.showText(text: e.toString());
      return null;
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
    }
  }
}
