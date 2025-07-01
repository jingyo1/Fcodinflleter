import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../widget/_closet_widget.dart';
import '../controllers/ItemController.dart';

class ClosetsScreen extends StatefulWidget {
  final bool forupload;
  final ItemController? itemController;

  ClosetsScreen({
    Key? key,
    this.forupload = false,
    this.itemController,
  }) : super(key: key);

  final DatabaseHelper db = DatabaseHelper.instance;

  @override
  _ClosetsScreenState createState() => _ClosetsScreenState();
}

class _ClosetsScreenState extends State<ClosetsScreen> {
  List<Map<String, dynamic>> outfits = [];

  @override
  void initState() {
    super.initState();
    loadOutfits();
  }

  Future<void> loadOutfits() async {
    final data = await widget.db.getOutfits(status: 'Save');
    setState(() => outfits = data);
  }

  void _openDetail(Map<String, dynamic> outfitData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OutfitDetailScreen(
          data: outfitData,
          forupload: widget.forupload,
          itemController: widget.itemController,
          onDelete: loadOutfits,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ClosetGrid(
          items: outfits,
          onTap: _openDetail,
        ),
      ),
    );
  }
}

class OutfitDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onDelete;
  final bool forupload; 
  final ItemController? itemController; 
  final DatabaseHelper db = DatabaseHelper.instance;

  OutfitDetailScreen({
    Key? key,
    required this.data,
    this.onDelete,
    this.forupload = false,
    required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedset = data;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: savedset['jacket_path'] != null
                ? ClosetContainerJacket(
                    topPath: savedset['top_path'] as String,
                    bottomPath: savedset['bottom_path'] as String,
                    jacketPath: savedset['jacket_path'] as String,
                    shoesPath: savedset['shoes_path'] as String,
                  )
                : ClosetContainerNoJacket(
                    topPath: savedset['top_path'] as String,
                    bottomPath: savedset['bottom_path'] as String,
                    shoesPath: savedset['shoes_path'] as String,
                  ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: forupload ? 'upload_outfit' : 'delete_outfit',
              mini: true,
              onPressed: () async {
                if (forupload) {
                  // ✅ 업로드 로직
                  final result = await itemController!.uploadImageSet(outfitId: savedset['id']);
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('업로드 성공!')),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('업로드 실패')),
                    );
                  }
                } else {
                  // ✅ 삭제 로직
                  final id = data['id'] as int?;
                  if (id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('유효하지 않은 ID입니다.')),
                    );
                    return;
                  }
                  final result = await db.deleteOutfitById(id);
                  if (result > 0) {
                    onDelete?.call();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('삭제에 실패했습니다.')),
                    );
                  }
                }
              },
              child: Icon(forupload ? Icons.upload : Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}