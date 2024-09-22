extension BoolExtension on bool {
  String get enabled => this ? '' : '//';
}

String rawGitStamp(bool generateFlutterFiles) => '''
library git_stamp;
 
export 'git_stamp_node.dart';

${generateFlutterFiles.enabled}export 'src/data/git_stamp_commit.dart';
${generateFlutterFiles.enabled}export 'src/ui/git_stamp_details_page.dart';
${generateFlutterFiles.enabled}export 'src/ui/git_stamp_launcher.dart';
${generateFlutterFiles.enabled}export 'src/ui/git_stamp_page.dart';
${generateFlutterFiles.enabled}export 'src/ui/git_stamp_utils.dart';
${generateFlutterFiles.enabled}export 'src/ui/git_stamp_icon.dart';
${generateFlutterFiles.enabled}export 'src/ui/git_stamp_list_tile.dart';

${generateFlutterFiles.enabled}import 'src/ui/is_lite_version.dart';
import './git_stamp_tool_version.dart';

${generateFlutterFiles.enabled}const bool isLiteVersion = gitStampIsLiteVersion;
const String gitStampVersion = gitStampToolVersion;
''';
