import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_controller.dart';
import 'package:otm_inventory/pages/products/order_details/view/widgets/order_details_action_buttons.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../../../res/colors.dart';
import '../../../../../widgets/image/cached_image.dart';
import '../../../../../widgets/text/PrimaryTextView.dart';
import '../../../../../widgets/text_field_border.dart';

class OrderProductItem extends StatelessWidget {
  OrderProductItem(
      {super.key,
      this.info,
      this.position,
      this.totalLength,
      this.onValueChange,
      required this.controller});

  final ValueChanged<String>? onValueChange;
  final TextEditingController controller;
  final ProductInfo? info;
  final int? position, totalLength;
  final orderDetailsController = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PrimaryTextView(
                            text: info?.shortName ?? "",
                            color: primaryTextColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 4),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.grey),
                        //     borderRadius: BorderRadius.circular(4),
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       InkWell(
                        //         onTap: () {
                        //           String text =
                        //               controller.text.toString().trim();
                        //           if (!StringHelper.isEmptyString(text) &&
                        //               int.parse(text) > 0) {
                        //             controller.text =
                        //                 (int.parse(text) - 1).toString();
                        //           }
                        //         },
                        //         child: Icon(
                        //           Icons.remove,
                        //           weight: 300,
                        //           size: 22,
                        //           color: secondaryTextColor,
                        //         ),
                        //       ),
                        //       Container(
                        //         width: 50,
                        //         // Custom width
                        //         height: 30,
                        //         child: TextFormField(
                        //             textAlign: TextAlign.center,
                        //             controller: controller,
                        //             maxLines: 1,
                        //             cursorHeight: 18,
                        //             // Custom cursor height
                        //             cursorWidth: 1,
                        //             //
                        //             keyboardType: TextInputType.number,
                        //             textInputAction: TextInputAction.done,
                        //             validator: MultiValidator([]),
                        //             onChanged: onValueChange,
                        //             decoration: const InputDecoration(
                        //               isDense: true,
                        //               border: InputBorder.none,
                        //             ),
                        //             inputFormatters: <TextInputFormatter>[
                        //               // for below version 2 use this
                        //               FilteringTextInputFormatter.allow(
                        //                   RegExp(r'[0-9]')),
                        //             ]),
                        //       ),
                        //       InkWell(
                        //         onTap: () {
                        //           String text =
                        //               controller.text.toString().trim();
                        //           if (!StringHelper.isEmptyString(text)) {
                        //             controller.text =
                        //                 (int.parse(text) + 1).toString();
                        //           } else {
                        //             controller.text = "1";
                        //           }
                        //         },
                        //         child: Icon(
                        //           Icons.add,
                        //           weight: 300,
                        //           size: 22,
                        //           color: secondaryTextColor,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        PrimaryTextView(
                          text: (info?.qty ?? 0).toString(),
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          softWrap: true,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryTextView(
                          text: info?.uuid ?? "",
                          color: secondaryLightTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          softWrap: true,
                        ),
                        PrimaryTextView(
                          text:
                              "${orderDetailsController.orderInfo.value.currency ?? ""}${info?.price ?? ""}",
                          color: secondaryLightTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          softWrap: true,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    PrimaryTextView(
                      text: info?.status_message ?? "",
                      color: orderDetailsController
                          .getStatusTextColor(info?.order_status_int ?? 0),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      softWrap: true,
                    ),
                    OrderDetailsActionButtons(
                      status: info?.order_status_int ?? 0,
                      productId: info?.product_id ?? 0,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: (position ?? 0) != (totalLength ?? 0) - 1,
          child: const Divider(
            thickness: 1,
            height: 1,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}
