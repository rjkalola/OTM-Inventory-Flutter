import '../web_services/response/module_info.dart';

class StringHelper {
  static bool isEmptyString(String? string) {
    bool valid = string != null && string.isNotEmpty;
    return !valid;
  }

  static String getCommaSeparatedIds(List<ModuleInfo>? list) {
    String commaSeparateIds = "";
    if (list != null && list.isNotEmpty) {
      List<String> itemIds = [];
      for (int i = 0; i < list.length; i++) {
        itemIds.add(list[i].id.toString());
      }
      commaSeparateIds = itemIds.join(',');
    }
    return commaSeparateIds;
  }

  static String getCommaSeparatedNames(List<ModuleInfo>? list) {
    String commaSeparateNames = "";
    if (list != null && list.isNotEmpty) {
      List<String> itemIds = [];
      for (int i = 0; i < list.length; i++) {
        itemIds.add(list[i].name!);
      }
      commaSeparateNames = itemIds.join(',');
    }
    return commaSeparateNames;
  }

}
