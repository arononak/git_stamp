sync:
	dart run git_stamp --build-type full --gen-url-launcher enabled
	dart format .

run:
	flutter run -d linux

integration_tests:
	dart run git_stamp --gen-only build-branch,build-date-time
	dart test test/branch.dart
