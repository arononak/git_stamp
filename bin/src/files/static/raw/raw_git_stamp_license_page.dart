const rawGitStampLicensePage = '''
import 'package:flutter/material.dart';

import '../../git_stamp.dart';

void showGitStampLicensePage({
  required BuildContext context,
  bool useRootNavigator = false,
}) {
  showLicensePage(
    context: context,
    applicationName: GitStamp.appName,
    applicationVersion: '\${GitStamp.appVersion} (\${GitStamp.appBuild})',
    useRootNavigator: useRootNavigator,
  );
}
''';