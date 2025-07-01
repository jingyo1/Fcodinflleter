import '../widget/_closet_widget.dart';
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../controllers/ItemController.dart';
import '../controllers/SocialController.dart';

typedef OnTapOutfit = void Function(Map<String, dynamic> outfit);

class ClosetUrlGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final OnTapOutfit onTap;

  const ClosetUrlGrid({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          // 한 줄에 2개
        crossAxisSpacing: 12,       // 가로 간격
        mainAxisSpacing: 12,        // 세로 간격
        childAspectRatio: 3 / 4,    // 가로:세로 비율
      ),
      itemBuilder: (ctx, idx) {
        
        final item = items[idx];
          final topPath    = item['top_image_url']    as String;
          final bottomPath = item['bottom_image_url'] as String;
          final shoesPath  = item['shoes_image_url']  as String;
          final jacketPath = item['jacket_image_url'] as String?; // nullable
        final hasJacket = item['jacket_image_url'] != null;
        final child = hasJacket
            ? ClosetUrlContainerJacket(
                topPath: topPath,
                bottomPath: bottomPath,
                jacketPath: jacketPath!,
                shoesPath: shoesPath,
              )
            : ClosetUrlContainerNoJacket(
                topPath: topPath,
                bottomPath: bottomPath,
                shoesPath: shoesPath,
              );

        return ClosetContainerWrapper(
          onTap: () => onTap(item),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        );
      },
    );
  }
}
class ClosetLikeGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final OnTapOutfit onTap;

  const ClosetLikeGrid({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          
        crossAxisSpacing: 12,       // 가로
        mainAxisSpacing: 12,        // 세로 
        childAspectRatio: 3 / 4,    // 가로:세로 비율
      ),
      itemBuilder: (ctx, idx) {
        
        final item = items[idx];
          final topPath    = item['top_path']    as String;
          final bottomPath = item['bottom_path'] as String;
          final shoesPath  = item['shoes_path']  as String;
          final jacketPath = item['jacket_path'] as String?; // nullable
        final hasJacket = item['jacket_path'] != null;
        final child = hasJacket
            ? ClosetUrlContainerJacket(
                topPath: topPath,
                bottomPath: bottomPath,
                jacketPath: jacketPath!,
                shoesPath: shoesPath,
              )
            : ClosetUrlContainerNoJacket(
                topPath: topPath,
                bottomPath: bottomPath,
                shoesPath: shoesPath,
              );

        return ClosetContainerWrapper(
          onTap: () => onTap(item),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        );
      },
    );
  }
}
/// 자켓 있는 컨테이너
class ClosetUrlContainerJacket extends StatelessWidget {
  final String topPath;
  final String bottomPath;
  final String jacketPath;
  final String shoesPath;

  const ClosetUrlContainerJacket({
    Key? key,
    required this.topPath,
    required this.bottomPath,
    required this.jacketPath,
    required this.shoesPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              // Top
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImage(topPath),
                ),
              ),
              // Bottom
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImage(bottomPath),
                ),
              ),
              // Shoes
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImageShoes(shoesPath),
                ),
              ),
            ],
          ),
        ),
        // 오른쪽: Jacket 
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 4 / 5, 
                  child: Image.network(
                    jacketPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildImage(String path) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 9/10,
          child: Image.network(
            path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
    );
  }
  Widget _buildImageShoes(String path) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 9/5,
          child: Image.network(
            path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
    );
  }
}
/// 자켓 없는 컨테이너
class ClosetUrlContainerNoJacket extends StatelessWidget {
  final String topPath;
  final String bottomPath;
  final String shoesPath;

  const ClosetUrlContainerNoJacket({
    Key? key,
    required this.topPath,
    required this.bottomPath,
    required this.shoesPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              // Top
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImage(topPath),
                ),
              ),
              // Bottom
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImage(bottomPath),
                ),
              ),
              // Shoes
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildImageShoes(shoesPath),
                ),
              ),
            ],
          );
  }
  Widget _buildImage(String path) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
    child: AspectRatio(
    aspectRatio: 9/10,
    child: Image.network(
    path,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    ),
    )
    );
  }
  Widget _buildImageShoes(String path) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 3/2,
          child: Image.network(
            path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
    );
  }
}

class LikedOutfitDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final DatabaseHelper db = DatabaseHelper.instance;
  final bool isLiked = true;
  final SocialController socialController;
  LikedOutfitDetailScreen({super.key, required this.data, required this.socialController});
  @override
  Widget build(BuildContext context) {
    final savedset = data;
    return Scaffold(
      backgroundColor: Colors.white,  
      body: Stack(
        children: [
          // 자켓 여부에 따라 옷 컨테이너 변경
          Center(
            child: savedset['jacket_path'] != null
                ? ClosetUrlContainerJacket(
                    topPath: savedset['top_path'] as String,
                    bottomPath: savedset['bottom_path'] as String,
                    jacketPath: savedset['jacket_path'] as String,
                    shoesPath: savedset['shoes_path'] as String,
                  )
                : ClosetUrlContainerNoJacket(
                    topPath: savedset['top_path'] as String,
                    bottomPath: savedset['bottom_path'] as String,
                    shoesPath: savedset['shoes_path'] as String,
                  ),
          ),
          // 오른쪽 하단에 삭제 버튼
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'dislike_outfit',
              mini: true,
              onPressed: () async {
                final id = savedset['id'] as int?;
                final postid = savedset['postid'] as int;
                if (id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('유효하지 않은 ID입니다.')),
                  );
                  return;
                }
                print('삭제 시도 ID: $id');
                final resultOfDb = await db.deleteOutfitById(id);
                if(socialController.isLogin())
                {
                  await socialController.toggleLike(postid);
                }
                print('삭제 결과: DB = $resultOfDb');
                if (resultOfDb > 0) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('삭제에 실패했습니다.')),
                  );
                }
              },
              child:  Icon(Icons.favorite,
              color: isLiked
                    ? const Color.fromARGB(255, 213, 10, 10)
                    : Colors.grey[300],
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class UploadOutfitDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final DatabaseHelper db = DatabaseHelper.instance;
  final ItemController itemController;
  
  UploadOutfitDetailScreen({super.key, required this.data,required this.itemController});
  @override
  Widget build(BuildContext context) {
    final topUrl    = data['top_image_url']    as String;
    final bottomUrl = data['bottom_image_url'] as String;
    final shoesUrl  = data['shoes_image_url']  as String;
    final jacketUrl = data['jacket_image_url'] as String?; // nullable
    final postId    = data['id']                as int;     // Post ID
    final likeCount = data['like_count']        as int? ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 자켓 유무에 따라 다른 컨테이너
          Center(
            child: (jacketUrl != null && jacketUrl.isNotEmpty)
                ? ClosetUrlContainerJacket(
                    topPath: topUrl,
                    bottomPath: bottomUrl,
                    jacketPath: jacketUrl,
                    shoesPath: shoesUrl,
                  )
                : ClosetUrlContainerNoJacket(
                    topPath: topUrl,
                    bottomPath: bottomUrl,
                    shoesPath: shoesUrl,
                  ),
          ),

          // 오른쪽 하단에 좋아요수
          Positioned(
            bottom: 16 + 56 + 8,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  likeCount.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽 하단의 삭제 버튼
         Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'delete_outfit',
              mini: true,
              onPressed: () async {
                print('삭제 시도 ID: $postId');
                final result =await itemController.deletePost(postId);
                print('삭제 결과: $result');
                if (result == true) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('삭제에 실패했습니다.')),
                  );
                }
              },
              child: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}