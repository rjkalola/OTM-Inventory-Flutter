import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/add_supplier/add_supplier_controller.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/add_supplier_button.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/text_field_supplier_phone_extension.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/textfield_supplier_address.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/textfield_supplier_company_name.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/textfield_supplier_contact_name.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/textfield_supplier_email.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/textfield_supplier_phone_number.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/textfield_supplier_weight.dart';
import 'package:otm_inventory/pages/add_supplier/widgets/textfield_supplier_weight_unit.dart';

import '../../../res/colors.dart';
import '../../../widgets/CustomProgressbar.dart';
import '../../../widgets/appbar/base_appbar.dart';

class AddSupplierScreen extends StatelessWidget {
  AddSupplierScreen({super.key});

  final addSupplierController = Get.put(AddSupplierController());

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
          title: addSupplierController.title.value,
          isCenterTitle: false,
          isBack: true,
        ),
        body: Obx(() {
          return ModalProgressHUD(
            inAsyncCall: addSupplierController.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: addSupplierController.isMainViewVisible.value,
              child: Column(children: [
                Form(
                  key: addSupplierController.formKey,
                  child: Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            TextFieldSupplierContactName(),
                            TextFieldSupplierEmail(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(flex: 3,child: TextFieldSupplierPhoneExtension(),),
                                Flexible(flex: 4, child: TextFieldSupplierPhoneNumber()),
                              ],
                            ),
                            TextFieldSupplierCompanyName(),
                            TextFieldSupplierAddress(),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFieldSupplierWeight(),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFieldSupplierWeightUnit(),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14,bottom: 18),
                              child: Row(
                                children: [
                                  Text('status'.tr,style: const TextStyle(fontSize: 16,color: primaryTextColor),),
                                  const SizedBox(width: 4,),
                                  Switch(
                                      value: addSupplierController.isStatus.value,
                                      activeColor: defaultAccentColor,
                                      onChanged: (isVisible) {
                                        addSupplierController.isStatus.value =
                                            isVisible;
                                      })
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
                AddSupplierButton()
              ]),
            ),
          );
        }),
      ),
    );
  }
}
