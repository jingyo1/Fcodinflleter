import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../widget/_closet_widget.dart';

class ClosetsScreen extends StatefulWidget {
  final bool forupload;
  ClosetsScreen({
    Key? key,
    this.forupload = false,
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
  final DatabaseHelper db = DatabaseHelper.instance;

  OutfitDetailScreen({
    Key? key,
    required this.data,
    this.onDelete,
    this.forupload = false,
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
        ],
      ),
    );
  }
}