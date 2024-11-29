import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final int year;

  const MovieCard({
    Key? key,
    required this.title,
    required this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Container without padding
        Container(
          width: 95,
          height: 135,
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.image,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
        // Padding only on the text content
        const SizedBox(width: 16), // Space between image and text
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  year.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
