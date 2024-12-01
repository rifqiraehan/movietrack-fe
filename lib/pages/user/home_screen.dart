import 'package:flutter/material.dart';
import 'package:movietrack/pages/user/home_page.dart';
import 'package:movietrack/pages/user/discover_page.dart';
import 'package:movietrack/pages/user/my_list_page.dart';
import 'package:movietrack/pages/user/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:movietrack/providers/review_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<int> _navigationStack = [0]; // Stack to keep track of navigation history

  final List<Widget> _pages = const [
    HomePage(),
    DiscoverPage(),
    MyListPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReviewProvider>(context, listen: false).fetchReviews();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _navigationStack.add(index); // Add the selected index to the stack
    });
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        _navigationStack.removeLast(); // Remove the current page from the stack
        _selectedIndex = _navigationStack.last; // Set the selected index to the previous page
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _selectedIndex != 3
            ? AppBar(
                title: const Text(
                  'MovieTrack',
                  style: TextStyle(color: Color(0xFFE6E0E9), fontSize: 22, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF4F378B),
                centerTitle: true,
              )
            : null,
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF4F378B),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Discover"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "My List"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}