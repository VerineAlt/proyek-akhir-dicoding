import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv getWatchlistTv;

  WatchlistTvBloc({required this.getWatchlistTv}) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());

      final result = await getWatchlistTv.execute();
      result.fold(
        (failure) {
          emit(WatchlistTvError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(WatchlistTvEmpty());
          } else {
            emit(WatchlistTvHasData(data));
          }
        },
      );
    });
  }
}