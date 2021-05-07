import 'package:file/file.dart';
import 'package:fonts2yaml/infrastructure/log.dart';
import 'package:fonts2yaml/yaml/bootstrapper.dart';
import 'package:fonts2yaml/yaml/pubspec_editor.dart';
import 'package:fonts2yaml/yaml/yaml_maker.dart';

class YamlFacade {
  YamlFacade(this.fs);

  final FileSystem fs;

  void run(List<String> commandLineArgs) {
    final bootstrapper = Bootstrapper(fs);
    final fonts2YamlRequest = bootstrapper.run(commandLineArgs);
    if (fonts2YamlRequest == null) {
      return;
    }

    final yamlMaker = YamlMaker(fs);
    final yamlLines = yamlMaker.run(fonts2YamlRequest);
    if (yamlLines == null || yamlLines.isEmpty) {
      return;
    }

    if (fonts2YamlRequest.trialRun) {
      for (var line in yamlLines) {
        Log.Information(line);
      }
      return;
    }

    final pubspecEditor = PubspecEditor(fs);
    pubspecEditor.run(fonts2YamlRequest, yamlLines);
  }
}
