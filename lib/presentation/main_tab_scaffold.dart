import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'explore/explore_screen.dart';
import 'trips/trips_screen.dart';
import 'wishlist/wishlist_screen.dart';
import 'profile/profile_screen.dart';

class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({super.key});

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();
}

class _MainTabScaffoldState extends State<MainTabScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const TripsScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) => setState(() => _currentIndex = index),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              selectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: Text('Explore')),
                NavigationRailDestination(icon: Icon(Icons.business_center_outlined), selectedIcon: Icon(Icons.business_center), label: Text('Trips')),
                NavigationRailDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: Text('Wishlist')),
                NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explore'),
                BottomNavigationBarItem(icon: Icon(Icons.business_center_outlined), activeIcon: Icon(Icons.business_center), label: 'Trips'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Wishlist'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
    );
  }
}
