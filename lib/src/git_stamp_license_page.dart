// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'package:flutter/material.dart';

import 'git_stamp_node.dart';

/// The [GitStampLicenseIcon] class used when we want to go to the licensing screen.
///
/// Below that the [showLicensePage] function from [material] is used.
/// Additionally, information from pubspec.yaml is added.
class GitStampLicenseIcon extends StatelessWidget {
  const GitStampLicenseIcon({
    super.key,
    required this.gitStamp,
    this.applicationIcon,
    this.applicationLegalese,
  });

  /// The [GitStampNode] class contains information provided during generation.
  final GitStampNode gitStamp;

  /// Usually a company logo.
  final Widget? applicationIcon;

  /// Example: `© Aron Code 2024. All rights reserved.`.
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

/// The [showGitStampLicensePage] function shows the license screen.
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
