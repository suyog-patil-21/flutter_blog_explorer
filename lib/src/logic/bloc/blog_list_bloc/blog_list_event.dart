part of 'blog_list_bloc.dart';

@immutable
sealed class BlogListBlocEvent {}

class AppOpenEvent extends BlogListBlocEvent {}

class RefreshScreenEvent extends BlogListBlocEvent {}

class ToggleFilterFavoritesEvent extends BlogListBlocEvent {}

class BlogListFailedEvent extends BlogListBlocEvent {
  final CustomException customException;
  BlogListFailedEvent(this.customException);
}

class AddRemoveBlogFavoriteEvent extends BlogListBlocEvent {
  final BlogModel blogModel;
  AddRemoveBlogFavoriteEvent({required this.blogModel});
}
