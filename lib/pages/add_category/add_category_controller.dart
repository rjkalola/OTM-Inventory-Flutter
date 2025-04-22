import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/add_category/add_category_repository.dart';
import 'package:otm_inventory/pages/add_category/model/add_category_request.dart';
import 'package:otm_inventory/pages/category_list/model/category_info.dart';
import 'package:otm_inventory/pages/common/drop_down_list_dialog.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/select_Item_list_dialog.dart';
import 'package:otm_inventory/pages/products/add_product/model/product_resources_response.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';

class AddCategoryController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isStatus = true.obs,
      isSaveEnable = false.obs,
      isDeleteVisible = false.obs;
  RxString title = ''.obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddCategoryRepository();
  final addRequest = AddCategoryRequest();
  final filePath = "".obs;

  final categoryNameController = TextEditingController().obs;
  final parentCategoryController = TextEditingController().obs;
  final productResourcesResponse = ProductResourcesResponse().obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      title.value = 'edit_category'.tr;
      CategoryInfo info = arguments[AppConstants.intentKey.categoryInfo];
      print("info.id:" + info.id.toString());
      print("category name:" + info.name!);

      addRequest.id = info.id ?? 0;
      categoryNameController.value.text = info.name ?? "";
      addRequest.parent_category_id = info.parent_category_id ?? 0;
      addRequest.pc_name = info.pc_name ?? "";
      parentCategoryController.value.text = info.pc_name ?? "";
      isStatus.value = info.status ?? false;

      isDeleteVisible.value = info.id != 0;
    } else {
      title.value = 'add_category'.tr;
    }

    if (AppStorage().getProductResources() != null) {
      productResourcesResponse.value = AppStorage().getProductResources()!;
      isMainViewVisible.value = true;
    }
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {
      if (isSaveEnable.value) {
        addRequest.category_name =
            categoryNameController.value.text.toString().trim();
        addRequest.status = isStatus.value;
        storeCategoryApi();
      } else {
        Get.back();
      }
    }
  }

  void storeCategoryApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addRequest.id;
    map["category_name"] = addRequest.category_name;
    map["parent_category_id"] = addRequest.parent_category_id ?? 0;
    // map["status"] = addRequest.status;
    map["status"] = true;
    multi.FormData formData = multi.FormData.fromMap(map);

    if (!StringHelper.isEmptyString(filePath.value)) {
      formData.files.add(
        MapEntry(
            "attachment", await multi.MultipartFile.fromFile(filePath.value)),
      );
    }

    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.storeCategory(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            Get.back(result: true);
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void deleteCategoryApi() async {
    Map<String, dynamic> map = {};
    map["ids"] = addRequest.id;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;
    _api.deleteCategory(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            Get.back(result: true);
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void onValueChange() {
    isSaveEnable.value = true;
  }

  void showParentCategoryList() {
    if (productResourcesResponse.value.categories != null &&
        productResourcesResponse.value.categories!.isNotEmpty) {
      showDropDownDialog(
          AppConstants.dialogIdentifier.parentCategoryList,
          'parent_category'.tr,
          productResourcesResponse.value.categories!,
          this);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.parentCategoryList) {
      parentCategoryController.value.text = name;
      addRequest.parent_category_id = id;
      isSaveEnable.value = true;
    } else if (action == AppConstants.action.selectImageFromCamera ||
        action == AppConstants.action.selectImageFromGallery) {
      setIcon(action);
    }
  }

  onClickAddPhoto() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'camera'.tr;
    info.action = AppConstants.action.selectImageFromCamera;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'gallery'.tr;
    info.action = AppConstants.action.selectImageFromGallery;
    listOptions.add(info);

    showAttachmentOptionsDialog(
        AppConstants.dialogIdentifier.attachmentOptionsList,
        'select_photo_from_'.tr,
        listOptions,
        this);
  }

  void onClickRemoveIcon() {
    filePath.value = "";
  }

  void showAttachmentOptionsDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        SelectItemListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: false);
  }

  void setIcon(String action) async {
    isSaveEnable.value = true;
    try {
      XFile? pickedFile;
      if (action == AppConstants.action.selectImageFromCamera) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900,
          imageQuality: 90,
        );
      } else if (action == AppConstants.action.selectImageFromGallery) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900,
          imageQuality: 90,
        );
      }

      if (pickedFile != null) {
        filePath.value = pickedFile.path;
      }
    } catch (e) {
      print("error:" + e.toString());
    }
  }

  void onClickRemoveCategory() {
    AlertDialogHelper.showAlertDialog("", 'delete_category_msg'.tr, 'yes'.tr,
        'no'.tr, "", true, this, AppConstants.dialogIdentifier.deleteCategory);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteCategory) {
      deleteCategoryApi();
      Get.back();
    }
  }
}
