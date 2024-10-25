import 'package:flutter/material.dart';

import 'git_stamp_node.dart';

void showGitStampLicensePage({
  required BuildContext context,
  required GitStampNode gitStamp,
  Widget? applicationIcon,
  String? applicationLegalese,
  bool useRootNavigator = false,
}) {
  showLicensePage(
    context: context,
    applicationName: gitStamp.appName,
    applicationVersion: '${gitStamp.appVersion} (${gitStamp.appBuild})',
    applicationIcon: applicationIcon,
    applicationLegalese: applicationLegalese,
    useRootNavigator: useRootNavigator,
  );
}

class GitStampLicenseIcon extends StatelessWidget {
  const GitStampLicenseIcon({
    super.key,
    required this.gitStamp,
    this.applicationIcon,
    this.applicationLegalese,
  });

  final GitStampNode gitStamp;
  final Widget? applicationIcon;
  final String? applicationLegalese;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showGitStampLicensePage(
          context: context,
          gitStamp: gitStamp,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
        );
      },
      icon: const Icon(Icons.gavel),
    );
  }
}
