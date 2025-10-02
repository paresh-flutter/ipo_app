import 'package:equatable/equatable.dart';
import '../models/ipo_model.dart';

abstract class IpoState extends Equatable {
  const IpoState();

  @override
  List<Object?> get props => [];
}

class IpoInitial extends IpoState {}

class IpoLoading extends IpoState {}

class IpoLoaded extends IpoState {
  final List<IpoModel> ipos;
  final bool isSearching;
  final String searchQuery;

  const IpoLoaded({
    required this.ipos,
    this.isSearching = false,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [ipos, isSearching, searchQuery];

  IpoLoaded copyWith({
    List<IpoModel>? ipos,
    bool? isSearching,
    String? searchQuery,
  }) {
    return IpoLoaded(
      ipos: ipos ?? this.ipos,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class IpoError extends IpoState {
  final String message;

  const IpoError(this.message);

  @override
  List<Object?> get props => [message];
}
