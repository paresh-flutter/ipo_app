import 'package:equatable/equatable.dart';
import '../models/ipo_model.dart';

abstract class IpoEvent extends Equatable {
  const IpoEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllIpos extends IpoEvent {}

class LoadIposByStatus extends IpoEvent {
  final IpoStatus status;

  const LoadIposByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchIpos extends IpoEvent {
  final String query;

  const SearchIpos(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchIposByStatus extends IpoEvent {
  final String query;
  final IpoStatus status;

  const SearchIposByStatus(this.query, this.status);

  @override
  List<Object?> get props => [query, status];
}

class ClearSearch extends IpoEvent {}
