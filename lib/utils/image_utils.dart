import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../pages/common/widgets/image_preview_dialog.dart';

class ImageUtils {
  static String defaultUserAvtarUrl =
      "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png";

  static Widget setUserImage(String url, double width, double height,
      double radius) {
    return !StringHelper.isEmptyString(url)
        ? ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: width,
        height: height,
        // errorBuilder: (context, url, error) => Image.network(
        //   defaultUserAvtarUrl,
        //   fit: BoxFit.scaleDown,
        //   height: size,
        //   width: size,
        // ),
        errorBuilder: (context, url, error) =>
            defaultUserImage(width, height),
      ),
    )
    // : Image.network(
    //     defaultUserAvtarUrl,
    //     fit: BoxFit.scaleDown,
    //     height: size,
    //     width: size,
    //   );
        : defaultUserImage(width, height);
  }

  static Widget defaultUserImage(double width, double height) {
    return SvgPicture.asset(
      width: width,
      height: height,
      Drawable.accountCircleIcon,
      colorFilter:
      const ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
    );
  }

  static Widget setImage(String url, double size) {
    return !StringHelper.isEmptyString(url)
        ? Image.network(
      url,
      fit: BoxFit.cover,
      width: size,
      height: size,
      errorBuilder: (context, url, error) =>
          Icon(Icons.photo_outlined, size: size),
    )
        : Icon(Icons.photo_outlined, size: size);
  }

  static showImagePreviewDialog(String? url) {
    if (!StringHelper.isEmptyString(url)) {
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ImagePreviewDialog(
            imageUrl: url ?? "",
          );
        },
      );
    }
  }

  static Widget setAssetsImage(
      {required String path,
        required double width,
        required double height,
        BoxFit? fit,
        Color? color}) {
    return !StringHelper.isEmptyString(path)
        ? SvgPicture.asset(
      path,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      colorFilter:
      color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    )
        : Icon(Icons.photo_outlined, size: getEmptyIconSize(width, height));
  }

  static double getEmptyIconSize(double width, double height) {
    if (width > height) {
      return height;
    } else if (width < height) {
      return width;
    } else {
      return width;
    }
  }
}
