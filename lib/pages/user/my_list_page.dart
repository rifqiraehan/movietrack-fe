import 'package:flutter/material.dart';
import 'package:movietrack/list_widget/movie_watchlist_card.dart';
import 'package:movietrack/models/watchlist.dart';
import 'package:movietrack/models/movie.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key}) : super(key: key);

  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Movie> _watchingList = [];
  List<Movie> _completedList = [];
  List<Movie> _droppedList = [];
  List<Movie> _plannedList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 Tabs
    _fetchWatchlists();
  }

  Future<void> _fetchWatchlists() async {
    setState(() {
      _isLoading = true;
    });

    _watchingList = await _fetchMoviesByStatus(1); // Assuming 1 is the statusId for 'Watching'
    _completedList = await _fetchMoviesByStatus(2); // Assuming 2 is the statusId for 'Completed'
    _droppedList = await _fetchMoviesByStatus(3); // Assuming 3 is the statusId for 'Dropped'
    _plannedList = await _fetchMoviesByStatus(4); // Assuming 4 is the statusId for 'Planned'

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<Movie>> _fetchMoviesByStatus(int statusId) async {
    List<Watchlist> watchlist = await Watchlist.fetchWatchlistByStatus(statusId);
    List<Movie> movies = [];
    for (var item in watchlist) {
      Movie movie = await Movie.fetchDetails(item.movieId);
      movies.add(movie);
    }
    return movies;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Material 3 TabBar with active color and indicator
          Material(
            color: Colors.white, // TabBar background color
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black, // Active tab label color
              unselectedLabelColor: Colors.black.withOpacity(0.6), // Unselected color
              indicatorColor: const Color(0xFF4F378B), // Indicator color (active tab line)
              tabs: const [
                Tab(text: 'Watching'),
                Tab(text: 'Completed'),
                Tab(text: 'Dropped'),
                Tab(text: 'Planned'),
              ],
            ),
          ),
          // Material 3 TabBarView
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMovieListView(_watchingList),
                      _buildMovieListView(_completedList),
                      _buildMovieListView(_droppedList),
                      _buildMovieListView(_plannedList),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Reusable method to build the movie list view
  Widget _buildMovieListView(List<Movie> movies) {
  if (movies.isEmpty) {
    return const Center(
      child: Text('Tidak ada watchlist pada status ini'),
    );
  }
  return ListView.separated(
    itemCount: movies.length,
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(height: 1);
    },
    itemBuilder: (BuildContext context, int index) {
      final movie = movies[index];
      return MovieWatchlistCard(
        id: movie.id,
        title: movie.title,
        year: int.parse(movie.releaseDate?.substring(0, 4) ?? '0'),
        posterPath: movie.posterPath ?? 'https://via.placeholder.com/500',
      );
    },
  );
  }
}