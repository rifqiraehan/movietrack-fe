import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movietrack/models/watchlist.dart';
import 'package:movietrack/models/review.dart';
import 'package:movietrack/models/movie.dart';

class AddWatchlistPage extends StatefulWidget {
  final int movieId;

  const AddWatchlistPage({Key? key, required this.movieId}) : super(key: key);

  @override
  _AddWatchlistPageState createState() => _AddWatchlistPageState();
}

class _AddWatchlistPageState extends State<AddWatchlistPage> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedStatus = 1;
  int _selectedScore = 1;
  String _movieTitle = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    try {
      final movie = await Movie.fetchDetails(widget.movieId);
      setState(() {
        _movieTitle = movie.title;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch movie details: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveWatchlist() async {
    final reviewText = _reviewController.text.trim();

    try {
      // Add new watchlist
      await Watchlist.addToWatchlist(widget.movieId, _selectedStatus, _selectedScore);

      if (reviewText.isNotEmpty) {
        // Add new review
        await Review.addReview(widget.movieId, reviewText);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Watchlist added successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add watchlist: $e')),
      );
    }
  }

  void _closePage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Custom AppBar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFBDBDBD), width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon Close (X)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: _closePage,
                          ),
                          // Title
                          const Text(
                            "Add to Watchlist",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          // Save Button
                          InkWell(
                            onTap: _saveWatchlist,
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4F378B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Form and other content
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              // Movie Title
                              Text(
                                _movieTitle,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              // Status Section
                              const Text(
                                "Status",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                children: [
                                  _buildStatusBadge(1, "Watching"),
                                  _buildStatusBadge(2, "Completed"),
                                  _buildStatusBadge(3, "Dropped"),
                                  _buildStatusBadge(4, "Planned"),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Score Section
                              const Text(
                                "Score",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              DropdownButton<int>(
                                value: _selectedScore,
                                items: List.generate(10, (index) => (index + 1).toInt())
                                    .map((score) => DropdownMenuItem(
                                          value: score,
                                          child: Text(score.toString()),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedScore = value!;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              // Review Section
                              const Text(
                                "Review",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _reviewController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Write your review here...",
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int statusId, String statusText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = statusId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedStatus == statusId ? const Color(0xFF4F378B) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          statusText,
          style: TextStyle(
            color: _selectedStatus == statusId ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}