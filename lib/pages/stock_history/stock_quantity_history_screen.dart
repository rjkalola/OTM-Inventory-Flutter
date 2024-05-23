import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/stock_history/stock_quantity_history_controller.dart';
import 'package:otm_inventory/pages/stock_history/widgets/qty_history_list_view.dart';
import 'package:otm_inventory/pages/stock_history/widgets/stock_histoty_filter_widget.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../res/colors.dart';
import '../../widgets/CustomProgressbar.dart';
import '../../widgets/appbar/base_appbar.dart';

class StockQuantityHistoryScreen extends StatefulWidget {
  const StockQuantityHistoryScreen({
    super.key,
  });

  @override
  State<StockQuantityHistoryScreen> createState() =>
      _StockQuantityHistoryScreenState();
}

class _StockQuantityHistoryScreenState
    extends State<StockQuantityHistoryScreen> {
  final stockQuantityHistoryController =
      Get.put(StockQuantityHistoryController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Obx(() => SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'stock_movement'.tr,
              isCenterTitle: false,
              isBack: true,
              widgets: actionButtons(),
            ),
            body: ModalProgressHUD(
              inAsyncCall: stockQuantityHistoryController.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: Visibility(
                visible: stockQuantityHistoryController.isMainViewVisible.value,
                child: Column(children: [
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: dividerColor,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  StockHistoryFilterWidget(),
                  QtyHistoryListView()
                ]),
              ),
            ),
          ),
        ));
  }

  Widget customTextView(String? text, double fontSize, FontWeight? fontWeight,
          Color color, EdgeInsetsGeometry padding) =>
      Visibility(
        visible: !StringHelper.isEmptyString(text),
        child: Flexible(
          child: Padding(
            padding: padding,
            child: Text(text ?? "",
                softWrap: true,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: color,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                )),
          ),
        ),
      );

  Widget dividerItem() => const Divider(
        thickness: 0.5,
        height: 0.5,
        color: dividerColor,
      );

  List<Widget>? actionButtons() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Text(
          stockQuantityHistoryController.totalQuantity.value,
          style: const TextStyle(
              fontSize: 18,
              color: defaultAccentColor,
              fontWeight: FontWeight.w600),
        ),
      ),
    ];
  }
}
