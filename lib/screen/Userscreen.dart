import 'package:flutter/material.dart';
import 'package:new_flutter_app/controllers/SocialController.dart';
import '../controllers/ItemController.dart';
import '../utils/User_class.dart';
import '../widget/_user_widget.dart';
import '../controllers/UserController.dart';
import '../controllers/gallery_controller.dart';
import '../screen/Loginscreen.dart';
import '../utils/api_client.dart';
import '../screen/Closetscreen.dart';
class UserScreen extends StatefulWidget {
  final ApiClient apiClient;

  const UserScreen({super.key, required this.apiClient});

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Map<String, dynamic>> uploads = [];
  List<Map<String, dynamic>> likes = [];
  late bool isLoggedIn;
  late bool isLike;
  late UserInfo user;
  final GalleryController _galleryController = GalleryController();
  late final UserController userController ;
  late final ItemController itemController;
  late final SocialController socialController;

  @override
  void initState() {
    super.initState();
    isLike = true;
    userController = UserController(apiClient: widget.apiClient);
    itemController = ItemController(apiClient: widget.apiClient);
    socialController = SocialController(apiClient: widget.apiClient);
    isLoggedIn= widget.apiClient.islogin();
    _loadUser();
    _loadLikes();
    _loadUploads();
  }
  Future<void> _loadUser() async {
    final UserInfo u = widget.apiClient.getUserInfo();  
    setState(() => user = u);
  }
  Future<void> _loadLikes() async {
    final data = await _galleryController.getOutfits(status: 'Like'); 

  setState(() {
    likes = data;
  });
  }
  Future<void> _loadUploads() async {
    if (!isLoggedIn) return;
    final data = await itemController.fetchMyPosts(); 
    setState(() => uploads = data);
  }
void _openLikeDetail(Map<String, dynamic> item) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => LikedOutfitDetailScreen(
        data: item,
        socialController: socialController,
      ),
    ),
  );
  final data = await _galleryController.getOutfits(status: 'Like');
  setState(() {
    likes = data;
  });
}
void _openUploadDetail(Map<String, dynamic> item) async {
  await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => UploadOutfitDetailScreen(
        data: item,
        itemController: itemController,
      ),
    ),
  );
  await _loadUploads();
  setState(() {
  });
}
void _onUploadTap(BuildContext context) async {
  // 로그인 확인
  if (!isLoggedIn) {
    final wantsLogin = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('로그인이 필요합니다'),
        content: const Text('로그인 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
    if (wantsLogin != true) return;

    final didLogin = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(userController: userController),
      ),
    );
    if (didLogin != true) return;

    setState(() {
      isLoggedIn = true;
    });
    await _loadUser();
    await _loadUploads();
  }

  await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => ClosetsScreen(forupload: true, itemController: itemController),
    ),
  );
  await _loadUploads();
  setState(() {});
}

@override
Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isLoggedIn ? user.username : '게스트',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey),
            // 탭
            Row(
              children: [
                _buildTab(
                  title: '좋아요한 게시물',
                  isSelected: isLike,
                  onTap: () => setState(() => isLike = true),
                ),
                _buildTab(
                  title: '업로드한 게시물',
                  isSelected: !isLike,
                  onTap: () => setState(() => isLike = false),
                ),
              ],
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isLike
                  ? _buildLikesGrid()
                  : isLoggedIn
                      ? _buildUploadsGrid()
                      : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '로그인이 필요한 서비스입니다.\n로그인하시겠습니까?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                final didLogin = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(userController: userController),
                                  ),
                                );
                                if (didLogin == true) {
                                  setState(() {
                                    isLoggedIn = true;
                                  });
                                  await _loadUser();    
                                  await _loadUploads(); 
                                }
                              },
                              child: const Text('로그인하기'),
                            ),
                          ],
                        ),
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onUploadTap(context),
        child: Icon(Icons.upload_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Color selectedColor = const Color.fromARGB(255, 182, 27, 220),
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isSelected ? selectedColor : Colors.transparent, width: 2),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: ClosetLikeGrid(
            items: likes,
            onTap: _openLikeDetail,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: ClosetUrlGrid(
            items: uploads,
            onTap: _openUploadDetail,
          ),
        ),
      ],
    );
  }}
