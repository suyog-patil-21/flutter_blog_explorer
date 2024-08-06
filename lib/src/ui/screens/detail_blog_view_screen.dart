import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:flutter_blog_explorer/src/logic/bloc/blog_list_bloc/blog_list_bloc.dart';
import 'package:flutter_blog_explorer/src/utils/dimensioins.dart';

class DetailBlogViewScreen extends StatelessWidget {
  static const String route = '/detail-article';
  final DetailBlogViewScreenParameters parameters;
  const DetailBlogViewScreen({super.key, required this.parameters});

  @override
  Widget build(BuildContext context) {
    final vpW = getViewportWidth(context);
    final vpH = getViewportHeight(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(parameters.blogModel.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: vpH * 0.2,
              width: double.infinity,
              margin: EdgeInsets.all(vpW * 0.01),
              child: Center(
                child: Image.network(
                  parameters.blogModel.imageUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      parameters.blogModel.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(
                    width: vpW * 0.1,
                    height: vpW * 0.1,
                    child: BlocBuilder<BlogListBloc, BlogListBlocState>(
                        builder: (context, state) {
                      if (state is! BlogListBlocLoadedState) {
                        return Container();
                      }
                      return IconButton(
                        iconSize: vpH * 0.04,
                        onPressed: () {
                          context.read<BlogListBloc>().add(
                              MakeBlogFavoriteEvent(
                                  blogModelId: parameters.blogModel.id));
                        },
                        icon: Icon(state.list
                                .firstWhere(
                                    (e) => e.id == parameters.blogModel.id)
                                .isFavorite
                            ? CupertinoIcons.heart_solid
                            : CupertinoIcons.heart),
                        color: Theme.of(context).colorScheme.primary,
                      );
                    }),
                  )
                ],
              ),
            ),
            const Divider(),
            const Text('Blog content'),
          ],
        ),
      ),
    );
  }
}

class DetailBlogViewScreenParameters {
  final BlogModel blogModel;

  const DetailBlogViewScreenParameters({required this.blogModel});
}
