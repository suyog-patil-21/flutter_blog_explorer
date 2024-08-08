import 'dart:convert';
import 'dart:io';

import 'package:flutter_blog_explorer/src/utils/custom_exception.dart';
import 'package:http/http.dart' as http;

class BlogApi {
  static final BlogApi _instance = BlogApi._internal();
  BlogApi._internal();
  factory BlogApi() {
    return BlogApi._instance;
  }
  Future<Map<String, dynamic>?> getBlogs() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    try {
      final res = await http.get(Uri.parse(url), headers: {
        "x-hasura-admin-secret":
            "32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6",
      });
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        print(res.statusCode);
        print(res.body);
      }
    } on SocketException catch (err) {
      print('Error in BlogApi getBlogs SocketException:$err');
      throw CustomException(CustomExceptionMessage.noInternet.name);
    } on HttpException catch (err) {
      print('Error in BlogApi getBlogs HttpException:$err');
      throw CustomException(CustomExceptionMessage.canNotFindData.name);
    } catch (err, errStack) {
      print('Error in BlogApi getBlogs $err\nErrorStack:$errStack');
      throw CustomException(CustomExceptionMessage.somethingWhenWorng.name);
    }
    return null;
  }
}
