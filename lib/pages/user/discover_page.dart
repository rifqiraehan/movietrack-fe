import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildSearchBar(),
                  const SizedBox(height: 24),
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
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return TextField(
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

  // Movie List
  Widget _buildMovieList() {
    return SizedBox(
      height: 200, // Height for the horizontal scrollable list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Dummy data count
        itemBuilder: (context, index) {
          return _buildMovieCard();
        },
      ),
    );
  }

  // Reusable Movie Card Widget
  Widget _buildMovieCard() {
    return Container(
      width: 95,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 135,
            color: Colors.grey[300], // Placeholder for the movie image
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
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}