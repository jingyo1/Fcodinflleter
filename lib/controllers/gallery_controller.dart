import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../helpers/database_helper.dart';
import 'package:flutter/material.dart';
class GalleryController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<File> _images = [];
  List<File> get images => _images;

  Future<void> pickAndSaveImage(ClothingType type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
    final File savedFile = await File(pickedFile.path).copy(join(appDir.path, fileName));

    await _db.insertImage(
      savedFile.path,
      type,
      originalId: pickedFile.name,
    );

    await loadSavedImages(type);
}

  Future<List<File>> loadSavedImages(ClothingType type) async {
    final paths = await _db.getAllImagePaths(type);
    debugPrint('DB에서 불러온 경로: $paths');

    final List<File> existingFiles = [];
    for (final path in paths) {
      final file = File(path);
      final exists = await file.exists();
      debugPrint('경로: $path, 존재 여부: $exists');
      if (exists) existingFiles.add(file);
    }
    debugPrint('실제 존재하는 파일: $existingFiles');

    _images = existingFiles;
    notifyListeners();
    return _images;
  }

  Future<void> deleteImage(File image, ClothingType type) async {
    if (await image.exists()) {
      try {
        await image.delete();
      } catch (e) {
        if (kDebugMode) print('파일 삭제 실패: $e');
      }
    }
    await _db.deleteImageByPath(image.path);
    await loadSavedImages(type);
  }

  Future<List<Map<String, dynamic>>> getOutfits({String? status}) async {
    return await _db.getOutfits(status: status);
  }
}

class OutfitController extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final List<PageController> _pageControllers;
  OutfitController(this._pageControllers);
  final GalleryController _controller = GalleryController();
 
  Future<void> saveOutfit(final bool isShortTop,
   final bool isShortBottom,
   final bool isJacketOpen,
    _pagecontrollers,)
    async {
    int topIndex = isShortTop
        ? _pageControllers[0].page?.toInt() ?? 0
        : _pageControllers[1].page?.toInt() ?? 0;
    int bottomIndex = isShortBottom
        ? _pageControllers[2].page?.toInt() ?? 0
        : _pageControllers[3].page?.toInt() ?? 0;
    int shoesIndex = _pageControllers[4].page?.toInt() ?? 0;
    int jacketIndex = isJacketOpen
        ? _pageControllers[5].page?.toInt() ?? 0
        : -1;  


   String topPath = await _getImagePath(
    topIndex,
    isShortTop ? ClothingType.shorttop : ClothingType.longtop,
    );

    String bottomPath = await _getImagePath(
      bottomIndex,
      isShortBottom ? ClothingType.shortbottom : ClothingType.longbottom,
    );

    String shoesPath = await _getImagePath(
      shoesIndex,
      ClothingType.shoes,
    );

    String? jacketPath = jacketIndex != -1
      ? await _getImagePath(jacketIndex, ClothingType.jacket)
      : null;

      // DB에 저장
    await _db.insertOutfit(
      topPath: topPath,
      bottomPath: bottomPath,
      jacketPath: jacketPath,
      shoesPath: shoesPath,
      );
  }

  Future<String> _getImagePath(int index, ClothingType category) async {
    final files = await _controller.loadSavedImages(category);
    List<File> _userSelectedImages = files;
    return _userSelectedImages[index].path;
  }

  Future<void> deleteOutfit(int outfitId) async {
    await _db.deleteOutfitById(outfitId);
    print("Outfit deleted");
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getOutfits({String? status}) async {
    return await _db.getOutfits(status: status);
  }
}
