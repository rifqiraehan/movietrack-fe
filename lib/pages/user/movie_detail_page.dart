import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final int? movieId;

  const MovieDetailPage({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MovieTrack',
          style: TextStyle(
            color: Color(0xFFE6E0E9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFE6E0E9),
        ),
        backgroundColor: const Color(0xFF4F378B),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Hello World\nMovie ID: ${movieId ?? 'No ID'}'),
      ),
    );
  }
}