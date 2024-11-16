// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'package:flutter/material.dart';

import 'git_stamp_node.dart';

/// The [GitStampIcon] class used in the application when we want to display an
/// icon with basic build information.
///
/// Such as:
///
///  * [GitStampNode.appVersionFull].
///  * [GitStampNode.buildDateTime],
///  * [GitStampNode.buildBranch].
///  * [GitStampNode.sha].
class GitStampIcon extends StatefulWidget {
  final GitStampNode gitStamp;

  const GitStampIcon({super.key, required this.gitStamp});

  @override
  State<GitStampIcon> createState() => _GitStampIconState();
}

class _GitStampIconState extends State<GitStampIcon> {
  final _tooltipKey = GlobalKey<TooltipState>();
  bool _isTooltipVisible = false;

  void _toggleTooltip() {
    if (_isTooltipVisible) {
      if (mounted) setState(() => _isTooltipVisible = false);
    } else {
      _tooltipKey.currentState?.ensureTooltipVisible();
      if (mounted) setState(() => _isTooltipVisible = true);

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) setState(() => _isTooltipVisible = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: _tooltipKey,
      waitDuration: Duration(days: 1),
      showDuration: Duration(seconds: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      richMessage: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Git Stamp',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          TextSpan(
            text: '\n'
                'Version: ${widget.gitStamp.appVersionFull}\n'
                'Date: ${widget.gitStamp.buildDateTime}\n'
                'Branch: ${widget.gitStamp.buildBranch}\n'
                'SHA: ${widget.gitStamp.sha}',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.developer_board),
        highlightColor: Colors.orange[900],
        onPressed: _toggleTooltip,
      ),
    );
  }
}
