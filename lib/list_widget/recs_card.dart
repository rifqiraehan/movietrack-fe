import 'package:flutter/material.dart';
import 'package:movietrack/models/movie.dart';
import 'package:movietrack/pages/user/movie_detail_page.dart';

class RecsCard extends StatefulWidget {
  final Movie movie;

  const RecsCard({Key? key, required this.movie}) : super(key: key);

  @override
  _RecsCardState createState() => _RecsCardState();
}

class _RecsCardState extends State<RecsCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _isPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  _isPressed = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailPage(movieId: widget.movie.id),
                  ),
                );
              },
              onTapCancel: () {
                setState(() {
                  _isPressed = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: _isPressed ? 130 : 135,
                color: Colors.grey[300],
                child: widget.movie.posterPath?.isNotEmpty == true
                    ? Image.network(
                        widget.movie.posterPath!,
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
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.movie.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}