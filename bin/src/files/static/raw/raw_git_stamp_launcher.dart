const rawGitStampLauncher = '''
import 'package:url_launcher/url_launcher.dart';

void openEmail({
  String? email,
  String? subject,
}) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => Uri.encodeComponent(e.key) + '=' + Uri.encodeComponent(e.value)).join('&');
  }

  launchUrl(
    Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{'subject': subject ?? ''}),
    ),
  );
}

void openProjectHomepage() {
  launchUrl(Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'arononak/git_stamp',
  ));
}

''';
