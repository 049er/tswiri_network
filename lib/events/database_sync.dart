import 'dart:convert';

import 'package:tswiri_database/export.dart';

///Used to sync the database across devices.
class DatabaseSync {
  DatabaseSync({
    required this.isar,
  });
  Isar isar;

  Map<String, int> databaseHashesFromJson(String json) {
    return jsonDecode(json) as Map<String, int>;
  }

  String jsonHash() {
    return jsonEncode(generateCollectionHashes());
  }

  ///Hash the all the collections in the database.
  Map<String, int> generateCollectionHashes() {
    return {
      'barcodeBatchs': hashBarcodeBatchs(isar),
      'cameraCalibrationEntrys': hashCameraCalibrationEntrys(isar),
      'catalogedBarcodes': hashCatalogedBarcodes(isar),
      'catalogedContainers': hashCatalogedContainers(isar),
      'catalogedCoordinates': hashCatalogedCoordinates(isar),
      'catalogedGrids': hashCatalogedGrids(isar),
      'containerRelationships': hashContainerRelationships(isar),
      'containerTags': hashContainerTags(isar),
      'containerTypes': hashContainerTypes(isar),
      'markers': hashMarkers(isar),
      'mLDetectedLabelTexts': hashMLDetectedLabelTexts(isar),
      'mLPhotoLabels': hashMLPhotoLabel2(isar),
      'mLObjects': hashMLObjects(isar),
      'mLObjectLabels': hashMLObjectLabels(isar),
      'mLDetectedElementTexts': hashMLDetectedElementTexts(isar),
      'mLTextBlocks': hashMLTextBlocks(isar),
      'mLTextElements': hashMLTextElements(isar),
      'mLTextLines': hashMLTextLines(isar),
      'objectLabels': hashObjectLabels(isar),
      'photos': hashPhotos(isar),
      'photoLabels': hashPhotoLabels(isar),
      'tagTexts': hashTagTexts(isar),
    };
  }

  String comparable() {
    return '';
  }
}
