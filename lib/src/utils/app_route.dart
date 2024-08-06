import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/src/ui/screens/blog_list_screen.dart';
import 'package:flutter_blog_explorer/src/ui/screens/detail_blog_view_screen.dart';

class AppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == BlogListScreen.route) {
      return MaterialPageRoute(builder: (context) => const BlogListScreen());
    } else if (settings.name == DetailBlogViewScreen.route) {
      final DetailBlogViewScreenParameters parameters =
          settings.arguments as DetailBlogViewScreenParameters;
      return MaterialPageRoute(
          builder: (context) => DetailBlogViewScreen(
                parameters: parameters,
              ));
    } else {
      return MaterialPageRoute(builder: (context) => const BlogListScreen());
    }
  }
}

class UnknowPage extends StatelessWidget {
  const UnknowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page Not Found'),
      ),
    );
  }
}
