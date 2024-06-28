import 'package:otm_inventory/pages/products/product_list/models/product_image_info.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/stock_qty_history_info.dart';

import '../../../../web_services/response/module_info.dart';
import '../../../common/model/file_info.dart';

class ProductInfo {
  int? id,
      local_id,
      supplierId,
      manufacturer_id,
      weight_unit_id,
      length_unit_id,
      model_id,
      qty,
      newQty = 0,
      mode_type,
      stock_status_id,
      temp_store_id;

  String? shortName,
      name,
      description,
      price,
      image,
      extension,
      qrCode,
      categoryName,
      currency,
      sku,
      model_name,
      manufacturer_name,
      qrCodeThumb,
      imageUrl,
      imageThumbUrl,
      weight,
      length,
      width,
      height,
      tax,
      length_unit_name,
      weight_unit_name,
      supplier_name,
      supplier_code,
      dimension,
      barcode_text,
      stock_status,
      uuid;
  List<ModuleInfo>? categories;
  bool? status, localStored, checkPrint;
  List<StockQtyHistoryInfo>? stock_histories;
  List<ProductImageInfo>? product_images;
  List<FilesInfo>? temp_images;
  List<ProductStockInfo>? product_stocks;

  ProductInfo(
      {this.id,
      this.local_id,
      this.supplierId,
      this.shortName,
      this.name,
      this.description,
      this.price,
      this.image,
      this.extension,
      this.qrCode,
      this.status,
      this.categoryName,
      this.currency,
      this.sku,
      this.model_name,
      this.manufacturer_name,
      this.qrCodeThumb,
      this.imageThumbUrl,
      this.imageUrl,
      this.weight,
      this.length,
      this.width,
      this.height,
      this.tax,
      this.manufacturer_id,
      this.weight_unit_id,
      this.length_unit_id,
      this.model_id,
      this.categories,
      this.length_unit_name,
      this.weight_unit_name,
      this.supplier_name,
      this.supplier_code,
      this.qty,
      this.dimension,
      this.barcode_text,
      this.stock_histories,
      this.newQty,
      this.product_images,
      this.mode_type,
      this.temp_images,
      this.localStored,
      this.stock_status_id,
      this.stock_status,
      this.checkPrint,
      this.product_stocks,
      this.temp_store_id,
      this.uuid});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    local_id = json['local_id'];
    supplierId = json['supplier_id'];
    shortName = json['short_name'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    extension = json['extension'];
    qrCode = json['qr_code'];
    status = json['status'];
    categoryName = json['category_name'];
    currency = json['currency'];
    sku = json['sku'];
    model_name = json['model_name'];
    manufacturer_name = json['manufacturer_name'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    imageUrl = json['image_url'];
    qrCodeThumb = json['qr_code_thumb'];
    imageThumbUrl = json['image_thumb_url'];
    tax = json['tax'];
    manufacturer_id = json['manufacturer_id'];
    weight_unit_id = json['weight_unit_id'];
    length_unit_id = json['length_unit_id'];
    model_id = json['model_id'];
    length_unit_name = json['length_unit_name'];
    weight_unit_name = json['weight_unit_name'];
    supplier_name = json['supplier_name'];
    supplier_code = json['supplier_code'];
    qty = json['qty'];
    mode_type = json['mode_type'];
    dimension = json['dimension'];
    if (json['categories'] != null) {
      categories = <ModuleInfo>[];
      json['categories'].forEach((v) {
        categories!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['stock_histories'] != null) {
      stock_histories = <StockQtyHistoryInfo>[];
      json['stock_histories'].forEach((v) {
        stock_histories!.add(StockQtyHistoryInfo.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      product_images = <ProductImageInfo>[];
      json['product_images'].forEach((v) {
        product_images!.add(ProductImageInfo.fromJson(v));
      });
    }
    barcode_text = json['barcode_text'];
    if (json['temp_images'] != null) {
      temp_images = <FilesInfo>[];
      json['temp_images'].forEach((v) {
        temp_images!.add(FilesInfo.fromJson(v));
      });
    }
    if (json['product_stocks'] != null) {
      product_stocks = <ProductStockInfo>[];
      json['product_stocks'].forEach((v) {
        product_stocks!.add(ProductStockInfo.fromJson(v));
      });
    }
    localStored = json['local_stored'];
    stock_status_id = json['stock_status_id'];
    stock_status = json['stock_status'];
    checkPrint = json['checkPrint'];
    temp_store_id = json['temp_store_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['local_id'] = local_id;
    data['supplier_id'] = supplierId;
    data['short_name'] = shortName;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    data['extension'] = extension;
    data['qr_code'] = qrCode;
    data['status'] = status;
    data['category_name'] = categoryName;
    data['currency'] = currency;
    data['sku'] = sku;
    data['model_name'] = model_name;
    data['manufacturer_name'] = manufacturer_name;
    data['qr_code_thumb'] = qrCodeThumb;
    data['image_thumb_url'] = imageThumbUrl;
    data['image_url'] = imageUrl;
    data['barcode_text'] = barcode_text;
    data['weight'] = weight;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['tax'] = tax;
    data['manufacturer_id'] = manufacturer_id;
    data['weight_unit_id'] = weight_unit_id;
    data['length_unit_id'] = length_unit_id;
    data['model_id'] = model_id;
    data['length_unit_name'] = length_unit_name;
    data['weight_unit_name'] = weight_unit_name;
    data['supplier_name'] = supplier_name;
    data['supplier_code'] = supplier_code;
    data['qty'] = qty;
    data['mode_type'] = mode_type;
    data['dimension'] = dimension;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (stock_histories != null) {
      data['stock_histories'] =
          stock_histories!.map((v) => v.toJson()).toList();
    }
    if (product_images != null) {
      data['product_images'] = product_images!.map((v) => v.toJson()).toList();
    }
    if (temp_images != null) {
      data['temp_images'] = temp_images!.map((v) => v.toJson()).toList();
    }
    if (product_stocks != null) {
      data['product_stocks'] = product_stocks!.map((v) => v.toJson()).toList();
    }
    data['local_stored'] = localStored;
    data['stock_status_id'] = stock_status_id;
    data['stock_status'] = stock_status;
    data['checkPrint'] = checkPrint;
    data['temp_store_id'] = temp_store_id;
    return data;
  }
}

class ProductStockInfo {
  int? id, store_id, product_id;

  ProductStockInfo({
    this.id,
    this.store_id,
    this.product_id,
  });

  ProductStockInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    store_id = json['store_id'];
    product_id = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = store_id;
    data['product_id'] = product_id;
    return data;
  }
}
