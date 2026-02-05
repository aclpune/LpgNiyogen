import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';
import '../ClickModelClass/GetDashboardSettlementCtnListModel.dart';
import 'DashboardDropDownUI.dart';

class DashbobardPunchDetailUI extends StatefulWidget {

  GetDashboardNiyojanPunchCtnLstModel punchModel;


  DashbobardPunchDetailUI( this.punchModel,{super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardPunchDetailUIState();
  }
}
class _DashboardPunchDetailUIState extends State<DashbobardPunchDetailUI> {

  bool isTodaysNiyoganPunchedListViewVisible = false;
  final String? todayDate = DateTime.now().toString();
  late List<ConsumerDetails> punchModel = [];
  @override
  Widget build(BuildContext context) {
    var punchSale = widget.punchModel;
    punchModel = punchSale.consumerDetails!;
    return
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    punchSale.todayDate ?? '',
                    style: Styling.itemBlackTestVerySmall,
                    textAlign: TextAlign.start,
                   // maxLines: 1,
                  ),
                ),
                verticalDividerVerySmallWidth(),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          punchSale.staffName ?? '',
                          style: Styling.itemBlackTestVerySmall,
                          overflow: TextOverflow.ellipsis, // Handles overflow gracefully
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isTodaysNiyoganPunchedListViewVisible =
                            !isTodaysNiyoganPunchedListViewVisible;
                          });
                        },
                        child: Icon(
                          isTodaysNiyoganPunchedListViewVisible
                              ? Icons.arrow_drop_up // Show "up" arrow when the list is visible
                              : Icons.arrow_drop_down,  // Show "down" arrow when the list is hidden
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),

                ),
                verticalDividerVerySmallWidth(),
                Expanded(
                  flex: 2,
                  child: Text(
                    punchSale.niyojanPunQty.toString(),
                    style: Styling.itemBlackTestVerySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                verticalDividerVerySmallWidth(),
                Expanded(
                  flex: 2,
                  child: Text(
                    punchSale.settlementQty.toString(),
                    style: Styling.itemBlackTestVerySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                verticalDividerVerySmallWidth(),
                Expanded(
                  flex: 2,
                  child: Text(
                    punchSale.pendingSttlQty.toString(),
                    style: Styling.itemBlackTestVerySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Divider(),
            Visibility(
              visible: isTodaysNiyoganPunchedListViewVisible,
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                       // padding: EdgeInsets.all(2.0),
                        child: ListView.builder(
                          // itemCount: punchSale.consumerDetails?.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: punchModel.length,
                          itemBuilder: (context, index) {
                            return DashboardDropDownUI(
                              punchModel[index],index + 1,
                                //, punchModel.length
                                punchModel.length
                            );
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  ),

                ),
              ),
            ),
          ],
        );
  }
}
