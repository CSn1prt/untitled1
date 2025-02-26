import 'package:flutter/material.dart';

class OneScreen extends StatelessWidget {
  const OneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OneScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2열로 박스 배치
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 8, // 원하는 박스의 개수
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // 박스를 탭했을 때의 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Box ${index + 1} tapped!')),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Box ${index + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
