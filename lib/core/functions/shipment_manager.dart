import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:supercycle/core/services/dosh_types_manager.dart';
import 'package:supercycle/core/services/services_locator.dart';
import 'package:supercycle/features/sales_process/data/models/dosh_item_model.dart';

class ShipmentManager {
  static List<Map<String, dynamic>> createDoshItemsMap({
    required List<DoshItemModel> items,
  }) {
    var typesList = getIt<DoshTypesManager>().typesList;

    List<Map<String, dynamic>> doshTypes = [];

    for (var item in items) {
      var type = typesList.firstWhere((type) => type.name == item.name);
      doshTypes.add({'doshType': type.id, 'quantityKg': item.quantity});
    }
    return doshTypes;
  }

  static Future<List<MultipartFile>> createMultipartImages({
    required List<File> images,
  }) async {
    List<MultipartFile> imagesFiles = [];

    // Convert each File to MultipartFile
    for (File imageFile in images) {
      final String imagePath = imageFile.path;
      final String fileName = imagePath.split('/').last;
      final String mimeType =
          lookupMimeType(imagePath) ?? 'application/octet-stream';

      MultipartFile multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );

      imagesFiles.add(multipartFile);
    }
    return imagesFiles;
  }
}
