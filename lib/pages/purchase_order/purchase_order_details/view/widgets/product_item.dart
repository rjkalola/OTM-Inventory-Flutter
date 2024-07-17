import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/image/cached_image.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../../../../widgets/text_field_border.dart';

class ProductItem extends StatelessWidget {
  ProductItem(
      {super.key, this.info, this.onValueChange, required this.controller});

  final ValueChanged<String>? onValueChange;
  final TextEditingController controller;
  final ProductInfo? info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
      child: Column(
        children: [
          Row(
            children: [
              CachedImage(
                url: info?.imageThumbUrl ?? "",
                width: 50,
                height: 50,
                placeHolderSize: 50,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextView(
                      text: info?.shortName ?? "",
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      softWrap: true,
                    ),
                    PrimaryTextView(
                      text: "Code: ${info?.supplier_code ?? ""}",
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      softWrap: true,
                    ),
                    Row(
                      children: [
                        PrimaryTextView(
                          text: "Ordered: ${info?.qty ?? 0}",
                          color: secondaryLightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          softWrap: true,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        PrimaryTextView(
                          text: "Received: ${info?.product_receive_qty ?? 0}",
                          color: secondaryLightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          softWrap: true,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: 70,
                child: TextFieldBorder(
                  isDense: true,
                  textAlign: TextAlign.center,
                  textEditingController: controller,
                  hintText: "",
                  labelText: "",
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: MultiValidator([]),
                  onValueChange: onValueChange,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
