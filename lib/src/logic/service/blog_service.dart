import 'package:flutter_blog_explorer/src/data/api/blog_api.dart';
import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:flutter_blog_explorer/src/logic/service/hive_service/hive_keys_constants.dart';
import 'package:flutter_blog_explorer/src/logic/service/hive_service/hive_service.dart';
import 'package:flutter_blog_explorer/src/utils/custom_exception.dart';

class BlogService {
  static final BlogService _instance = BlogService._internal();
  BlogService._internal();
  factory BlogService() {
    return BlogService._instance;
  }
  final BlogApi _blogApi = BlogApi();
  final HiveService _hiveService = HiveService();

  Future<List<BlogModel>> fetchBlogs() async {
    try {
      final res = await _blogApi.getBlogs();
      if (res != null) {
        // write the serielizing logic
        List<BlogModel> list = [];
        final data = res['blogs'];
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

  Future<List<BlogModel>> getBlogsAndSaveLocally() async {
    try {
      final list = await fetchBlogs();
      await removeBlogsLocally();
      await writeBlogsLocally(list);
      return list;
    } on CustomException {
      rethrow;
    } catch (err, errStack) {
      print(
          'Error in BlogRepository getBlogsAndSaveLocally $err\nErrorStack:$errStack');
    }
    return [];
  }

  /// in fetchBlogsLocally function
  /// if isFavorite = true, then return favorite blogs
  /// if isFavorite = false, then return only the non favorite blog
  /// if the isFavorite is null, returns all
  Future<List<BlogModel>> fetchBlogsLocally({bool? isFavorite}) async {
    try {
      final List<dynamic>? res = await _hiveService.getData(
              HiveBoxKeysConstants.blogListBox,
              HiveBlogListBoxKeys.blogsKey.name) ??
          [];
      final List<BlogModel> list = List.from(res as List<dynamic>);
      return list.where((e) {
        if (isFavorite == null) {
          return true;
        }
        return e.isFavorite == isFavorite;
      }).toList();
    } catch (err, errStack) {
      print(
          'Error in BlogRepository fetchBlogsLocally $err\nErrorStack:$errStack');
    }
    return [];
  }

  /// this function overwrites the data inside the box
  /// preserveFavorites - use to save the favorites from getting overwrites
  Future<void> writeBlogsLocally(List<BlogModel> list,
      [bool preserveFavorites = true]) async {
    try {
      List<BlogModel> updateList = [];
      if (preserveFavorites) {
        final favorites = await fetchBlogsLocally(isFavorite: true);
        final List<String> favString = favorites.map((e) => e.id).toList();
        updateList = list.map((e) {
          if (favString.contains(e.id)) {
            return e.copyWith(isFavorite: true);
          }
          return e;
        }).toList();
      } else {
        updateList = list;
      }
      await _hiveService.putData(HiveBoxKeysConstants.blogListBox,
          HiveBlogListBoxKeys.blogsKey.name, List<BlogModel>.from(updateList));
    } catch (err, errStack) {
      print(
          'Error in BlogRepository writeBlogsLocally $err\nErrorStack:$errStack');
    }
  }

  Future<void> removeBlogsLocally([bool all = false]) async {
    try {
      if (all) {
        _hiveService.deleteKeyValue(HiveBoxKeysConstants.blogListBox,
            HiveBlogListBoxKeys.blogsKey.name);
        return;
      }
      final favorites = await fetchBlogsLocally(isFavorite: true);
      await writeBlogsLocally(favorites);
    } catch (err, errStack) {
      print(
          'Error in BlogRepository writeBlogsLocally $err\nErrorStack:$errStack');
    }
  }
}
