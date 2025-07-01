import 'package:flutter/material.dart';
import 'package:new_flutter_app/controllers/gallery_controller.dart';
import 'package:new_flutter_app/views/gallery_picker_view.dart';
import '../../widget/_setting_widget.dart';
class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isShortTop = true;
  bool isShortBottom = true;
  bool isjacket = true;
  late OutfitController outfitController;
  List<PageController> pageControllers = [
  PageController(), // pageController_shorttop
  PageController(), // pageController_longtop
  PageController(), // pageController_shortbottom
  PageController(), // pageController_longbottom
  PageController(), // pageController_shoes
  PageController(), // pageController_jacket
];

  @override
  void initState() {
    super.initState();
    outfitController = OutfitController(pageControllers);
  }

  void _toggleWidget_top() {
    setState(() => isShortTop = !isShortTop);
  }
  void _toggleWidget_bottom() {
    setState(() => isShortBottom = !isShortBottom);
  }
  void _toggleWidget_jacket() {
    setState(() => isjacket = !isjacket);
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Stack(
      children: [
        // 자켓 열림/닫힘 컨테이너
        isjacket
          ? ClothesContainerJacket(
              isShortTop: isShortTop,
              isShortBottom: isShortBottom,
              isJacketOpen: isjacket,
              onToggle_top: _toggleWidget_top,
              onToggle_bottom: _toggleWidget_bottom,
              onClose: _toggleWidget_jacket,
              pageControllers: pageControllers,
            )
          : ClothesContainerNoJacket(
              isShortTop: isShortTop,
              isShortBottom: isShortBottom,
              onToggle_top: _toggleWidget_top,
              onToggle_bottom: _toggleWidget_bottom,
              onClose: _toggleWidget_jacket,
              pageControllers: pageControllers,
            ),

        // 오른쪽 하단 FloatingActionButton 그룹
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              AddOutfitButtonDownload(isShortTop: isShortTop,
              isShortBottom: isShortBottom,
               isjacket: isjacket,
                pageControllers: pageControllers,
                outfitController: outfitController),
            ],
          ),
        ),
      ],
    ),
  );
}
}