import 'dart:collection';
import 'dart:convert';
import 'package:file/file.dart';
import 'package:fonts2yaml/infrastructure/infrastructure.dart';
import 'package:fonts2yaml/model/model.dart';

class Bootstrapper {
  Bootstrapper(this.fs);

  FileSystem fs;

  Fonts2YamlRequest? run(List<String> commandLineArgs) {
    final _bootstrapper = _Bootstrapper(fs);

    return _bootstrapper.run(commandLineArgs);
  }
}

class _Bootstrapper {
  _Bootstrapper(this.fs);

  FileSystem fs;

  Fonts2YamlRequest? initialize(List<String> commandLineArgs, String pubspecYamlFileName) {
    final configFileName = Path.combine([fs.currentDirectory.path, Constants.configFileName]);
    var trialRun = false;
    bool? commandLineTrialRun;
    var topLevelFontPaths = <String>[];
    var fontFileExtensions = <String>['.ttf', '.oft'];

    for (var arg in commandLineArgs) {
      if (arg == '-h' || arg == '--help') {
        printUsage();
        return null;
      } else if (arg == '-c' || arg == '--createEmptyConfig') {
        createConfigFile(configFileName);
        return null;
      } else if (arg == '-t' || arg == '--trialRun') {
        commandLineTrialRun = true;
      } else if (arg.startsWith('-')) {
        Log.Error('');
        Log.Error('Unknown option flag $arg');
        Log.Error('  Use option flag -h to view all available options.');
        Log.Error('');
        return null;
      } else {
        topLevelFontPaths.add(arg);
      }
    }

    if (fs.file(configFileName).existsSync()) {
      final configJson = fs.file(configFileName).readAsStringSync();
      var fonts2yamlConfig = Fonts2YamlConfig.fromJson(configJson);
      if (topLevelFontPaths.isNotEmpty) {
        var folders = [...topLevelFontPaths, ...fonts2yamlConfig.topLevelFontPaths];
        topLevelFontPaths = folders.toSet().toList();
        topLevelFontPaths.sort();
      }
      if (fonts2yamlConfig.fontFileExtensions != null && fonts2yamlConfig.fontFileExtensions!.isNotEmpty) {
        var extensions = [...fontFileExtensions, ...fonts2yamlConfig.fontFileExtensions!];
        fontFileExtensions = extensions.toSet().toList();
      }
    }

    if (topLevelFontPaths.isEmpty) {
      topLevelFontPaths.add('assets');
    }

    if (!validateDirectoryEntires(topLevelFontPaths)) {
      return null;
    }

    var unmodifiableTopLevelFontFullPaths = UnmodifiableListView(topLevelFontPaths);

    var fonts2Yaml = Fonts2YamlRequest(
        fontFolderPaths: unmodifiableTopLevelFontFullPaths,
        trialRun: commandLineTrialRun ?? trialRun,
        pubspecYamlFileName: pubspecYamlFileName,
        rootFolderName: fs.currentDirectory.path,
        fontFileExtensions: fontFileExtensions);

    return fonts2Yaml;
  }

  void printUsage() {
    Log.Information('');
    Log.Information('Dart command-line tool that updates the fonts section in the Flutter pubspec.yaml.');
    Log.Information('');
    Log.Information('Usage: fonts2yaml [<top-level font folders>] [<flags>]');
    Log.Information('');
    Log.Information('Top-level font folders:   One or more top-level or root folders where fonts files are.');
    Log.Information('                          If not supplied, defaults to assets.');
    Log.Information('                          If supplied, values will be merged with any config file values.');
    Log.Information('');
    Log.Information('                          Important: do not specify any sub-folder names.');
    Log.Information('');
    Log.Information('Flags:');
    Log.Information('-h, --help                Print this usage information.');
    Log.Information('-c, --createEmptyConfig   Creates a default fonts2yaml.json file, does not update pubspec.yaml.');
    Log.Information('-t, --trialRun            Runs and writes font entries to console instead of pubspec.yaml.');
    Log.Information('');
    Log.Information('Font Extensions:');
    Log.Information('    By default, the tool looks for .ttf, and .oft font files.');
    Log.Information('    Additional font extensions can be added to the config file.');
    Log.Information('');
    Log.Information('Config file:');
    Log.Information('    Using a config file simplifies running fonts2yaml as no command line args are required.');
    Log.Information('    Using config file ensures the same results across team developers.');
    Log.Information('');
  }

  Fonts2YamlRequest? run(List<String> commandLineArgs) {
    Log.Information('');

    final pubspecYamlFileName = '${fs.currentDirectory.path}\\pubspec.yaml';

    if (!fs.file(pubspecYamlFileName).existsSync()) {
      Log.Error('Current folder is not a Flutter application.');
      Log.Error('File Not Found: $pubspecYamlFileName');
      Log.Error('');
      return null;
    }

    final fonts2YamlRequest = initialize(commandLineArgs, pubspecYamlFileName);
    if (fonts2YamlRequest == null) {
      return null;
    }

    return fonts2YamlRequest;
  }

  bool validateDirectoryEntires(List<String> topLevelFontFullPaths) {
    for (var i = 0; i < topLevelFontFullPaths.length; i++) {
      final fullPath = Path.combine([fs.currentDirectory.path, topLevelFontFullPaths[i]]);
      final exists = fs.directory(fullPath).existsSync();
      if (!exists) {
        Log.Error('Directory not found: $fullPath');
        Log.Error('');
        return false;
      }
    }
    return true;
  }

  void createConfigFile(String configFileName) {
    if (fs.file(configFileName).existsSync()) {
      Log.Warning('');
      Log.Warning('$configFileName already exists, this application will not overwrite an existing file.');
      Log.Warning('To create a new config file, first delete the current config file and rerun this app with the -c flag.');
      Log.Warning('');
      return;
    }

    final fonts2Yaml = Fonts2YamlConfig(topLevelFontPaths: ['assets'], fontFileExtensions: ['.ttf', '.oft']);
    final json = jsonDecode(fonts2Yaml.toJson());
    final formattedJson = JsonEncoder.withIndent('  ').convert(json);
    fs.file(configFileName).writeAsStringSync(formattedJson);
    Log.Information('');
    Log.Information('$configFileName created, you can edit as desired.');
    Log.Information('');
  }
}
