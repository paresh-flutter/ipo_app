import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/ipo_repository.dart';
import 'ipo_event.dart';
import 'ipo_state.dart';

class IpoBloc extends Bloc<IpoEvent, IpoState> {
  final IpoRepository _repository;

  IpoBloc(this._repository) : super(IpoInitial()) {
    on<LoadAllIpos>(_onLoadAllIpos);
    on<LoadIposByStatus>(_onLoadIposByStatus);
    on<SearchIpos>(_onSearchIpos);
    on<SearchIposByStatus>(_onSearchIposByStatus);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadAllIpos(
    LoadAllIpos event,
    Emitter<IpoState> emit,
  ) async {
    emit(IpoLoading());
    try {
      final ipos = await _repository.getAllIpos();
      emit(IpoLoaded(ipos: ipos));
    } catch (e) {
      emit(IpoError('Failed to load IPOs: ${e.toString()}'));
    }
  }

  Future<void> _onLoadIposByStatus(
    LoadIposByStatus event,
    Emitter<IpoState> emit,
  ) async {
    emit(IpoLoading());
    try {
      final ipos = await _repository.getIposByStatus(event.status);
      emit(IpoLoaded(ipos: ipos));
    } catch (e) {
      emit(IpoError('Failed to load IPOs: ${e.toString()}'));
    }
  }

  Future<void> _onSearchIpos(
    SearchIpos event,
    Emitter<IpoState> emit,
  ) async {
    emit(IpoLoading());
    try {
      final ipos = await _repository.searchIpos(event.query);
      emit(IpoLoaded(
        ipos: ipos,
        isSearching: event.query.isNotEmpty,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(IpoError('Failed to search IPOs: ${e.toString()}'));
    }
  }

  Future<void> _onSearchIposByStatus(
    SearchIposByStatus event,
    Emitter<IpoState> emit,
  ) async {
    emit(IpoLoading());
    try {
      final ipos = await _repository.searchIposByStatus(event.query, event.status);
      emit(IpoLoaded(
        ipos: ipos,
        isSearching: event.query.isNotEmpty,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(IpoError('Failed to search IPOs: ${e.toString()}'));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<IpoState> emit,
  ) async {
    emit(IpoLoading());
    try {
      final ipos = await _repository.getAllIpos();
      emit(IpoLoaded(ipos: ipos));
    } catch (e) {
      emit(IpoError('Failed to load IPOs: ${e.toString()}'));
    }
  }
}
