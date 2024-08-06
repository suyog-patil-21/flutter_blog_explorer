import 'package:flutter_blog_explorer/src/data/api/blog_api.dart';
import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:flutter_blog_explorer/src/utils/custom_exception.dart';

class BlogRepository {
  static final BlogRepository _instance = BlogRepository._internal();
  BlogRepository._internal();
  factory BlogRepository() {
    return BlogRepository._instance;
  }
  final BlogApi _blogApi = BlogApi();

  Future<List<BlogModel>> fetchBlogs() async {
    try {
      final res = await _blogApi.getBlogs();
      if (res != null) {
        // wriet the serielizing logic
        List<BlogModel> list = [];
        final  data = res['blogs'];
        for (int i = 0; i < data.length; i++) {
          list.add(BlogModel.fromMap(data[i]));
        }
        return list;
      }
    } on CustomException {
      rethrow;
    } catch (err, errStack) {
      print('Error in BlogRepository fetchBlogs $err\nErrorStack:$errStack');
    }
    return [];
  }
}
