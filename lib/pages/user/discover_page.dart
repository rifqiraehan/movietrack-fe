import 'package:flutter/material.dart';
import 'package:movietrack/models/movie.dart';
import 'package:movietrack/list_widget/movie_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<Movie> searchResults = [];
  bool isSearching = false; // Flag to track if search is active
  final TextEditingController _controller = TextEditingController();

  // Function to handle search
  void _handleSearch(String query) async {
    if (query.isEmpty) return;

    try {
      final results = await Movie.search(query);
      setState(() {
        searchResults = results;
        isSearching = true; // Show search results
      });
    } catch (e) {
      // Handle errors or show a message to the user
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(
            child: isSearching ? _buildSearchResults() : _buildRecommendationList(),
          ),
        ],
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        onSubmitted: _handleSearch, // Trigger search on 'Enter'
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
  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    return ListView.separated(
      itemCount: searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final movie = searchResults[index];
        return MovieCard(
          title: movie.title,
          year: int.parse(movie.releaseDate.split('-')[0]),
          posterPath: movie.posterPath,
        );
      },
    );
  }

  // Build recommendation list
  Widget _buildRecommendationList() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSectionTitle('Movie Recommendations'),
                const SizedBox(height: 10),
                _buildMovieList(),
                _buildSectionTitle('Popular'),
                const SizedBox(height: 10),
                _buildMovieList(),
                _buildSectionTitle('Top Rated'),
                const SizedBox(height: 10),
                _buildMovieList(),
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

  // Dummy Movie List for Recommendations
  Widget _buildMovieList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Replace with real data count if available
        itemBuilder: (context, index) {
          return _buildMovieCard();
        },
      ),
    );
  }

  Widget _buildMovieCard() {
    return Container(
      width: 95,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 135,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lorem Ipsum',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
