import 'package:file/file.dart';
import 'package:fonts2yaml/ioc/get_it_registrations.dart';
import 'package:fonts2yaml/yaml/yaml_facade.dart';

void main(List<String> commandLineArgs) {
  setupIoc();
  final fs = getIt<FileSystem>();
  final yamlFacade = YamlFacade(fs);
  yamlFacade.run(commandLineArgs);
}
