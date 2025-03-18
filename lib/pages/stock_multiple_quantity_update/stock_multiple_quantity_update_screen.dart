import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/stock_multiple_quantity_update_controller.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/widgets/search_stock.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/widgets/stock_empty_view.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/widgets/stock_list.dart';
import 'package:otm_inventory/pages/stock_multiple_quantity_update/widgets/stock_qty_store_buttons.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../widgets/appbar/base_appbar.dart';

class StockMultipleQuantityUpdateScreen extends StatefulWidget {
  const StockMultipleQuantityUpdateScreen({super.key});

  @override
  State<StockMultipleQuantityUpdateScreen> createState() =>
      _StockListScreenState();
}

class _StockListScreenState extends State<StockMultipleQuantityUpdateScreen> {
  final stockListController = Get.put(StockMultipleQuantityUpdateController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
          child: Obx(() => Scaffold(
                backgroundColor: backgroundColor,
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: 'add_stock'.tr,
                  isCenterTitle: false,
                  isBack: true,
                ),
                body: ModalProgressHUD(
                  inAsyncCall: stockListController.isLoading.value,
                  opacity: 0,
                  progressIndicator: const CustomProgressbar(),
                  child: Column(children: [
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: dividerColor,
                    ),
                    // const SizedBox(height:20,),
                    // TextFieldSelectStore(),
                    const SearchStockMultipleQuantityUpdateWidget(),
                    stockListController.productList.isNotEmpty
                        ? StockMultipleQuantityUpdateListView()
                        : StockMultipleQuantityUpdateEmptyView(),
                    Visibility(
                      visible: stockListController.isLoadMore.value,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator()),
                            const SizedBox(
                              width: 14,
                            ),
                            Text(
                              'loading_more_'.tr,
                              style: const TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ),
                    StockQtyStoreButtons()
                  ]),
                ),
              ))),
    );
  }
}
