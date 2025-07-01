import 'package:flutter/material.dart';
import 'package:new_flutter_app/widget/_user_widget.dart';
import '../utils/api_client.dart';
import '../controllers/SocialController.dart';
import '../helpers/database_helper.dart';
class SocialScreen extends StatefulWidget {
  final ApiClient apiClient;

  const SocialScreen({
    Key? key,
    required this.apiClient,
  }) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  late final PageController pageController;
  late final SocialController socialController;
  final DatabaseHelper db = DatabaseHelper.instance;


  List<Map<String, dynamic>> uploads = [];


  final Map<int, Map<String, String?>> pendingLikes = {};


  final Set<int> likedPostIdsInUi = {};

  int page = 0;
  final int pageSize = 20;
  bool isLoading = false;
  bool hasMore = true;
  String selectedSort = "recent";

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    socialController = SocialController(apiClient: widget.apiClient);
    _loadMoreSets();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreSets() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    final newFiles = await socialController.fetchPosts(
      sort: selectedSort,
      page: page,
      size: pageSize,
    );

    setState(() {
      uploads.addAll(newFiles);
      page += 1;
      isLoading = false;
      if (newFiles.length < pageSize) hasMore = false;
    });
  }

  void saveAllPendingLikesToDb() {
    for (final entry in pendingLikes.entries) {
      final postId = entry.key;
      final paths = entry.value;
      db.insertLikedtOutfit(
        topPath: paths['topPath']!,
        bottomPath: paths['bottomPath']!,
        jacketPath: paths['jacketPath'],
        shoesPath: paths['shoesPath']!,
        postid: postId,
      );
      socialController.toggleLike(postId);
    }
    pendingLikes.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ToggleButtons(
              isSelected: [
                selectedSort == "recent",
                selectedSort == "likes",
              ],
              onPressed: (int index) {
                String newSort;
                if (index == 0) {
                  newSort = "recent";
                } else {
                  newSort = "likes";
                } 
                if (newSort != selectedSort) {
                  setState(() {
                    selectedSort = newSort;
                    uploads.clear();
                    page = 0;
                    hasMore = true;
                  });
                  _loadMoreSets();
                }
              },
              borderRadius: BorderRadius.circular(8),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text("최신순")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text("좋아요순")),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              pageSnapping: true,
              itemCount: uploads.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == uploads.length) {
                  _loadMoreSets();
                  return const Center(child: CircularProgressIndicator());
                }

                final item = uploads[index];
                final postId     = item['id'] as int;
                final topPath    = item['top_image_url']    as String;
                final bottomPath = item['bottom_image_url'] as String;
                final shoesPath  = item['shoes_image_url']   as String;
                final jacketPath = item['jacket_image_url']  as String?;
                final authorName = (item['author_name'] as String?) ?? '익명';
                final baseLikes  = (item['like_count'] as int?) ?? 0;

                final hasJacket = jacketPath != null;

                final isLikedInUi = likedPostIdsInUi.contains(postId);
                final displayLikes = baseLikes + (isLikedInUi ? 1 : 0);

                final outfitWidget = hasJacket
                    ? ClosetUrlContainerJacket(
                        topPath: topPath,
                        bottomPath: bottomPath,
                        jacketPath: jacketPath,
                        shoesPath: shoesPath,
                      )
                    : ClosetUrlContainerNoJacket(
                        topPath: topPath,
                        bottomPath: bottomPath,
                        shoesPath: shoesPath,
                      );

                return Stack(
                  children: [
                    Column(
                      children: [
                        Material(
                          elevation: 2,
                          child: Container(
                            height: kToolbarHeight,
                            color: Theme.of(context).primaryColor,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.person, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authorName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: outfitWidget,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            backgroundColor: isLikedInUi
                                ? Colors.red
                                : Colors.grey.shade300,
                            child: Icon(
                              isLikedInUi
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isLikedInUi
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isLikedInUi) {
                                  likedPostIdsInUi.remove(postId);
                                  pendingLikes.remove(postId);
                                } else {
                                  likedPostIdsInUi.add(postId);

                                  pendingLikes[postId] = {
                                    'topPath': topPath,
                                    'bottomPath': bottomPath,
                                    'jacketPath': jacketPath,
                                    'shoesPath': shoesPath,
                                  };
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            child: Text(
                              '$displayLikes',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}