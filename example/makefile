sync:
	dart run git_stamp --build-type full
	dart format .

run:
	flutter run -d linux

tests: tests_unit tests_integration

tests_unit:
	dart run git_stamp --gen-only commit-list,diff-list,repo-creation-date,build-branch,build-date-time,build-system-info,repo-path,observed-files-list,app-version,app-build,app-name
	dart test test/type_custom_tests.dart

tests_integration:
	flutter create test_project
	cd test_project && sed -i '/^dev_dependencies:/a \  git_stamp:\n    path: ../../' pubspec.yaml
	flutter pub get --directory=test_project
	cd test_project && dart run git_stamp 
	cd test_project && flutter build web
	rm -r test_project
