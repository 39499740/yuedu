import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/pages/read/battery_widget.dart';
import 'package:yuedu/utils/tools.dart';
import 'package:yuedu/widget/pageWidget.dart';

class ReadPage extends StatefulWidget {
  ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenTools.getSize(28)),
              alignment: Alignment.centerLeft,
              height: ScreenTools.getSize(106),
              width: double.infinity,
              child: Text(
                Provider.of<BookDetailModel>(context, listen: true)
                            .nowCatalogueIndex ==
                        null
                    ? ""
                    : Provider.of<BookDetailModel>(context, listen: true)
                        .openBookCatalogue[
                            Provider.of<BookDetailModel>(context, listen: true)
                                .nowCatalogueIndex!]
                        .title,
                style: TextStyle(
                    fontSize: ScreenTools.getSize(47),
                    fontWeight: FontWeight.w200),
              ),
            ),
            Expanded(
                child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenTools.getSize(45)),
              child: PageWidget(),
            )),
            Container(
              height: ScreenTools.getSize(99),
              width: double.infinity,
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenTools.getSize(28)),
              child: Row(
                children: [
                  Container(
                    child: Row(
                      children: [Container(child: BatteryWidget())],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
