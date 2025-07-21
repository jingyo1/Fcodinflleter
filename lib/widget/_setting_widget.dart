import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/gallery_controller.dart';
import '../views/gallery_picker_view.dart';
import '../helpers/database_helper.dart';

class for_longtop extends StatefulWidget {
  final VoidCallback onSwitch;
  final PageController pageController;
  const for_longtop({
    Key? key,
    required this.pageController,
    required this.onSwitch,
  }) : super(key: key);
  @override
  _for_longtop createState() => _for_longtop();
}
class _for_longtop extends State<for_longtop> {
  List<File> _userSelectedImages = [];
  late final GalleryController _controller;
  @override
  void initState() {
    super.initState();
     _controller = GalleryController();  
    _loadImages();
  }

   Future<void> _loadImages() async {
    final files = await _controller.loadSavedImages(ClothingType.longtop);
    setState(() {
      _userSelectedImages = files;
    });
  }
        
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView.builder(
                controller: widget.pageController,
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                pageSnapping: true,
                itemCount: _userSelectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _userSelectedImages.length) {
                    return Center(
                      child: AddGalleryImageButton(
                        controller: _controller,
                        type: ClothingType.longtop,
                        onImageSaved: _loadImages,
                        pageController: widget.pageController
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _userSelectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: widget.onSwitch,
          ),
          ),
        ],
      ),
    );  
  }
}
// 가로 스냅 스크롤 위젯, 반팔
class for_shorttop extends StatefulWidget {
    final VoidCallback onSwitch;
    final PageController pageController;
    const for_shorttop({
    Key? key,
    required this.pageController,
    required this.onSwitch,
  }) : super(key: key);
  @override
  _for_shorttop createState() => _for_shorttop();
}
class _for_shorttop extends State<for_shorttop> {
  List<File> _userSelectedImages = [];
  late final GalleryController _controller;
  @override
  void initState() {
    super.initState();
     _controller = GalleryController(); 
    _loadImages();
  }
   Future<void> _loadImages() async {
    final files = await _controller.loadSavedImages(ClothingType.shorttop);
    setState(() {
      _userSelectedImages = files;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView.builder(
                controller: widget.pageController,
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                pageSnapping: true,
                itemCount: _userSelectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _userSelectedImages.length) {
                    return Center(
                      child: AddGalleryImageButton(
                        controller: _controller,
                        type: ClothingType.shorttop,
                        onImageSaved: _loadImages,
                        pageController: widget.pageController,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _userSelectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: widget.onSwitch,
          ),
          ),
        ],
      ),
    );
  }
}

// 가로 스냅 스크롤 위젯, 긴바지
class for_longbottom extends StatefulWidget {
  final VoidCallback onSwitch;
  final PageController pageController;
  const for_longbottom({
    Key? key,
    required this.pageController,
    required this.onSwitch,
  }) : super(key: key);
  @override
  _for_longbottom createState() => _for_longbottom();
}
class _for_longbottom extends State<for_longbottom> {
  List<File> _userSelectedImages = [];
  late final GalleryController _controller;
  @override
  void initState() {
    super.initState();
     _controller = GalleryController();    
    _loadImages();
  }

   Future<void> _loadImages() async {
    final files = await _controller.loadSavedImages(ClothingType.longbottom);
    setState(() {
      _userSelectedImages = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView.builder(
                controller: widget.pageController,
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                pageSnapping: true,
                itemCount: _userSelectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _userSelectedImages.length) {
                    return Center(
                      child: AddGalleryImageButton(
                        controller: _controller,
                        type: ClothingType.longbottom,
                        onImageSaved: _loadImages,
                        pageController: widget.pageController,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _userSelectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: widget.onSwitch,
          ),
          ),
        ],
      ),
    );  
  }
}


// 가로 스냅 스크롤 위젯, 반바지
class for_shortbottom extends StatefulWidget {
    final VoidCallback onSwitch;
    final PageController pageController;
    const for_shortbottom({
    Key? key,
    required this.pageController,
    required this.onSwitch,
  }) : super(key: key);
  @override
  _for_shortbottom createState() => _for_shortbottom();
}
class _for_shortbottom extends State<for_shortbottom> {
  List<File> _userSelectedImages = [];
  late final GalleryController _controller;
  @override
  void initState() {
    super.initState();
     _controller = GalleryController();   
    _loadImages();
  }
   Future<void> _loadImages() async {
    final files = await _controller.loadSavedImages(ClothingType.shortbottom);
    setState(() {
      _userSelectedImages = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView.builder(
                controller: widget.pageController,
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                pageSnapping: true,
                itemCount: _userSelectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _userSelectedImages.length) {
                    return Center(
                      child: AddGalleryImageButton(
                        controller: _controller,
                        type: ClothingType.shortbottom,
                        onImageSaved: _loadImages,
                        pageController: widget.pageController,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _userSelectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: widget.onSwitch,
          ),
          ),
        ],
      ),
    );
  }
}

