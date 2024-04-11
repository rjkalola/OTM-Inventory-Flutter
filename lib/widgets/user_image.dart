import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/string_helper.dart';

class UserImage extends StatelessWidget {
  final String url;
  final double size;
  final String defaultUrl =
      "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png";

  const UserImage({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(url)
        ? CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.scaleDown,
            height: size,
            width: size,
            errorWidget: (context, url, error) => CachedNetworkImage(
              imageUrl: defaultUrl,
              fit: BoxFit.scaleDown,
              height: size,
              width: size,
            ),
          )
        : CachedNetworkImage(
            imageUrl: defaultUrl,
            fit: BoxFit.scaleDown,
            height: size,
            width: size,
          );
  }
}
