import 'package:flutter/material.dart';

class ReviewCardDetail extends StatelessWidget {
  final String reviewText;
  final String reviewerImage;
  final String username;
  final String date;
  final String recMsg;

  const ReviewCardDetail({
    Key? key,
    required this.reviewText,
    required this.reviewerImage,
    required this.username,
    required this.date,
    required this.recMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          // Handle on tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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