
class StringHelper{
  static bool isEmptyString(String? string){
    bool valid = string != null && string.isNotEmpty;
    return !valid;
  }
}