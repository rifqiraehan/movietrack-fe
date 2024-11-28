import 'package:flutter/material.dart';
import 'package:movietrack/list_widget/review_card.dart';
import 'package:movietrack/models/review.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Review>>(
        future: Review.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load reviews"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reviews available"));
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(
                  title: review.movieTitle,
                  reviewText: review.body,
                  reviewerImage: review.userPfp,
                  username: review.userName,
                  date: review.date,
                );
              },
            );
          }
        },
      ),
    );
  }
}