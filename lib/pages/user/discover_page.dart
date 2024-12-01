import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movietrack/providers/movie_search_provider.dart';
import 'package:movietrack/providers/movie_recommendations_provider.dart';
import 'package:movietrack/models/movie.dart';
import 'package:movietrack/list_widget/movie_card.dart';
import 'package:movietrack/list_widget/recs_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final movieRecommendationsProvider = Provider.of<MovieRecommendationsProvider>(context, listen: false);
      movieRecommendationsProvider.fetchRecommendations();
      movieRecommendationsProvider.fetchTopRated();
      movieRecommendationsProvider.fetchPopular();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieSearchProvider = Provider.of<MovieSearchProvider>(context);
    final movieRecommendationsProvider = Provider.of<MovieRecommendationsProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (movieSearchProvider.isSearching) {
          movieSearchProvider.resetState();
          _controller.clear();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildSearchBar(movieSearchProvider),
            const SizedBox(height: 16),
            Expanded(
              child: movieSearchProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : movieSearchProvider.isSearching
                      ? _buildSearchResults(movieSearchProvider)
                      : _buildRecommendationList(movieRecommendationsProvider),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar(MovieSearchProvider movieSearchProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        controller: _controller,
        onSubmitted: (query) => movieSearchProvider.searchMovies(query), // Trigger search on 'Enter'
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search',
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Build search results
  Widget _buildSearchResults(MovieSearchProvider movieSearchProvider) {
    if (movieSearchProvider.searchResults.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    return ListView.separated(
      itemCount: movieSearchProvider.searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final movie = movieSearchProvider.searchResults[index];
        return MovieCard(
          id: movie.id,
          title: movie.title,
          year: movie.releaseDate?.isNotEmpty == true ? int.parse(movie.releaseDate!.substring(0, 4)) : 0,
          posterPath: movie.posterPath ?? '',
        );
      },
    );
  }

  // Build recommendation list
  Widget _buildRecommendationList(MovieRecommendationsProvider movieRecommendationsProvider) {
    if (movieRecommendationsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (movieRecommendationsProvider.errorMessage.isNotEmpty) {
      return Center(child: Text(movieRecommendationsProvider.errorMessage));
    } else if (movieRecommendationsProvider.recommendations.isEmpty) {
      return const Center(child: Text('No recommendations available.'));
    }
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSectionTitle('Movie Recommendations'),
                const SizedBox(height: 10),
                _buildMovieList(movieRecommendationsProvider.recommendations),
                _buildSectionTitle('Popular'),
                const SizedBox(height: 10),
                _buildMovieList(movieRecommendationsProvider.topRated),
                _buildSectionTitle('Top Rated'),
                const SizedBox(height: 10),
                _buildMovieList(movieRecommendationsProvider.popular),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Movie List for Recommendations
  Widget _buildMovieList(List<Movie> movies) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return RecsCard(movie: movie);
        },
      ),
    );
  }
}