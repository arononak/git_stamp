check:
	dart pub publish --dry-run
	
publish:
	dart pub publish

generate_version_file:
	@echo "/*Auto-generated*/const gitStampVersion = '$(shell git tag --sort=-creatordate | head -n 1)';" > bin/src/git_stamp_version.dart