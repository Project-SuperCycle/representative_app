import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supercycle/core/models/trader_branch_model.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';

abstract class StorageServices {
  /// Create storage
  static const storage = FlutterSecureStorage();

  /// Store any type of data by converting it to JSON
  static Future<void> storeData(String key, dynamic value) async {
    try {
      String jsonString;

      if (value == null) {
        jsonString = jsonEncode(null);
      } else if (value is String) {
        // Store strings directly with a type indicator
        jsonString = jsonEncode({'type': 'string', 'data': value});
      } else if (value is num || value is bool) {
        // Store numbers and booleans with type indicator
        jsonString = jsonEncode({
          'type': value.runtimeType.toString(),
          'data': value,
        });
      } else if (value is Map || value is List) {
        // Store collections with type indicator
        jsonString = jsonEncode({
          'type': value.runtimeType.toString(),
          'data': value,
        });
      } else {
        // Try to serialize custom objects
        jsonString = jsonEncode({'type': 'object', 'data': value});
      }

      await storage.write(key: key, value: jsonString);
    } catch (e) {
      throw Exception('Failed to store data: ${e.toString()}');
    }
  }

  /// Read data and return it in its original type
  static Future<T?> readData<T>(String key) async {
    try {
      final jsonString = await storage.read(key: key);

      if (jsonString == null) return null;

      final decoded = jsonDecode(jsonString);

      // Handle null values
      if (decoded == null) return null;

      // If it's a simple value without type indicator (backward compatibility)
      if (decoded is! Map || !decoded.containsKey('type')) {
        return decoded as T?;
      }

      // Extract data based on type
      final type = decoded['type'] as String;
      final data = decoded['data'];

      switch (type) {
        case 'string':
          return data as T?;
        case 'int':
          return data as T?;
        case 'double':
          return data as T?;
        case 'bool':
          return data as T?;
        case '_InternalLinkedHashMap<String, dynamic>':
        case 'Map<String, dynamic>':
          return data as T?;
        case 'List<dynamic>':
          return data as T?;
        default:
          return data as T?;
      }
    } catch (e) {
      throw Exception('Failed to read data: ${e.toString()}');
    }
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    return await storage.containsKey(key: key);
  }

  /// Delete a specific key
  static Future<void> deleteData(String key) async {
    await storage.delete(key: key);
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    await storage.deleteAll();
  }

  /// Get all keys
  static Future<Map<String, String>> getAllData() async {
    return await storage.readAll();
  }

  /// GET USER DATA
  static Future<LoginedUserModel?> getUserData() async {
    var data = await StorageServices.readData<Map<String, dynamic>>('user');
    if (data == null) {
      return null;
    }

    LoginedUserModel user = LoginedUserModel(
      bussinessName: data['bussinessName'],
      rawBusinessType: data['rawBusinessType'],
      bussinessAdress: data['bussinessAdress'],
      doshMangerName: data['doshMangerName'],
      doshMangerPhone: data['doshMangerPhone'],
      email: data['email'],
      role: data['role'],
      displayName: data['displayName'],
      phone: data['phone'],
      isEcoParticipant: data['isEcoParticipant'],
    );
    return user;
  }

  /// GET USER BRANCHS
  static Future<List<TraderBranchModel>> getUserBranchs() async {
    try {
      // readData هترجع الـ data مباشرة (List أو Map)
      final data = await StorageServices.readData("user_branchs");

      if (data == null) return [];

      List<dynamic> branchsMap;

      // التعامل مع الحالتين: لو جاية Map فيها data أو List مباشرة
      if (data is Map && data.containsKey('data')) {
        branchsMap = data['data'] as List<dynamic>;
      } else if (data is List) {
        branchsMap = data;
      } else {
        return [];
      }

      return branchsMap
          .map(
            (json) => TraderBranchModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to retrieve user branchs: ${e.toString()}');
    }
  }

  /// GET USER TOKEN
  static Future<String?> getUserToken() async {
    var token = await StorageServices.readData<String>('token');
    if (token == null) {
      return null;
    }

    return token;
  }
}
