import 'package:flutter/material.dart';
import 'package:movietrack/list_widget/movie_card.dart'; // Assuming you already have this widget

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key}) : super(key: key);

  @override
  _MyListPageState createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 Tabs
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMovieListView(),
                _buildMovieListView(),
                _buildMovieListView(),
                _buildMovieListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable method to build the movie list view
  Widget _buildMovieListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10, // Replace with your dynamic data count
      itemBuilder: (context, index) {
        return MovieCard(
          title: 'Lorem Ipsum Dolor Sit Amet ${index + 1}',
          year: 2000 + index,
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 16),
    );
  }
}
