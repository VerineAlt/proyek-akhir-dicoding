import 'package:ditonton/presentation/bloc/tv_list/tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_list.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_state.dart';

import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    // Trigger the fetch event on page load
    Future.microtask(() =>
        context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Listen to the specific Cubit state
        child: BlocBuilder<PopularTvSeriesBloc, TvSeriesState>(
          builder: (context, state) {
            if (state is TvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvSeriesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('No Data'),
              );
            }
          },
        ),
      ),
    );
  }
}