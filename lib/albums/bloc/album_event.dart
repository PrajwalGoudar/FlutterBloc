import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AlbumFetched extends AlbumEvent {}
