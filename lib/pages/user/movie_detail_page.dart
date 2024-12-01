import 'package:flutter/material.dart';
import 'package:movietrack/models/movie.dart';
import 'package:movietrack/models/review.dart';
import 'package:movietrack/list_widget/review_card_detail.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the FAB
        },
        backgroundColor: const Color(0xFF4F378B),
        child: const Icon(Icons.edit, color: Colors.white),
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top section with poster and additional container
                  Stack(
                    children: [
                      // Extended AppBar container
                      Container(
                        height: 90,
                        color: const Color(0xFF4F378B),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Poster
                              Container(
                                width: 232,
                                height: 330,
                                color: Colors.grey[300],
                                child: movie.posterPath != null
                                    ? Image.network(
                                        movie.posterPath!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image,
                                        size: 50, color: Colors.grey),
                              ),
                              const SizedBox(width: 20),
                              // Score
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Score",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    movie.voteAverage != null
                                        ? '#${movie.voteAverage!.toStringAsFixed(1)}'
                                        : 'N/A',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Studio",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    movie.productionCompany?.name
                                        .split(' ')
                                        .map((word) => word.length > 9 ? '${word.substring(0, 8)}.' : word)
                                        .take(2)
                                        .join('\n') ?? 'N/A',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.end,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Durasi",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${movie.runtime ?? 'N/A'} Menit",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Tahun",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    movie.releaseDate?.substring(0, 4) ?? 'N/A',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Status",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    movie.status ?? 'N/A',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Movie details section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          movie.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Genre
                        Text(
                          movie.genres.map((genre) => genre.name).join(', '),
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        // Overview
                        Text(
                          movie.overview ?? 'No overview available',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  // add divider
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Latest Reviews',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Add review card with horizontal scroll
                  FutureBuilder<List<Review>>(
                    future: Review.fetchReviewsForMovie(movieId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No reviews available'));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final reviews = snapshot.data!;
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width - 32, // Fixed width
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReviewCardDetail(
                                    title: review.movieTitle,
                                    reviewText: review.body,
                                    reviewerImage: review.userPfp,
                                    username: review.userName,
                                    date: review.date,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}