sync:
	dart run git_stamp --build-type full --adding-packages disabled

run:
	flutter run -d linux

build: sync
	flutter build web --release --web-renderer canvaskit

build_firebase_web:
	dart run git_stamp --build-type full --adding-packages disabled --encrypt --debug-compile-key
	flutter build web --release --web-renderer canvaskit
	mkdir -p build/encrypted
	cp -r build/web/* build/encrypted/
	mv build/encrypted build/web/ 
	dart run git_stamp --build-type full --adding-packages disabled
	flutter build web --release --web-renderer canvaskit

tests: tests_unit tests_integration

tests_unit:
	dart run git_stamp --gen-only-all
	flutter test test/type_custom_tests.dart

ifdef WINDOWS
    COPY = copy
else
    COPY = cp
endif

tests_integration:
	flutter create test_project
	$(COPY) test_pubspec.yaml test_project/pubspec.yaml
	cd test_project && flutter pub get
	cd test_project && dart run git_stamp && flutter build web
	cd test_project && dart run git_stamp --gen-only build-branch,build-date-time && flutter build web
	cd test_project && dart run git_stamp --build-type icon && flutter build web
	cd test_project && dart run git_stamp --build-type lite && flutter build web
	cd test_project && dart run git_stamp --build-type full && flutter build web
	cd test_project && dart run git_stamp --build-type lite --encrypt && flutter build web
	cd test_project && dart run git_stamp --build-type full --encrypt && flutter build web
	rm -f -r test_project

screenshots:
	npx @puppeteer/browsers install chromedriver@stable
	npx chromedriver --port=4444 & echo $$! > chromedriver.pid
	sleep 2
	echo "import 'dart:ui'; const physicalSize = Size(610, 885);" > integration_test/physical_size.dart
	dart run git_stamp --build-type full
	flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshots_decrypted.dart -d web-server
	dart run git_stamp --build-type full --encrypt
	flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshots_encrypted.dart -d web-server
	convert screenshot_commit_diff.png -crop 610x885+0+0 commit_diff.png
	convert screenshot_git_config.png -crop 610x885+0+0 git_config.png
	convert screenshot_details.png -crop 610x885+0+0 details.png
	convert screenshot_files.png -crop 610x885+0+0 files.png
	convert screenshot_icon.png -crop 610x885+0+0 icon.png
	convert screenshot_list.png -crop 610x885+0+0 list.png
	convert screenshot_tags.png -crop 610x885+0+0 tags.png
	convert screenshot_packages.png -crop 610x885+0+0 packages.png
	convert screenshot_details_encrypted.png -crop 610x885+0+0 details_encrypted.png
	convert screenshot_decrypt.png -crop 610x885+0+0 decrypt.png
	rm -f screenshot_commit_diff.png
	rm -f screenshot_git_config.png
	rm -f screenshot_details.png
	rm -f screenshot_files.png
	rm -f screenshot_icon.png
	rm -f screenshot_list.png
	rm -f screenshot_tags.png
	rm -f screenshot_packages.png
	rm -f screenshot_details_encrypted.png
	rm -f screenshot_decrypt.png
	mv commit_diff.png ../images
	mv git_config.png ../images
	mv details.png ../images
	mv files.png ../images
	mv icon.png ../images
	mv list.png ../images
	mv tags.png ../images
	mv packages.png ../images
	mv details_encrypted.png ../images
	mv decrypt.png ../images
	kill $$(cat chromedriver.pid)
	rm -f chromedriver.pid
	rm -f -r chromedriver

benchmarks:
	dart run git_stamp --benchmark
	rm -f ../BENCHMARK.md
	echo "# Commit count: $$(jq -r '.commitCount' benchmark.json)" > temp_table.md
	echo "| Build type | Generating time | Number of dart files generated | Size of generated dart files |" >> temp_table.md
	echo "|------------|-----------------|-------------------------------|------------------------------|" >> temp_table.md
	echo "| FULL | $$(jq -r '.full.generationTimeSeconds' benchmark.json) | $$(jq -r '.full.filesCount' benchmark.json) | $$(jq -r '.full.filesSize' benchmark.json) |" >> temp_table.md
	echo "| LITE | $$(jq -r '.lite.generationTimeSeconds' benchmark.json) | $$(jq -r '.lite.filesCount' benchmark.json) | $$(jq -r '.lite.filesSize' benchmark.json) |" >> temp_table.md
	echo "| ICON | $$(jq -r '.icon.generationTimeSeconds' benchmark.json) | $$(jq -r '.icon.filesCount' benchmark.json) | $$(jq -r '.icon.filesSize' benchmark.json) |" >> temp_table.md
	cat temp_table.md >> ../BENCHMARK.md
	rm -f temp_table.md benchmark.json
	@echo "BENCHMARK.md updated."
