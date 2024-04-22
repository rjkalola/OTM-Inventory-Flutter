import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/product_empty_view.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/product_list.dart';
import 'package:otm_inventory/pages/products/product_list/view/widgets/search_product.dart';

import '../../../../res/colors.dart';
import '../../../../res/drawable.dart';
import '../../../../widgets/CustomProgressbar.dart';
import '../../../../widgets/appbar/base_appbar.dart';
import '../controller/product_list_controller.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final productListController = Get.put(ProductListController());

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
          title: 'products'.tr,
          isBack: true,
          widgets: actionButtons()),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: productListController.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child: RefreshIndicator(
            onRefresh: () async {
              await productListController.getProductListApi(false,"0");
            },
            child: Column(children: [
              const Divider(
                thickness: 1,
                height: 1,
                color: dividerColor,
              ),
              SearchProductWidget(),
              productListController.productList.isNotEmpty
                  ? ProductListView()
                  : ProductListEmptyView(),
              const SizedBox(
                height: 12,
              ),
            ]),
          ),
        ),
      ),
    ));
  }

  List<Widget>? actionButtons() {
    return [
      // Visibility(
      //   visible: productListController.productList.isNotEmpty,
      //   child: IconButton(
      //     icon: SvgPicture.asset(
      //       width: 22,with exception
      //       Drawable.searchIcon,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      InkWell(onTap:(){
        print("tap qr code");
        productListController.openQrCodeScanner();
      },child: Text('qr_code'.tr,style: const TextStyle(fontSize: 16,color: defaultAccentColor,fontWeight: FontWeight.w500), )),
      IconButton(
        icon: SvgPicture.asset(
          width: 22,
          Drawable.filterIcon,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.add, size: 24,color: primaryTextColor),
        onPressed: () {
          productListController.addProductClick(null);
        },
      ),

    ];
  }
}