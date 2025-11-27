import 'package:ditonton/presentation/provider/index_nav_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_series_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<IndexNavNotifier>().indexBottomNavBar,
        onTap: (index) {
          context.read<IndexNavNotifier>().setIndextBottomNavBar = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: "Movie",
            tooltip: "Movie",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: "tv",
            tooltip: "tv",
          ),
        ],
      ),
      body: Consumer<IndexNavNotifier>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            1 => TvSeriesPage(),
            _ => HomeMoviePage(),
          };
        },
      ),
    );
  }
}
