import 'package:flutter/material.dart';
import 'package:movietrack/models/review.dart';
import 'package:movietrack/models/movie.dart';
import 'package:movietrack/list_widget/review_card_without_title.dart';

class ReviewMoviePage extends StatelessWidget {
  final int movieId;

  const ReviewMoviePage({Key? key, required this.movieId}) : super(key: key);

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
      body: FutureBuilder<Movie>(
        future: Movie.fetchDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final movie = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: Text(
                    'Review ${movie.title}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Review>>(
                    future: Review.fetchReviewsForMovie(movieId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No reviews available'));
                      } else {
                        final reviews = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return ReviewCardWithoutTitle(
                              reviewText: review.body,
                              reviewerImage: review.userPfp,
                              username: review.userName,
                              date: review.date,
                              movieId: review.movieId,
                              recMsg: review.recMsg,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}