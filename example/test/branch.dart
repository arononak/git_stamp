import 'package:example/git_stamp/git_stamp.dart';
import 'package:test/test.dart';

void main() {
  test('GitStamp buildBranch should be not empty', () {
    expect(GitStamp.buildBranch, isNotEmpty);
  });
}
