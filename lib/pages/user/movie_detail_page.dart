import 'package:flutter/material.dart';
import 'package:movietrack/models/movie.dart';
import 'package:movietrack/models/watchlist.dart';
import 'package:movietrack/pages/user/add_watchlist_page.dart';
import 'package:movietrack/pages/user/edit_watchlist_page.dart';
import 'package:movietrack/pages/user/review_movie_page.dart';
import 'package:movietrack/list_widget/recs_card.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Future<Map<String, dynamic>> _fetchMovieAndWatchlist() async {
    final movieFuture = Movie.fetchDetails(widget.movieId);
    final watchlistFuture = Watchlist.fetchWatchlist();

    final results = await Future.wait([movieFuture, watchlistFuture]);

    final movie = results[0] as Movie;
    final watchlists = results[1] as List<Watchlist>;
    try {
      final watchlist = watchlists.firstWhere((watchlist) => watchlist.movieId == widget.movieId);
      print('Watchlist found: $watchlist');
      return {'movie': movie, 'watchlist': watchlist};
    } catch (e) {
      print('Watchlist not found for movieId: ${widget.movieId}');
      return {'movie': movie, 'watchlist': null};
    }
  }

  Future<void> _refreshWatchlist() async {
    setState(() {});
  }

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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchMovieAndWatchlist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final movie = snapshot.data!['movie'] as Movie;
            final watchlist = snapshot.data!['watchlist'] as Watchlist?;

            return Stack(
              children: [
                SingleChildScrollView(
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
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
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
                            'Mungkin Anda Suka',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Recommendation list with recs card
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<List<Movie>>(
                          future: Movie.fetchRecsID(widget.movieId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No recommendations available.'));
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
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => watchlist == null
                              ? AddWatchlistPage(movieId: widget.movieId)
                              : EditWatchlistPage(watchlist: watchlist),
                        ),
                      );
                      if (result == true) {
                        _refreshWatchlist(); // Refresh the state to update the FAB
                      }
                    },
                    backgroundColor: const Color(0xFF4F378B),
                    child: Icon(watchlist == null ? Icons.add : Icons.edit, color: Colors.white),
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