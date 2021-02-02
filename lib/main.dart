import 'package:flutter/material.dart';
import 'package:flutter_albums/albums/bloc/album_bloc.dart';
import 'package:flutter_albums/albums/view/albums_page.dart';
import 'package:flutter_albums/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'albums/bloc/album_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Albums Flutter Bloc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (_) => AlbumsBloc(AlbumService())..add(AlbumFetched()),
        child: AlbumsPage(),
      ),
    );
  }
}
