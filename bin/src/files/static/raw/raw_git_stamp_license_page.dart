const rawGitStampLicensePage = '''
import 'package:flutter/material.dart';

import '../../git_stamp.dart';

void showGitStampLicensePage({
  required BuildContext context,
  Widget? applicationIcon,
  String? applicationLegalese,
  bool useRootNavigator = false,
}) {
  showLicensePage(
    context: context,
    applicationName: GitStamp.appName,
    applicationVersion: '\${GitStamp.appVersion} (\${GitStamp.appBuild})',
    applicationIcon: applicationIcon,
    applicationLegalese: applicationLegalese,
    useRootNavigator: useRootNavigator,
  );
}

class GitStampLicenseIcon extends StatelessWidget {
  const GitStampLicenseIcon(
    this.applicationIcon,
    this.applicationLegalese,
  );

  final Widget? applicationIcon;
  final String? applicationLegalese;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showGitStampLicensePage(
          context: context,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
        );
      },
      icon: const Icon(Icons.gavel),
    );
  }
}
''';
