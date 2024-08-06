part of 'blog_list_bloc.dart';

@immutable
sealed class BlogListBlocState {}

final class BlogListBlocInitialState extends BlogListBlocState {}

final class BlogListBlocLoadingState extends BlogListBlocState {}

final class BlogListBlocLoadedState extends BlogListBlocState
    with EquatableMixin {
  final List<BlogModel> list;
  BlogListBlocLoadedState(this.list);

  @override
  List<Object> get props => [list];
}

final class BlogListBlocFailedState extends BlogListBlocState
    with EquatableMixin {
  final CustomException customException;
  BlogListBlocFailedState(this.customException);
  @override
  List<Object> get props => [customException];
}
