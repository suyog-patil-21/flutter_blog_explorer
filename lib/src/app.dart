import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_explorer/src/logic/bloc/blog_list_bloc/blog_list_bloc.dart';
import 'package:flutter_blog_explorer/src/ui/screens/blog_list_screen.dart';
import 'package:flutter_blog_explorer/src/utils/app_route.dart';

class MyApp extends StatelessWidget {
  final BlogListBloc _blogListBloc;
  const MyApp({super.key, required BlogListBloc blogListBloc})
      : _blogListBloc = blogListBloc;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => _blogListBloc)],
      child: MaterialApp(
        title: 'Blog App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffbb86fc),
            brightness: Brightness.dark,
          ).copyWith(
            primaryContainer: const Color(0xffbb86fc),
            onPrimaryContainer: Colors.black,
            secondaryContainer: const Color(0xff03dac6),
            onSecondaryContainer: Colors.black,
            error: const Color(0xffcf6679),
            onError: Colors.black,
          ),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRoute.generateRoute,
        home: const BlogListScreen(),
      ),
    );
  }
}
