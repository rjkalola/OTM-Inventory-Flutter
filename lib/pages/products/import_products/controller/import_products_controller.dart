import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/products/add_product/controller/add_product_repository.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_repository.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_list_response.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/store_stock_request.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
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
  final filePath = "".obs,
      fileName = "".obs,
      selectedOption = "addRecord".obs,
      resultMessage = "".obs;

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

  Future<void> onCLickImportProduct() async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      isLoading.value = true;
      int productCount = localProductCount();
      int stockCount = localStockCount();
      if (stockCount > 0) {
        List<StockStoreRequest> list = AppStorage().getStoredStockList();
        storeLocalStocksAPI(jsonEncode(list), productCount);
      } else if (productCount > 0) {
        storeLocalProducts(getLocalStoredProduct());
      } else {
        importProductsApi();
      }
    } else {
      AppUtils.showSnackBarMessage('no_internet'.tr);
    }
  }

  void importProductsApi() async {
    // isLoading.value = true;
    print("importProductsApi call");
    Map<String, dynamic> map = {};
    map["with_stock_import"] = false;
    map["selected_type"] = selectedOption;
    map["store_id"] = AppStorage.storeId.toString();

    multi.FormData formData = multi.FormData.fromMap(map);
    if (!StringHelper.isEmptyString(filePath.value ?? "")) {
      formData.files.add(
        MapEntry("file[]", await multi.MultipartFile.fromFile(filePath.value)),
      );
    }
    print("Request Data:" + map.toString());
    _api.importProducts(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        // isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            getAllStockListApi();
            resultMessage.value = response.Message ?? "";
            filePath.value = "";
            fileName.value = "";
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        // isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  Future<void> getAllStockListApi() async {
    // isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["filters"] = "";
    map["offset"] = 0.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = "";
    map["product_id"] = "0";
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    map["allData"] = "true";

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    StockListRepository().getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().setStockData(response);
            isUploadViewVisible.value = false;
            isFileDetailsVisible.value = false;
            isResultVisible.value = true;
          } else {
            // if (isProgress) AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // if (isProgress)
          //   AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> storeLocalStocksAPI(String data, int productCount) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["app_data"] = data;
    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());
    // if (isProgress) isLoading.value = true;
    StockListRepository().storeLocalStock(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        // isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (productCount > 0) {
              AppStorage().clearStoredStock();
              storeLocalProducts(getLocalStoredProduct());
            } else {
              AppStorage().clearStoredStock();
              AppStorage().clearStoredProduct();
              importProductsApi();
            }
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> storeLocalProducts(List<ProductInfo> listProducts) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["data"] = jsonEncode(listProducts);
    multi.FormData formData = multi.FormData.fromMap(map);
    for (int i = 0; i < listProducts.length; i++) {
      var listFiles = <FilesInfo>[];
      if (!StringHelper.isEmptyList(listProducts[i].temp_images)) {
        for (int j = 0; j < listProducts[i].temp_images!.length; j++) {
          if (!StringHelper.isEmptyString(
                  listProducts[i].temp_images![j].file ?? "") &&
              !listProducts[i].temp_images![j].file!.startsWith("http")) {
            listFiles.add(listProducts[i].temp_images![j]);
          }
        }
      }
      if (listFiles.isNotEmpty) {
        for (var info in listFiles) {
          formData.files.addAll([
            MapEntry("files[$i][]",
                await multi.MultipartFile.fromFile(info.file ?? "")),
          ]);
        }
      }
    }

    print(map.toString());
    // if (isProgress) isLoading.value = true;
    AddProductRepository().storeMultipleProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().clearStoredStock();
            AppStorage().clearStoredProduct();
            importProductsApi();
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  List<ProductInfo> getLocalStoredProduct() {
    List<ProductInfo> listProducts = [];
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        for (int i = 0; i < response.info!.length; i++) {
          bool isLocalStored = response.info![i].localStored ?? false;
          if (isLocalStored) {
            listProducts.add(response.info![i]);
          }
        }
      }
    }
    return listProducts;
  }

  int localStockCount() {
    List<StockStoreRequest> list = AppStorage().getStoredStockList();
    return list.length;
  }

  int localProductCount() {
    int count = 0;
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        List<ProductInfo> list = [];
        for (int i = 0; i < response.info!.length; i++) {
          bool isLocalStored = response.info![i].localStored ?? false;
          if (isLocalStored) {
            list.add(response.info![i]);
          }
        }
        count = list.length;
      }
    }
    return count;
  }
}
