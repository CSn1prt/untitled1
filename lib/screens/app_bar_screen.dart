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
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
      Icon(Icons.question_mark, size: 28, color: Colors.black),  // 🔥 아이콘으로 대체

              const SizedBox(width: 10), // 로고와 검색창 사이 간격
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5, // 검색창 크기 조절
                child: SearchBar(
                  hintText: '검색어를 입력해 주세요',
                  leading: const Icon(Icons.search),
                  surfaceTintColor: MaterialStateProperty.all<Color>(Colors.transparent), // 그림자 제거
                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent), // 추가적인 그림자 제거
                  onTap: () {},
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
    );
  }
}