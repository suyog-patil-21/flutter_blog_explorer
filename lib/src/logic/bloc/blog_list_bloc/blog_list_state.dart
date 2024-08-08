part of 'blog_list_bloc.dart';

@immutable
sealed class BlogListBlocState {}

final class BlogListBlocInitialState extends BlogListBlocState {}

final class BlogListBlocLoadingState extends BlogListBlocState {}

final class BlogListBlocLoadedState extends BlogListBlocState
    with EquatableMixin {
  final List<BlogModel> list;
  final bool isLocal;
  final bool filterFavorites;
  BlogListBlocLoadedState(this.list,
      {this.filterFavorites = false, this.isLocal = false});

  BlogListBlocLoadedState copyWith(
      {List<BlogModel>? list, bool? isLocal, bool? filterFavorites}) {
    return BlogListBlocLoadedState(list ?? this.list,
        isLocal: isLocal ?? this.isLocal,
        filterFavorites: filterFavorites ?? this.filterFavorites);
  }

  @override
  List<Object> get props => [list, filterFavorites, isLocal];
}

final class BlogListBlocFailedState extends BlogListBlocState
    with EquatableMixin {
  final CustomException customException;
  BlogListBlocFailedState(this.customException);
  @override
  List<Object> get props => [customException];
}
