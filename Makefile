.DEFAULT_GOAL := help
SCHEME := PathMemory
SIMULATOR ?= iPhone 17 Pro
# Override with a UDID where the name lookup fails: SIM_DEST='id=<sim-udid>'
SIM_DEST ?= platform=iOS Simulator,name=$(SIMULATOR)
SNAPSHOT_ONLY := -only-testing:GameFeatureSnapshotTests \
	-only-testing:MenuFeatureSnapshotTests \
	-only-testing:UIComponentsSnapshotTests

.PHONY: bootstrap gen open lint format test coverage build snapshot snapshot-record clean help

bootstrap: ## Install tools, wire git hooks, generate project, resolve deps
	brew bundle
	lefthook install
	xcodegen generate
	cd Modules && xcrun swift package resolve

gen: ## Regenerate the Xcode project
	xcodegen generate

open: gen ## Generate and open the project
	open PathMemory.xcodeproj

lint: ## SwiftLint + SwiftFormat (check only)
	swiftlint lint --strict
	swiftformat --lint .

format: ## Auto-format the code
	swiftformat .

test: ## Run unit tests (SwiftPM)
	cd Modules && xcrun swift test

coverage: ## Run unit tests with the coverage gate
	./scripts/coverage.sh

build: ## Build the app for the simulator
	xcodebuild -project PathMemory.xcodeproj -scheme $(SCHEME) \
		-destination '$(SIM_DEST)' build

snapshot: ## Assert the view-layer image snapshots on the simulator
	cd Modules && xcrun xcodebuild test \
		-scheme PathMemoryKit-Package \
		-destination '$(SIM_DEST)' \
		$(SNAPSHOT_ONLY)

snapshot-record: ## Re-record the view-layer snapshot references
	cd Modules && SNAPSHOT_TESTING_RECORD=all xcrun xcodebuild test \
		-scheme PathMemoryKit-Package \
		-destination '$(SIM_DEST)' \
		$(SNAPSHOT_ONLY)

clean: ## Remove build artifacts and the generated project
	rm -rf Modules/.build DerivedData PathMemory.xcodeproj

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'
