import 'package:hive/hive.dart';

import 'adapter.dart';

void configureAdapter() {
  Hive.registerAdapter(SourceAdapter());
  Hive.registerAdapter(NewsModelAdapter());
}