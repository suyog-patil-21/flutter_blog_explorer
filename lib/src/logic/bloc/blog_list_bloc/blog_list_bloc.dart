import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:flutter_blog_explorer/src/logic/service/blog_service.dart';
import 'package:flutter_blog_explorer/src/utils/custom_exception.dart';
import 'package:meta/meta.dart';

part 'blog_list_event.dart';
part 'blog_list_state.dart';

class BlogListBloc extends Bloc<BlogListBlocEvent, BlogListBlocState> {
  final BlogService _blogService = BlogService();
  BlogListBloc() : super(BlogListBlocInitialState()) {
    on<AppOpenEvent>(onAppOpenEventHandler);
    on<RefreshScreenEvent>(onRefreshScreenEventHandler);
    on<AddRemoveBlogFavoriteEvent>(onMakeBlogFavouriteEventHandler);
    on<BlogListFailedEvent>(onBlogListFailedEventHandler);
    on<ToggleFilterFavoritesEvent>(onToggleFilterFavoritesEventHandler);
  }

  Future<void> _saveBlogListLocally() async {
    if (state is! BlogListBlocLoadedState) return;
    final BlogListBlocLoadedState currentSaveState =
        (state as BlogListBlocLoadedState);
    await _blogService.writeBlogsLocally(currentSaveState.list);
  }

  Future<void> onBlogListFailedEventHandler(
      BlogListFailedEvent event, Emitter<BlogListBlocState> emit) async {
    emit(BlogListBlocFailedState(event.customException));
    if (event.customException.message ==
        CustomExceptionMessage.noInternet.name) {
      final List<BlogModel> result = await _blogService.fetchBlogsLocally();
      if (result.isNotEmpty) {
        emit(BlogListBlocLoadedState(result, isLocal: true));
      } else {
        emit(BlogListBlocLoadedState(const []));
      }
    }
  }

  Future<void> fetchBlogHandler(Emitter<BlogListBlocState> emit) async {
    try {
      emit(BlogListBlocLoadingState());
      final List<BlogModel> result =
          await _blogService.getBlogsAndSaveLocally();
      if (result.isNotEmpty) {
        emit(BlogListBlocLoadedState(result));
      } else {
        emit(BlogListBlocLoadedState(const []));
      }
    } on CustomException catch (er) {
      add(BlogListFailedEvent(er));
    }
  }

  void onAppOpenEventHandler(
      AppOpenEvent event, Emitter<BlogListBlocState> emit) async {
    await fetchBlogHandler(emit);
  }

  void onRefreshScreenEventHandler(
      RefreshScreenEvent event, Emitter<BlogListBlocState> emit) async {
    await fetchBlogHandler(emit);
  }

  void onMakeBlogFavouriteEventHandler(
      AddRemoveBlogFavoriteEvent event, Emitter<BlogListBlocState> emit) async {
    if (state is! BlogListBlocLoadedState) return;
    final loadedState = state as BlogListBlocLoadedState;
    final List<BlogModel> list = (state as BlogListBlocLoadedState).list;
    if (list.isEmpty) return;
    emit(loadedState.copyWith(
        list: list.map((e) {
      if (e.id == event.blogModel.id) {
        return e.copyWith(isFavorite: !e.isFavorite);
      } else {
        return e;
      }
    }).toList()));
    _saveBlogListLocally();
  }

  void onToggleFilterFavoritesEventHandler(
      ToggleFilterFavoritesEvent event, Emitter<BlogListBlocState> emit) {
    if (state is! BlogListBlocLoadedState) return;
    final loadedState = state as BlogListBlocLoadedState;
    emit(loadedState.copyWith(filterFavorites: !loadedState.filterFavorites));
  }
}
