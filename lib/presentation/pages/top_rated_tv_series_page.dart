import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    // Trigger the fetch for Top Rated TV series
    Future.microtask(() =>
        Provider.of<TvSeriesListNotifier>(context, listen: false)
            .fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvSeriesListNotifier>(
          builder: (context, data, child) {
            // 1. Check State: Loading
            if (data.topRatedTvState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // 2. Check State: Loaded (Success)
            else if (data.topRatedTvState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.topRatedTv[index];
                  return TvSeriesCard(
                      tvSeries); // Display using your card widget
                },
                itemCount: data.topRatedTv.length,
              );
            }
            // 3. Check State: Error
            else {
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
}
