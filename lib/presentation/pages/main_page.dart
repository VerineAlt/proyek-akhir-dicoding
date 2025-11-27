import 'package:ditonton/presentation/bloc/home_nav/home_nav_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_series_page.dart'; // Ensure correct import for TV Page

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                // Reset to Movie Tab (0) and close drawer
                context.read<HomeNavCubit>().changeTab(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.live_tv),
              title: Text('TV Series'),
              onTap: () {
                // Switch to TV Tab (1) and close drawer
                context.read<HomeNavCubit>().changeTab(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        // Optional: You can dynamic actions based on tab if needed
      ),
      
      // MAIN BODY LOGIC
      body: BlocBuilder<HomeNavCubit, int>(
        builder: (context, currentIndex) {
          if (currentIndex == 0) {
            return HomeMoviePage();
          } else {
            return TvSeriesPage(); // Ensure this points to your BLoC-migrated TV page
          }
        },
      ),
      
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BlocBuilder<HomeNavCubit, int>(
        builder: (context, currentIndex) {
          return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<HomeNavCubit>().changeTab(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.movie),
                label: 'Movies',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tv),
                label: 'TV Series',
              ),
            ],
          );
        },
      ),
    );
  }
}