import 'package:flutter/material.dart';

class ReviewCardDetail extends StatelessWidget {
  final String title;
  final String reviewText;
  final String reviewerImage;
  final String username;
  final String date;

  const ReviewCardDetail({
    Key? key,
    required this.title,
    required this.reviewText,
    required this.reviewerImage,
    required this.username,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                reviewText,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const Divider(height: 16, thickness: 1),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(reviewerImage),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}