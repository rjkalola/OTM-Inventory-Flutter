import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_repository.dart';

import '../../../common/model/file_info.dart';

class ImportProductsController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isUploadViewVisible = true.obs,
      isFileDetailsVisible = false.obs,
      isResultVisible = false.obs;
  final _api = ImportProductsRepository();

  final ImagePicker _picker = ImagePicker();
  var filesList = <FilesInfo>[].obs;
  var selectedImageIndex = 0;
  final filePath = "".obs, fileName = "".obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      // title.value = 'edit_product'.tr;
      // productId = arguments[AppConstants.intentKey.productId];
      // getProductDetails(productId);
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xls', 'xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.path != null) {
        filePath.value = file.path ?? "";
        fileName.value = file.name ?? "";
        isUploadViewVisible.value = false;
        isFileDetailsVisible.value = true;
        isResultVisible.value = false;
        print("File Pth:${filePath.value}");
      }
    }
  }

/*void storeProductApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addProductRequest.id;
    map["short_name"] = addProductRequest.shortName;
    map["name"] = addProductRequest.name;
    map["supplier_id"] = addProductRequest.supplier_id;
    map["length"] = addProductRequest.length;
    map["width"] = addProductRequest.width;
    map["height"] = addProductRequest.height;
    map["length_unit_id"] = addProductRequest.lengthUnit_id;
    map["weight"] = addProductRequest.weight;
    map["weight_unit_id"] = addProductRequest.weightUnit_id;
    map["manufacturer_id"] = addProductRequest.manufacturer_id;
    map["model_id"] = addProductRequest.model_id;
    map["sku"] = addProductRequest.sku;
    map["price"] = addProductRequest.price;
    map["tax"] = addProductRequest.tax;
    map["description"] = addProductRequest.description;
    // map["status"] = addProductRequest.status;
    map["status"] = true;
    map["mode_type"] = addProductRequest.mode_type;
    map["barcode_text"] = addProductRequest.barcode_text ?? "";
    // map["uuid"] = addProductRequest.barcode_text ?? "";

    if (addProductRequest.categories != null &&
        addProductRequest.categories!.isNotEmpty) {
      for (int i = 0; i < addProductRequest.categories!.length; i++) {
        map['categories[${i.toString()}]'] = addProductRequest.categories![i];
      }
    }

    var list = <FilesInfo>[];
    for (int i = 0; i < filesList.length; i++) {
      if (!StringHelper.isEmptyString(filesList[i].file ?? "") &&
          !filesList[i].file!.startsWith("http")) {
        list.add(filesList[i]);
      }
    }

    map["mode_type"] = addProductRequest.mode_type;

    multi.FormData formData = multi.FormData.fromMap(map);
    if (list.isNotEmpty) {
      for (var info in list) {
        formData.files.addAll([
          MapEntry(
              "files[]", await multi.MultipartFile.fromFile(info.file ?? "")),
        ]);
      }
    }

    print("Request Data:" + map.toString());
    isLoading.value = true;
    _api.storeProduct(
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
  }*/
}
