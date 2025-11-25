import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart'; // Contains routeObserver
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart'; // Use TV Watchlist Notifier
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv'; // Define the TV Watchlist route

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

// Mixin RouteAware to listen for screen visibility changes
class _WatchlistTvPageState extends State<WatchlistTvPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is first initialized
    Future.microtask(() =>
        Provider.of<WatchlistTvNotifier>(context, listen: false)
            .fetchWatchlistTv());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the route observer to listen for navigation events
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // This method is called when the route above this one is popped 
  // (e.g., when returning from the TvSeriesDetailPage after adding/removing a series)
  @override
  void didPopNext() {
    // Refresh the watchlist list to reflect the new status
    Provider.of<WatchlistTvNotifier>(context, listen: false)
        .fetchWatchlistTv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Listen to the TV Watchlist Notifier
        child: Consumer<WatchlistTvNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.watchlistTv[index];
                  return TvSeriesCard(tvSeries); // Use the correct TV Series Card widget
                },
                itemCount: data.watchlistTv.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Crucial: Unsubscribe when the widget is destroyed
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}