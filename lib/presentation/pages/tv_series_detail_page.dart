import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv/detail';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // 1. Fetch Detail & Recommendations
      context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
      // 2. Check Watchlist Status
      context.read<TvSeriesDetailBloc>().add(LoadWatchlistStatusTv(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. Listen to BLoC State
      body: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
        // CRITICAL: Prevent rebuilds when watchlist events happen
        buildWhen: (previous, current) {
          return current is TvSeriesDetailLoading ||
              current is TvSeriesDetailHasData ||
              current is TvSeriesDetailError;
        },
        builder: (context, state) {
          if (state is TvSeriesDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvSeriesDetailHasData) {
            final tvSeries = state.tvSeriesDetail;
            return SafeArea(
              child: DetailContent(
                tvSeries,
                state.tvSeriesRecommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state is TvSeriesDetailError) {
            return Text(state.message);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// Changed to StatefulWidget to handle local UI updates for Watchlist
class DetailContent extends StatefulWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tvSeries, this.recommendations, this.isAddedWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  late bool isAddedWatchlist;

  @override
  void initState() {
    super.initState();
    isAddedWatchlist = widget.isAddedWatchlist;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 4. Listen for Watchlist Side Effects
    return BlocListener<TvSeriesDetailBloc, TvSeriesDetailState>(
      listener: (context, state) {
        if (state is WatchlistStatusLoaded) {
          setState(() {
            isAddedWatchlist = state.isAddedToWatchlist;
          });
        } else if (state is WatchlistActionSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          
          // Immediate toggle for UI responsiveness
          setState(() {
            isAddedWatchlist = !isAddedWatchlist;
          });

          // Reload status from DB to ensure consistency
          context
              .read<TvSeriesDetailBloc>()
              .add(LoadWatchlistStatusTv(widget.tvSeries.id));
        } else if (state is WatchlistActionError) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.message),
                );
              });
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://image.tmdb.org/t/p/w500${widget.tvSeries.posterPath}',
            width: screenWidth,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tvSeries.name, 
                                style: kHeading5,
                              ),
                              FilledButton(
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    context
                                        .read<TvSeriesDetailBloc>()
                                        .add(AddWatchlistTv(widget.tvSeries));
                                  } else {
                                    context
                                        .read<TvSeriesDetailBloc>()
                                        .add(RemoveWatchlistTv(widget.tvSeries));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                              Text(
                                _showGenres(widget.tvSeries.genres),
                              ),
                              Text(
                                '${widget.tvSeries.numberOfSeasons} Seasons • ${widget.tvSeries.numberOfEpisodes} Episodes',
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.tvSeries.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${widget.tvSeries.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                widget.tvSeries.overview,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              
                              // Recommendations List (Direct usage)
                              _buildRecommendationsList(context, widget.recommendations),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              minChildSize: 0.25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kRichBlack,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper to keep build method clean
  Widget _buildRecommendationsList(BuildContext context, List<TvSeries> recommendations) {
    if (recommendations.isEmpty) {
      return Container();
    }
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                  placeholder: (context, url) =>
                      Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                  errorWidget:
                      (context, url, error) =>
                          Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: recommendations.length,
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}