// 가로 스냅 스크롤 위젯, 신발
class for_shoes extends StatefulWidget {
  final PageController pageController;
  const for_shoes({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _for_shoes createState() => _for_shoes();
}
class _for_shoes extends State<for_shoes> {
  List<File> _userSelectedImages = [];
  late final GalleryController _controller;
  @override
  void initState() {
    super.initState();
    _controller = GalleryController();
    _loadImages();
  }
  Future<void> _loadImages() async {
    final files = await _controller.loadSavedImages(ClothingType.shoes);
    setState(() {
      _userSelectedImages = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView.builder(
                controller: widget.pageController,
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                pageSnapping: true,
                itemCount: _userSelectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _userSelectedImages.length) {
                    return Center(
                      child: AddGalleryImageButton(
                        controller: _controller,
                        type: ClothingType.shoes,
                        onImageSaved: _loadImages,
                        pageController: widget.pageController,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _userSelectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 자켓용 위젯 
class for_jacket extends StatefulWidget {
  final VoidCallback onClose;
  final PageController pageController;
  const for_jacket({
    Key? key,
    required this.pageController,
    required this.onClose,
  }) : super(key: key);

  @override
  _for_jacket createState() => _for_jacket();
}
class _for_jacket extends State<for_jacket> {
  List<File> _userSelectedImages = [];
  late final GalleryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GalleryController();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final files = await _controller.loadSavedImages(ClothingType.jacket);
    setState(() {
      _userSelectedImages = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: PageView.builder(
                controller: widget.pageController,
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                pageSnapping: true,
                itemCount: _userSelectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _userSelectedImages.length) {
                    return Center(
                      child: AddGalleryImageButton(
                        controller: _controller,
                        type: ClothingType.jacket,
                        onImageSaved: _loadImages,
                        pageController: widget.pageController,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _userSelectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
            ),
          ),
        ],
      ),
    );
  }
}

//위의 위젯들을 담을 컨테이너(기본단위)
class ClothesContainerJacket extends StatelessWidget {
  final bool isShortTop;
  final bool isShortBottom;
  final bool isJacketOpen;
  final VoidCallback onToggle_top;
  final VoidCallback onToggle_bottom;
  final VoidCallback onClose;
  final List<PageController> pageControllers;

  const ClothesContainerJacket({
    Key? key,
    required this.isShortTop,
    required this.isShortBottom,
    required this.isJacketOpen,
    required this.onToggle_top,
    required this.onToggle_bottom,
    required this.onClose,
    required this.pageControllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,
      child: Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10),
                    child: isShortTop
                        ? for_shorttop(onSwitch: onToggle_top,pageController: pageControllers[0],)
                        : for_longtop(onSwitch: onToggle_top,pageController: pageControllers[1]),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10),
                    child: isShortBottom
                        ? for_shortbottom(onSwitch: onToggle_bottom,pageController: pageControllers[2],)
                        : for_longbottom(onSwitch: onToggle_bottom,pageController: pageControllers[3],),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15),
                    child: for_shoes(pageController: pageControllers[4],),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 4 / 5, // 자켓 이미지 비율
                  child:  for_jacket(onClose: onClose,pageController: pageControllers[5],),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
    );
  }
}
//자켓이없는버젼의 컨테이너
class ClothesContainerNoJacket extends StatelessWidget {
  final bool isShortTop;
  final bool isShortBottom;
  final VoidCallback onToggle_top;
  final VoidCallback onToggle_bottom;
  final VoidCallback onClose;
  final List<PageController> pageControllers;

  const ClothesContainerNoJacket({
    Key? key,
    required this.isShortTop,
    required this.isShortBottom,
    required this.onToggle_top,
    required this.onToggle_bottom,
    required this.onClose,
    required this.pageControllers,
  }) : super(key: key);

@override
Widget build(BuildContext context) {
  return Container(
    color: Colors.white, // ← 전체 배경을 흰색으로
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 5,
                          child: isShortTop
                            ? for_shorttop(onSwitch: onToggle_top, pageController: pageControllers[0])
                            : for_longtop(onSwitch: onToggle_top, pageController: pageControllers[1]),
                        ),
                        Expanded(
                          flex: 5,
                          child: isShortBottom
                            ? for_shortbottom(onSwitch: onToggle_bottom, pageController: pageControllers[2])
                            : for_longbottom(onSwitch: onToggle_bottom, pageController: pageControllers[3]),
                        ),
                        Expanded(
                          flex: 3,
                          child: for_shoes(pageController: pageControllers[4]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 15,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: onClose,
          ),
        ),
      ],
    ),
  );
}
}