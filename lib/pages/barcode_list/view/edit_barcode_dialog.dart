import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import '../../../res/colors.dart';
import '../../../res/drawable.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/PrimaryBorderButton.dart';
import '../../../widgets/text_field_border.dart';
import '../listener/barcode_save_listener.dart';

class EditBarcodeDialog extends StatefulWidget {
  final String? barcode;
  final BarcodeSaveListener? listener;
  final bool? isAdd;
  final int? position;

  const EditBarcodeDialog({
    super.key,
    this.barcode,
    this.isAdd,
    this.position,
    this.listener,
  });

  @override
  State<EditBarcodeDialog> createState() =>
      EditBarcodeDialogState(barcode, isAdd, position, listener);
}

class EditBarcodeDialogState extends State<EditBarcodeDialog> {
  String? barcode;
  BarcodeSaveListener? listener;
  bool? isAdd;
  int? position;

  TextEditingController barcodeController = TextEditingController();

  EditBarcodeDialogState(
      this.barcode, this.isAdd, this.position, this.listener);

  @override
  void initState() {
    super.initState();
    barcodeController.text = barcode ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) => Container(
              decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
              child: SizedBox(
                height: 180,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                                child: TextFieldBorder(
                                  textEditingController: barcodeController,
                                  hintText: 'enter_barcode'.tr,
                                  labelText: 'enter_barcode'.tr,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.done,
                                  validator: MultiValidator([]),
                                ),
                              )),
                          InkWell(
                            onTap: () {
                              openQrCodeScanner();
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                  color: defaultAccentColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: SvgPicture.asset(
                                  width: 24,
                                  height: 24,
                                  Drawable.barCodeIcon,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: PrimaryBorderButton(
                              buttonText: 'cancel'.tr,
                              textColor: Colors.red,
                              borderColor: Colors.red,
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: PrimaryBorderButton(
                                buttonText: 'save'.tr,
                                textColor: defaultAccentColor,
                                borderColor: defaultAccentColor,
                                onPressed: () {
                                  if (!StringHelper.isEmptyString(
                                      barcodeController.text)) {
                                    listener?.onBarcodeSave(
                                        barcodeController.text,
                                        isAdd ?? false,
                                        position ?? 0);
                                  }
                                  Get.back();
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Future<void> openQrCodeScanner() async {
    var code = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (!StringHelper.isEmptyString(code)) {
      print("mBarCode:" + code);
      barcodeController.text = code;
    }
  }
}
