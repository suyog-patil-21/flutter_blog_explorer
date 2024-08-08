import 'package:flutter_blog_explorer/src/data/model/blog_model.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> configHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BlogModelAdapter());
}
