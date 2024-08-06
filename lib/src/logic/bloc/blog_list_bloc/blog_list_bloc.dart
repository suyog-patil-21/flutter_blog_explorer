import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:flutter_blog_explorer/src/logic/repository/blog_repository.dart';
import 'package:flutter_blog_explorer/src/utils/custom_exception.dart';
import 'package:meta/meta.dart';

part 'blog_list_event.dart';
part 'blog_list_state.dart';

class BlogListBloc extends Bloc<BlogListBlocEvent, BlogListBlocState> {
  final BlogRepository _blogRepository = BlogRepository();
  BlogListBloc() : super(BlogListBlocInitialState()) {
    on<AppOpenEvent>(onAppOpenEventHandler);
    on<RefreshScreenEvent>(onRefreshScreenEventHandler);
    on<MakeBlogFavoriteEvent>(onMakeBlogFavouriteEventHandler);
  }

  Future<void> fetchBlogHandler(Emitter<BlogListBlocState> emit) async {
    try {
      emit(BlogListBlocLoadingState());
      final result = await _blogRepository.fetchBlogs();
      if (result.isNotEmpty) {
        emit(BlogListBlocLoadedState(result));
      } else {
        emit(BlogListBlocLoadedState(const []));
      }
    } on CustomException catch (er) {
      emit(BlogListBlocFailedState(er));
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
      MakeBlogFavoriteEvent event, Emitter<BlogListBlocState> emit) async {
    if (state is! BlogListBlocLoadedState) return;
    final List<BlogModel> list = (state as BlogListBlocLoadedState).list;
    if (list.isEmpty) return;
    emit(BlogListBlocLoadedState(list.map((e) {
      if (e.id == event.blogModelId) {
        return e.copyWith(isFavorite: !e.isFavorite);
      } else {
        return e;
      }
    }).toList()));
  }
}
