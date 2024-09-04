sync:
	dart run git_stamp --build-type full
	dart format .

run:
	flutter run -d linux

build: sync
	flutter build web --release --web-renderer canvaskit

tests: tests_unit tests_integration

tests_unit:
	dart run git_stamp --gen-only commit-list,diff-list,repo-creation-date,build-branch,build-date-time,build-system-info,repo-path,observed-files-list,app-version,app-build,app-name,git-config,build-machine,git-remote
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

screenshots:
	npx @puppeteer/browsers install chromedriver@stable
	npx chromedriver --port=4444 & echo $$! > chromedriver.pid
	sleep 2
	echo "import 'dart:ui'; const physicalSize = Size(500, 885);" > integration_test/physical_size.dart
	flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_list.dart -d web-server
	flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_icon.dart -d web-server
	flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_files.dart -d web-server
	flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_details.dart -d web-server
	convert screenshot_list.png -crop 500x885+0+0 list.png
	convert screenshot_icon.png -crop 500x885+0+0 icon.png
	convert screenshot_files.png -crop 500x885+0+0 files.png
	convert screenshot_details.png -crop 500x885+0+0 details.png
	rm -f screenshot_icon.png
	rm -f screenshot_list.png
	rm -f screenshot_files.png
	rm -f screenshot_details.png
	mv icon.png ../
	mv list.png ../
	mv files.png ../
	mv details.png ../
	kill $$(cat chromedriver.pid)
	rm -f chromedriver.pid