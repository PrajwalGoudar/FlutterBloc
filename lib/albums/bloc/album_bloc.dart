import 'package:flutter_albums/albums/bloc/album_event.dart';
import 'package:flutter_albums/albums/bloc/album_state.dart';
import 'package:flutter_albums/albums/models/album.dart';
import 'package:flutter_albums/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'album_event.dart';

const _albumLimit = 20;

class AlbumsBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumService albumService;
  List<Album> albums;

  AlbumsBloc(this.albumService) : super(const AlbumState());

  @override
  Stream<Transition<AlbumEvent, AlbumState>> transformEvents(
    Stream<AlbumEvent> events,
    TransitionFunction<AlbumEvent, AlbumState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<AlbumState> mapEventToState(AlbumEvent event) async* {
    if (event is AlbumFetched) {
      yield await _mapPostFetchedToState(state);
    }
  }

  Future<AlbumState> _mapPostFetchedToState(AlbumState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == AlbumStatus.initial) {
        List<Album> albums = await albumService.fetchAlbums();
        return state.copyWith(
          status: AlbumStatus.success,
          albums: albums,
          hasReachedMax: _hasReachedMax(albums.length),
        );
      }
      final posts = await albumService.fetchAlbums(state.albums.length);
      return posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: AlbumStatus.success,
              albums: List.of(state.albums)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } on Exception {
      return state.copyWith(status: AlbumStatus.failure);
    }
  }

  bool _hasReachedMax(int albumsCount) =>
      albumsCount < _albumLimit ? true : false;
}
