import 'package:flutter/material.dart';
import 'package:movietrack/models/movie.dart';
import 'package:movietrack/pages/user/review_movie_page.dart';
import 'package:movietrack/list_widget/recs_card.dart';

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
                                            .map((word) => word.length > 9
                                                ? '${word.substring(0, 8)}.'
                                                : word)
                                            .take(2)
                                            .join('\n') ??
                                        'N/A',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigate to the review page
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ReviewMoviePage(movieId: movie.id),
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 147, 147, 147),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Lihat Review',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mungkin anda suka',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                    // Recommendation list with recs card
                    Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder<List<Movie>>(
                      future: Movie.fetchRecsID(movieId),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No recommendations available.'));
                      } else {
                        final recommendations = snapshot.data!;
                        return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendations.length,
                          itemBuilder: (context, index) {
                          final movie = recommendations[index];
                          return RecsCard(movie: movie);
                          },
                        ),
                        );
                      }
                      },
                    ),
                    ),
              ]),
            );
          }
        },
      ),
    );
  }
}