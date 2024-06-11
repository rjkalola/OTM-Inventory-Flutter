import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/image/place_holder_error_image.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, this.url, required this.size});

  final double size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return !StringHelper.isEmptyString(url)
        ? url!.startsWith("http")
            ? CachedNetworkImage(
                height: size,
                width: size,
                imageUrl: url ?? "",
                placeholder: (context, url) =>
                    PlaceHolderErrorImage(size: size),
                errorWidget: (context, url, error) =>
                    PlaceHolderErrorImage(size: size),
              )
            : Image.file(
                File(url ?? ""),
                height: size,
                width: size,
              )
        : PlaceHolderErrorImage(size: size);
  }
}
