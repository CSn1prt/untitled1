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
          //Text(widget.title, style: const TextStyle(fontSize: 18)), // Use widget.title to access the title
          //let's put account info  or logo on this part.
          Expanded(
            child: SearchBar(
              hintText: 'Search',
              leading: const Icon(Icons.search),
              onTap: () {
                // Handle search bar tap
              },
              onChanged: (value) {
                // Handle search bar text change
              },
            ),
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