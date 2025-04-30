import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/image_preview/controller/image_preview_controller.dart';
import 'package:otm_inventory/pages/image_preview/view/widgets/horizontal_list_view.dart';
import 'package:otm_inventory/pages/image_preview/view/widgets/pager_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

class ImagePreviewScreen extends StatefulWidget {
  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final controller = Get.put(ImagePreviewController());

  void _onThumbnailTap(int index) {
    controller.pageController.value.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "",
            isCenterTitle: false,
            isBack: true,
          ),
          body: Column(
            children: [
              const Divider(
                color: dividerColor,
              ),
              PagerView(),
              HorizontalListView(),
            ],
          ),
        ),
      ),
    );
  }
}
