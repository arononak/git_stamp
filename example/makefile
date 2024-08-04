sync:
	dart run git_stamp --build-type full
	dart format .

run:
	flutter run -d linux

tests: tests_unit

tests_unit:
	dart run git_stamp --gen-only commit-list,diff-list,repo-creation-date,build-branch,build-date-time,build-system-info,repo-path,observed-files-list,app-version,app-build,app-name
	dart test test/type_custom_tests.dart
