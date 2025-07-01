import 'dart:io';
import 'package:flutter/material.dart';
typedef OnTapOutfit = void Function(Map<String, dynamic> outfit);
class ClosetGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final OnTapOutfit onTap;

  const ClosetGrid({
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
        final hasJacket = item['jacket_path'] != null;
        final child = hasJacket
            ? ClosetContainerJacket(
                topPath: item['top_path'] as String,
                bottomPath: item['bottom_path'] as String,
                jacketPath: item['jacket_path'] as String,
                shoesPath: item['shoes_path'] as String,
              )
            : ClosetContainerNoJacket(
                topPath: item['top_path'] as String,
                bottomPath: item['bottom_path'] as String,
                shoesPath: item['shoes_path'] as String,
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
class ClosetContainerWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const ClosetContainerWrapper({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// 자켓 있는 컨테이너
class ClosetContainerJacket extends StatelessWidget {
  final String topPath;
  final String bottomPath;
  final String jacketPath;
  final String shoesPath;

  const ClosetContainerJacket({
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
        // 왼쪽: top, bottom, shoes
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
        // 오른쪽: Jacket (가운데 정렬 + 비율 유지)
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
                  child: Image.file(
                    File(jacketPath),
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
          child: Image.file(
            File(path),
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
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
    );
  }
}

/// 자켓 없는 컨테이너
class ClosetContainerNoJacket extends StatelessWidget {
  final String topPath;
  final String bottomPath;
  final String shoesPath;

  const ClosetContainerNoJacket({
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
    child: Image.file(
    File(path),
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
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
    );
  }
}
