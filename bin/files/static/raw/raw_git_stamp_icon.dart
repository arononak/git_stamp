const rawGitStampIcon = '''
import 'package:flutter/material.dart';

import '../../git_stamp.dart';

class GitStampIcon extends StatefulWidget {
  const GitStampIcon({Key? key}) : super(key: key);

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
            text: '\$newLine'
                'Version: \${GitStamp.appVersionFull}' '\$newLine'
                'Date: \${GitStamp.buildDateTime}' '\$newLine'
                'Branch: \${GitStamp.buildBranch}' '\$newLine'
                'SHA: \${GitStamp.sha}',
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

''';
