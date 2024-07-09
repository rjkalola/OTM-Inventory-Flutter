import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/image/cached_image.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../../../../widgets/text_field_border.dart';

class ProductItem extends StatelessWidget {
  ProductItem({super.key, this.onValueChange, required this.controller});

  final ValueChanged<String>? onValueChange;
  final Rx<TextEditingController> controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Column(
        children: [
          Row(
            children: [
              CachedImage(
                url: "",
                width: 50,
                height: 50,
                placeHolderSize: 50,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextView(
                      text: "Product title short name",
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      softWrap: true,
                    ),
                    PrimaryTextView(
                      text: "Code: 3534543",
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      softWrap: true,
                    ),
                    Row(
                      children: [
                        PrimaryTextView(
                          text: "Ordered: 60",
                          color: secondaryLightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          softWrap: true,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        PrimaryTextView(
                          text: "Ordered: 60",
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
                  textAlign: TextAlign.center,
                  textEditingController: controller.value,
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
