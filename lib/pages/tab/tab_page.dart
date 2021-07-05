import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/pages/bookshelf/book_shelf_page.dart';
import 'package:yuedu/pages/search/search_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yuedu/utils/tools.dart';

class TabPage extends StatefulWidget {
  TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;
  List<Widget> _pageList = [
    BookShelfPage(),
    SearchPage(),
    BookShelfPage(),
  ];
  late Timer _updateTotalDataTimer;

  late ProgressDialog pd;

  @override
  void initState() {
    super.initState();

    _updateTotalDataTimer =
        new Timer.periodic(new Duration(seconds: 1), (timer) {
      // Provider.of<BookDetailModel>(context, listen: false).updateTotalData();
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      checkVersion();
    });
  }

  Future<void> checkVersion() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      String buildNumber = packageInfo.buildNumber;
      Response res = await Network.get("newVersion");
      if (Platform.isAndroid) {
        if (int.parse(res.data["data"]["sys_version"]) >
            int.parse(buildNumber)) {
          Alert(
              context: context,
              title: "新版本",
              content: Container(
                child: Text(res.data["data"]["sys_context"]),
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    Navigator.pop(context);
                    downloadApk(res.data["data"]["sys_url"]);
                  },
                  child: Text(
                    "更新",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                DialogButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "取消",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        }
      }
    });
  }

  Future<void> downloadApk(String url) async {
    var dio = new Dio();
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'File Downloading...');
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    await dio.download(url, tempPath + "/install.apk",
        onReceiveProgress: (rec, total) {
      int progress = (((rec / total) * 100).toInt());
      pd.update(value: progress, msg: "正在下载……");
    });
    OpenFile.open(tempPath + "/install.apk");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.amp_stories), label: "书架"),
          BottomNavigationBarItem(icon: Icon(Icons.wb_cloudy), label: "搜书"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "我的")
        ],
      ),
    );
  }

  @override
  void dispose() {
    _updateTotalDataTimer.cancel();
    super.dispose();
  }
}
