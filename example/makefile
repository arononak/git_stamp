sync:
	dart run git_stamp --build-type full
	dart format .

run:
	flutter run -d linux

build: sync
	flutter build web --release --web-renderer canvaskit

tests: tests_unit tests_integration

tests_unit:
	dart run git_stamp --gen-only commit-list,diff-list,repo-creation-date,build-branch,build-date-time,build-system-info,repo-path,observed-files-list,app-version,app-build,app-name,git-config
	dart test test/type_custom_tests.dart

tests_integration:
	flutter create test_project
	cd test_project && sed -i '/^dev_dependencies:/a \  git_stamp:\n    path: ../../' pubspec.yaml
	cd test_project && flutter pub get
	cd test_project && dart run git_stamp
	cd test_project && flutter build web
	cd test_project && dart run git_stamp --build-type lite
	cd test_project && flutter build web
	cd test_project && dart run git_stamp --build-type full
	cd test_project && flutter build web
	cd test_project && dart run git_stamp --build-type icon
	cd test_project && flutter build web
	cd test_project && dart run git_stamp --gen-only build-branch,build-date-time
	cd test_project && flutter build web
	rm -r test_project
