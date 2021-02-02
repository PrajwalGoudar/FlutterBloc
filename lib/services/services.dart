import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_albums/albums/models/album.dart';

abstract class Albums {
  Future<List<Album>> fetchAlbums();
}

const _albumLimit = 20;

class AlbumService implements Albums {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';
  static const fetch_albums = '/albums';

  @override
  Future<List<Album>> fetchAlbums([int startIndex = 0]) async {
    String uri =
        baseUrl + fetch_albums + '?_start=$startIndex&_limit=$_albumLimit';
    Response response = await Dio().get(uri);
    List<Album> albums = albumFromJson(json.encode(response.data));
    return albums;
  }
}
