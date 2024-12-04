import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movietrack/models/watchlist.dart';
import 'package:movietrack/models/review.dart';
import 'package:movietrack/models/movie.dart';

class EditWatchlistPage extends StatefulWidget {
  final Watchlist watchlist;

  const EditWatchlistPage({Key? key, required this.watchlist})
      : super(key: key);

  @override
  _EditWatchlistPageState createState() => _EditWatchlistPageState();
}

class _EditWatchlistPageState extends State<EditWatchlistPage> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedStatus = 1;
  int _selectedScore = 1;
  String _movieTitle = '';
  int? _reviewId;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
    _selectedStatus = widget.watchlist.statusId;
    _selectedScore = widget.watchlist.score;
    _reviewController.text = ''; // Fetch and set the review text if available
    _fetchReview();
  }

  Future<void> _fetchReview() async {
    try {
      final review = await Review.fetchReview(widget.watchlist.movieId);
      setState(() {
        _reviewController.text = review.body.isNotEmpty ? review.body : '';
        _reviewId = review.id;
      });
    } catch (e) {
      // If there's no review or another issue, leave the review field empty
      _reviewController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No review found or failed to load: $e')),
      );
    }
  }

  Future<void> _fetchMovieDetails() async {
    try {
      final movie = await Movie.fetchDetails(widget.watchlist.movieId);
      setState(() {
        _movieTitle = movie.title;
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch movie details: $e')),
      );
    }
  }

  Future<void> _saveWatchlist() async {
    final reviewText = _reviewController.text.trim();

    try {
      // Edit existing watchlist
      await Watchlist.editWatchlist(
          widget.watchlist.id, _selectedStatus, _selectedScore);

      if (reviewText.isNotEmpty && _reviewId != null) {
        // Edit existing review
        await Review.editReview(_reviewId!, reviewText);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Watchlist updated successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update watchlist: $e')),
      );
    }
  }

  Future<void> _deleteWatchlist() async {
    try {
      // Delete review if it exists
      if (_reviewId != null) {
        await Review.deleteReview(_reviewId!);
      }

      // Delete watchlist
      await Watchlist.deleteWatchlist(widget.watchlist.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Watchlist deleted successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete watchlist: $e')),
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
          child: Column(
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
                      "Edit Watchlist",
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
                          value: (_selectedScore >= 1 && _selectedScore <= 10)
                              ? _selectedScore
                              : 1,
                          items:
                              List.generate(10, (index) => (index + 1).toInt())
                                  .map((score) => DropdownMenuItem(
                                        value: score,
                                        child: Text(score.toString()),
                                      ))
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedScore = value;
                              });
                            }
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
                        const Divider(),
                        // Delete Button
                        TextButton.icon(
                          onPressed: _deleteWatchlist,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            "Hapus Movie dalam Watchlist",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
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
          color: _selectedStatus == statusId
              ? const Color(0xFF4F378B)
              : Colors.grey[300],
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