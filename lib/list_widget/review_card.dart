import 'package:flutter/material.dart';
import 'package:movietrack/pages/user/movie_detail_page.dart';

class ReviewCard extends StatelessWidget {
  final String title;
  final String reviewText;
  final String reviewerImage;
  final String username;
  final String date;
  final int movieId;
  final String recMsg;

  const ReviewCard({
    Key? key,
    required this.title,
    required this.reviewText,
    required this.reviewerImage,
    required this.username,
    required this.date,
    required this.movieId,
    required this.recMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(movieId: movieId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                reviewText,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                  const Spacer(),
                    Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                    color: recMsg == "Recommended"
                      ? Colors.green
                      : recMsg == "Not Recommended"
                        ? Colors.red
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                    recMsg,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}