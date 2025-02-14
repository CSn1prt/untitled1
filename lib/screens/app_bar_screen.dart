import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0), // 로고 아이콘 여백 조절
        child: Image.asset(
          'assets/images/resized_icon.png',  // 로고 이미지 경로
          width: 28,  // 추천 크기
          height: 28, // 추천 크기
          fit: BoxFit.contain, // 크기 조절
        ),
      ),
      title: _isSearchExpanded
          ? AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width * 0.6,
        curve: Curves.easeInOut,
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '검색하기',
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
      )
          : null, // 기본 제목 제거

      actions: [
        IconButton(
          icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // 알림 아이콘 동작 추가
          },
        ),
      ],
    );
  }
}
