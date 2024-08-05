import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/barcode_list/controller/barcode_list_controller.dart';
import 'package:otm_inventory/pages/barcode_list/view/widgets/barcode_list_empty_view.dart';
import 'package:otm_inventory/pages/barcode_list/view/widgets/barcode_list_view.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../dashboard/widgets/main_drawer.dart';

class BarcodeListScreen extends StatefulWidget {
  const BarcodeListScreen({super.key});

  @override
  State<BarcodeListScreen> createState() => _BarcodeListScreenState();
}

class _BarcodeListScreenState extends State<BarcodeListScreen> {
  final controller = Get.put(BarcodeListController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: BaseAppBar(
          appBar: AppBar(),
          title: 'manage_barcode'.tr,
          isBack: true,
          widgets: actionButtons()),
      // drawer: MainDrawer(),
      // bottomNavigationBar: const CommonBottomNavigationBarWidget(),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child: Column(children: [
            const Divider(
              thickness: 1,
              height: 1,
              color: dividerColor,
            ),
            const SizedBox(
              height: 9,
            ),
            controller.barcodeList.isNotEmpty
                ? BarcodeListView()
                : BarcodeListEmptyView(),
            const SizedBox(
              height: 12,
            ),
          ]),
        ),
      ),
    ));
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: true,
        child: IconButton(
          icon: const Icon(Icons.add, size: 24, color: primaryTextColor),
          onPressed: () {
            controller.showEditBarcodeDialog("123", true, 0);
          },
        ),
      ),
    ];
  }
}
