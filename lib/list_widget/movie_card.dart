import 'package:flutter/material.dart';
import 'package:movietrack/pages/user/movie_detail_page.dart';

class MovieCard extends StatelessWidget {
  final int id;
  final String title;
  final int year;
  final String posterPath;

  const MovieCard({
    Key? key,
    required this.id,
    required this.title,
    required this.year,
    required this.posterPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(movieId: id),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container without padding
            Container(
              width: 95,
              height: 135,
              color: Colors.grey[300],
              child: posterPath.isNotEmpty
                  ? Image.network(
                      posterPath,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
            // Padding only on the text content
            const SizedBox(width: 16), // Space between image and text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      year.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}