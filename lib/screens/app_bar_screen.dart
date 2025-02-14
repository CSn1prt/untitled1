import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
                onPressed: _toggleSearch,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isSearchExpanded
                    ? MediaQuery.of(context).size.width * 0.6
                    : 0,
                curve: Curves.easeInOut,
                child: _isSearchExpanded
                    ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '검색하기',
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                )
                    : const SizedBox(),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // 알림 아이콘 동작 추가
            },
          ),
        ],
      ),
    );
  }
}
