import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:flutter_blog_explorer/src/logic/bloc/blog_list_bloc/blog_list_bloc.dart';
import 'package:flutter_blog_explorer/src/ui/screens/detail_blog_view_screen.dart';
import 'package:flutter_blog_explorer/src/utils/dimensioins.dart';

class BlogListScreen extends StatefulWidget {
  static const String route = '/';
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlogListBloc>().add(AppOpenEvent());
  }

  @override
  Widget build(BuildContext context) {
    final vpW = getViewportWidth(context);
    final vpH = getViewportHeight(context);
    return BlocListener<BlogListBloc, BlogListBlocState>(
        listener: (context, bloglistState) async {
          if (bloglistState is BlogListBlocFailedState) {
            await showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Text(bloglistState.customException.message),
                    title: const Text('Error'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok'))
                    ],
                  );
                });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Blogs and Articles'),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              final BlogListBloc bloc = context.read<BlogListBloc>();
              if (bloc.state is BlogListBlocLoadingState) return;
              bloc.add(RefreshScreenEvent());
              return Future.delayed(const Duration(milliseconds: 700));
            },
            child: BlocBuilder<BlogListBloc, BlogListBlocState>(
                builder: (context, bloglistState) {
              if (bloglistState is BlogListBlocLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              List<BlogModel> blogList = [];
              if (bloglistState is BlogListBlocInitialState ||
                  bloglistState is BlogListBlocFailedState) {
                blogList = [];
              } else {
                blogList = (bloglistState as BlogListBlocLoadedState).list;
              }
              if (blogList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_off, size: vpH * 0.12),
                      Text(
                        'No Blogs',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      FilledButton(
                          onPressed: () {
                            final BlogListBloc bloc =
                                context.read<BlogListBloc>();
                            if (bloc.state is BlogListBlocLoadingState) return;
                            bloc.add(RefreshScreenEvent());
                          },
                          child: const Text('Retry'))
                    ],
                  ),
                );
              }
              return ListView.builder(
                  itemCount: blogList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(vpW * 0.01),
                      width: double.infinity,
                      height: vpH * 0.35,
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              DetailBlogViewScreen.route,
                              arguments: DetailBlogViewScreenParameters(
                                blogModel: blogList[index],
                              ),
                            );
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Image.network(
                                          blogList[index].imageUrl,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            iconSize: vpH * 0.04,
                                            onPressed: () {
                                              context.read<BlogListBloc>().add(
                                                  MakeBlogFavoriteEvent(
                                                      blogModelId:
                                                          blogList[index].id));
                                            },
                                            icon: Icon(
                                                blogList[index].isFavorite
                                                    ? CupertinoIcons.heart_solid
                                                    : CupertinoIcons.heart),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        blogList[index].title,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                      ),
                                    )),
                              ]),
                        ),
                      ),
                    );
                  });
            }),
          ),
        ));
  }
}
