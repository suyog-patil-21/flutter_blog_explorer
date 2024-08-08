import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:flutter_blog_explorer/src/logic/bloc/blog_list_bloc/blog_list_bloc.dart';
import 'package:flutter_blog_explorer/src/ui/widget/image_widget.dart';
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
        title: Container(),
      ),
      body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: vpW * 0.02),
        child: Column(
          children: [
            Container(
              height: vpH * 0.2,
              width: double.infinity,
              margin: EdgeInsets.all(vpW * 0.01),
              child: Center(
                  child: ImageWidget(imageUrl: parameters.blogModel.imageUrl)),
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
                              AddRemoveBlogFavoriteEvent(
                                  blogModel: parameters.blogModel));
                        },
                        icon: Icon(state.list
                                .firstWhere(
                                    (e) => e.id == parameters.blogModel.id)
                                .isFavorite
                            ? Icons.favorite
                            : Icons.favorite_outline),
                        color: Theme.of(context).colorScheme.primary,
                      );
                    }),
                  )
                ],
              ),
            ),
            const Divider(),
            const Text(blogContent),
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

const String blogContent =
    "Lorem ipsum dolor sit amet. Est omnis neque et sunt illum in cupiditate libero. In totam exercitationem est fuga suscipit sit consequatur cumque vel alias fugiat est assumenda harum. At quibusdam consequatur non itaque quam aut culpa voluptatem aut dolor illo. </p><p>Aut recusandae molestias et odio sint et quia nobis ut reiciendis dolorum eos magnam quisquam ea voluptatem voluptates et voluptatem internos? Qui vitae suscipit sit tempore mollitia est nisi illum. </p><p>Aut voluptas doloremque sed mollitia omnis hic sapiente dolor qui nobis nisi sed ducimus possimus eum explicabo omnis. Qui incidunt ipsum eum suscipit molestias et facere iure sit veniam dolorem ex voluptatem libero et incidunt autem. Ex alias eveniet ea corporis quam aut vero quia. Et laboriosam voluptas ut inventore quaerat aut laudantium adipisci in mollitia corrupti est reiciendis inventore.";
