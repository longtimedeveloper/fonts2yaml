import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupIoc() {
  getIt.registerLazySingleton<FileSystem>(() => LocalFileSystem());
}
