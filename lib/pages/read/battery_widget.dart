import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuedu/model/bookDetailModel.dart';
import 'package:yuedu/utils/tools.dart';

class BatteryWidget extends StatelessWidget {
  BatteryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenTools.getSize(62),
      height: ScreenTools.getSize(28),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(ScreenTools.getSize(4)),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(0xff333333), width: ScreenTools.getSize(4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: Provider.of<BookDetailModel>(context, listen: true)
                          .batteryLevel,
                      child: Container(
                        color: Color(0xff333333),
                      )),
                  Expanded(flex: 100-Provider.of<BookDetailModel>(context, listen: true)
                      .batteryLevel, child: Container())
                ],
              ),
            ),
          ),
          Container(
            width: ScreenTools.getSize(5),
            height: ScreenTools.getSize(16),
            color: Color(0xff333333),
          )
        ],
      ),
    );
  }
}
