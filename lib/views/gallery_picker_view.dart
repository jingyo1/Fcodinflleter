import 'package:flutter/material.dart';
import '../controllers/gallery_controller.dart';
import '../helpers/database_helper.dart';

class AddGalleryImageButton extends StatelessWidget {
  final GalleryController controller;
  final VoidCallback onImageSaved;
  final ClothingType type;
  final PageController pageController;

  const AddGalleryImageButton({
    super.key,
    required this.controller,
    required this.type,
    required this.onImageSaved,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: '갤러리에서 이미지 선택',
      onPressed: () async {
        await controller.pickAndSaveImage(type);
        onImageSaved();
        pageController.jumpTo(0);
      },
    );
  }
}

class AddOutfitButtonDownload extends StatelessWidget {
  final bool isShortTop;
  final bool isShortBottom;
  final bool isjacket;
  final List<PageController> pageControllers;
  final dynamic outfitController;

  const AddOutfitButtonDownload({
    Key? key,
    required this.isShortTop,
    required this.isShortBottom,
    required this.isjacket,
    required this.pageControllers,
    required this.outfitController,
  }) : super(key: key);

  Future<void> handleSaveOutfit(BuildContext context) async {
    await outfitController.saveOutfit(
      isShortTop,
      isShortBottom,
      isjacket,
      pageControllers,
    );

    // 저장 완료 후 알림 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("코디 저장 완료!")),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      heroTag: 'download',
      onPressed: () => handleSaveOutfit(context),
      child: const Icon(Icons.download),
    );
  }
}