import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/foundation.dart';

class WatchlistTvNotifier extends ChangeNotifier {
  final GetWatchlistTv getWatchlistTv;
  WatchlistTvNotifier({required this.getWatchlistTv});

  var _watchlistTv = <TvSeries>[];
  List<TvSeries> get watchlistTv => _watchlistTv;

  RequestState _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistTv() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTv.execute();

    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _watchlistTv = data;
        _watchlistState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
