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
  bool isLoading = false; // Flag to track if data is loading
  final TextEditingController _controller = TextEditingController();

  // Function to handle search
  void _handleSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      isSearching = true;
    });

    try {
      final results = await Movie.search(query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch search results')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSearching) {
          setState(() {
            isSearching = false;
            _controller.clear();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isSearching
                      ? _buildSearchResults()
                      : _buildRecommendationList(),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
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
          year: movie.releaseDate.isNotEmpty ? int.parse(movie.releaseDate.substring(0, 4)) : 0,
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
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 12),
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