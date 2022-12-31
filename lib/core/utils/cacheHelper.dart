
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static SharedPreferences? sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }
   static dynamic getData({
    required String key,
  })
  {
     return sharedPreferences!.get(key);
  }
  static  bool? getBoolen({
    required String key,
  })
  {
    return sharedPreferences!.getBool(key);
  }
  static String? getString({
    required String key,
  })
  {
    return sharedPreferences!.getString(key);
  }


   static Future<bool>SaveData({
    required String key,
    required dynamic value,
  }) async
  {
    if(value is String) {
      return await sharedPreferences!.setString(key, value);
    }
    if(value is int) {
      return await sharedPreferences!.setInt(key, value);
    }
    if(value is double) {
      return await sharedPreferences!.setDouble(key, value);
    }
    return await sharedPreferences!.setBool(key, value);

  }
  static void removeData(Key){
    sharedPreferences!.remove(Key);
  }
}

