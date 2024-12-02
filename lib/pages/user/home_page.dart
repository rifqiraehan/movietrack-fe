import 'package:flutter/material.dart';
import 'package:movietrack/list_widget/review_card.dart';
import 'package:movietrack/providers/review_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await reviewProvider.fetchReviews();
            },
            child: reviewProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reviewProvider.errorMessage.isNotEmpty
                    ? Center(child: Text(reviewProvider.errorMessage))
                    : reviewProvider.reviews.isEmpty
                        ? const Center(child: Text("No reviews available"))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: reviewProvider.reviews.length,
                            itemBuilder: (context, index) {
                              final review = reviewProvider.reviews[index];
                              return ReviewCard(
                                title: review.movieTitle,
                                reviewText: review.body,
                                reviewerImage: review.userPfp,
                                username: review.userName,
                                date: review.date,
                                movieId: review.movieId, // Pass movieId to ReviewCard
                                recMsg: review.recMsg, // Pass recMsg to ReviewCard
                              );
                            },
                          ),
          );
        },
      ),
    );
  }
}