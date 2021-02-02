import 'package:flutter/material.dart';
import 'package:flutter_albums/albums/bloc/album_bloc.dart';
import 'package:flutter_albums/albums/bloc/album_event.dart';
import 'package:flutter_albums/albums/bloc/album_state.dart';
import 'package:flutter_albums/widgets/album_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumsPage extends StatefulWidget {
  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  final _scrollController = ScrollController();
  AlbumsBloc _albumsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _albumsBloc = context.read<AlbumsBloc>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _albumsBloc.add(AlbumFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Albums',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: BlocBuilder<AlbumsBloc, AlbumState>(
          builder: (BuildContext context, AlbumState state) {
        switch (state.status) {
          case AlbumStatus.failure:
            return const Center(child: Text('Failed to fetch albums'));
          case AlbumStatus.success:
            if (state.albums.isEmpty) {
              return const Center(child: Text('No albums'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.albums.length
                    ? Center(child: CircularProgressIndicator())
                    : AlbumCard(
                        state.albums[index].id, state.albums[index].title);
              },
              itemCount: state.hasReachedMax
                  ? state.albums.length
                  : state.albums.length + 1,
              controller: _scrollController,
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
