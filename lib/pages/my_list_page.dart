import 'package:flutter/material.dart';

class MyListPage extends StatelessWidget {
  const MyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "My List Page",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}