part of 'blog_list_bloc.dart';

@immutable
sealed class BlogListBlocEvent {}

class AppOpenEvent extends BlogListBlocEvent {}

class RefreshScreenEvent extends BlogListBlocEvent {}

class MakeBlogFavoriteEvent extends BlogListBlocEvent {
  final String blogModelId;
  MakeBlogFavoriteEvent({required this.blogModelId});
}
