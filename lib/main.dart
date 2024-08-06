import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_explorer/src/app.dart';
import 'package:flutter_blog_explorer/src/logic/bloc/blog_list_bloc/blog_list_bloc.dart';
import 'package:flutter_blog_explorer/src/utils/bloc_observer.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  final BlogListBloc blogListBloc = BlogListBloc();
  runApp(MyApp(
    blogListBloc: blogListBloc,
  ));
}
