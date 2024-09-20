import 'package:get/get_navigation/src/root/internacionalization.dart';

class Strings extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_title': 'OTM Inventory',
          'login': 'Login',
          'required_field': 'Required Field',
          'phone': 'Phone',
          'phone_number': 'Phone Number',
          'email': 'Email',
          'try_again': "Try Again",
          'no_internet': "Please Check Your Internet Connection!",
          'verify_otp': "Verify OTP",
          'verify_otp_hint1':
              "Enter the four-digit code that you were sent over mobile SMS.",
          'click_on_': "Click On ",
          'resend_': "Resend,",
          'otm_received_note': " if you do not receive after 2 minutes",
          'submit': "Submit",
          'enter_otp': "Enter OTP",
          'otp_resend_success_message': "Otp resend",
          'home': "Home",
          'profile': "Profile",
          'more': "More",
          'product_list': "Product List",
          'products': "Products",
          'stores': "Stores",
          'stocks': "Stocks",
          'suppliers': "Suppliers",
          'vendors': "Vendors",
          'empty_data_message': "No data found",
          'empty_user_message': "No user found",
          'sku': "SKU",
          'price': "Price",
          'manufacturer': "Manufacturer",
          'category': "Category",
          'categories': "Categories",
          'select_phone_extension': "Select phone extension",
          'search': "Search",
          'settings': "Settings",
          'logout': "Logout",
          'logout_msg': "Are you sure you want to logout?",
          'yes': "Yes",
          'no': "No",
          'add_product': "Add Product",
          'edit_product': "Edit Product",
          'product_short_name': "Product Short Name",
          'short_name': "Short Name",
          'name': "Name",
          'product_name': "Product Name",
          'supplier': "Supplier",
          'length': "Length",
          'width': "Width",
          'height': "Height",
          'dimensions_': "Dimensions (Length * Width * Height)",
          'length_unit': "Length Unit",
          'weight': "Weight",
          'weight_unit': "Weight Unit",
          'model': "Model",
          'tax_percentage': "Tax (%)",
          'description': "Description",
          'status': "Status",
          'upload_pictures': "Upload Pictures",
          'address': "Address",
          'location': "Location",
          'street': "Street",
          'town': "Town",
          'postcode': "Postcode",
          'company_name': "Company Name",
          'save': "Save",
          'qr_code': "Qr Code",
          'unauthorized_message':
              "We are signing you out as we found your account access from another device",
          'add_store': "Add Store",
          'edit_store': "Edit Store",
          'store_name': "Store Name",
          'store_manager': "Store Manager",
          'select': "Select",
          'cancel': "Cancel",
          'add_supplier': "Add Supplier",
          'edit_supplier': "Edit Supplier",
          'contact_name': "Contact Name",
          'email_valid_error': "Enter valid email",
          'add_category': "Add Category",
          'edit_category': "Edit Category",
          'category_name': "Category Name",
          'photos': "Photos",
          'edit_stock': "Edit Stock",
          'quantity': "Quantity",
          'note': "Note",
          'dimension_hwl': "Dimension (h*w*l)",
          'store': "Store",
          'select_store': "Select Store",
          'supplier_name': "Supplier Name",
          'supplier_code': "Supplier Code",
          'qty_in_stock': "QTY in Stock",
          'add_quantity': "Add quantity",
          'empty_store_message': "No store found",
          'dashboard': "Dashboard",
          'deduct': "Deduct",
          'add': "Add",
          'stock_movement': "Stock Movement",
          'view_more_': "View More..",
          'reload': "Reload",
          'active': "Active",
          'exit_warning': "Press Back Button Again to Exit.",
          'add_new_product': "Add New Product",
          'attach_product': "Attach Product",
          'empty_qr_code_scan_msg':
              "We do not find this product in our records, Click buttons below if you want to attach any product with the barcode or add new product with this barcode",
          'reference': "Reference",
          'select_user': "Select User",
          'add_stock': "Add Stock",
          'all': "All",
          'in': "In",
          'out': "Out",
          'login_with_otp': "Login with OTP",
          'msg_attach_barcode':
              "Do you want to attach this product with barcode?",
          'msg_update_barcode':
              "Do you want to edit/update barcode?, By pressing Yes you need to scan a new barcode.",
          'barcode_list': "Barcode",
          'product_id': "Product ID",
          'barcode_attached_success_msg':
              "Barcode attached with this product successfully",
          'barcode_update_success_msg': "Barcode edited successfully",
          'update_barcode': "Update Barcode",
          'update': "Update",
          'delete_product_msg': "Are you sure you want to delete this product?",
          'delete_stock_msg': "Are you sure you want to delete this stock?",
          'delete_item_msg': "Are you sure you want to delete?",
          'clear': "Clear",
          'remove': "Remove",
          'loading_more_': "Loading More...",
          'date': "Date",
          'code': "Code",
          'select_photo_from_': "Select Photo From:",
          'camera': "Camera",
          'gallery': "Gallery",
          'stock_filter': "Stock Filter",
          'apply': "Apply",
          'msg_product_stock_update': "Product Stock Updated!",
          'update_stock': "Update Stock",
          'msg_no_qr_code_product_match':
              "We do not find this product in our record",
          'in_stock': "In Stock",
          'low_stock': "Low Stock",
          'out_of_stock': "Out of stock",
          'minus_stock': "Minus Stock",
          'download': "Download",
          'upload': "Upload",
          'sync': "Sync",
          'msg_stock_data_downloaded': "Stock Data Downloaded!",
          'msg_stock_data_uploaded': "Stock Data Uploaded!",
          'msg_data_uploaded': "Data Uploaded!",
          'msg_press_upload_button_before_download':
              "Note: Press upload button before downloading the data.",
          'product_added_successfully': "Product added successfully",
          'product_updated_successfully': "Product updated successfully",
          'app_up_to_Date': "App is up to date",
          'msg_barcode_already_exist': "This barcode already exist",
          'pull_down_to_refresh': "Pull down to refresh",
          'print': "Print",
          'choose_type': "Choose Type",
          'empty_products_selected': "Please select product",
          'view_pdf': "View Pdf",
          'download_pdf': "Download Pdf",
          'msg_file_downloaded': "File downloaded, Check download folder.",
          'select_all': "Select All",
          'unselect_all': "Unselect All",
          'select_the_store': "Select the store",
          'data_is_up_to_date': "Data is up to date",
          'id_': "ID",
          'purchase_order': "Purchase Order",
          'scan_items': "Scan Items",
          'receive': "Receive",
          'issued': "Issued",
          'received': "Received",
          'partially_received': "Partially Received",
          'cancelled': "Cancelled",
          'purchase_order_received_qty_msg':
              "Receive quantity must be less than total quantity.",
          'account_number': "Account Number",
          'manage_barcode': "Manage Barcode",
          'enter_barcode': "Enter Barcode",
          'cutoff': "Low Stock Indicator",
        },
        'hi_IN': {'login': 'Login'}
      };
}
