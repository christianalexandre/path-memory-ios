#!/usr/bin/env bash
set -euo pipefail

# Runs the SwiftPM suite with coverage and fails if line coverage < threshold.
# Gates the pure logic (Domain, Persistence, ViewModels); the SwiftUI view layer
# is excluded below and will be covered by snapshot tests. Raise as those land.
THRESHOLD="${COVERAGE_THRESHOLD:-85}"

cd "$(dirname "$0")/../Modules"

xcrun swift test --enable-code-coverage

bin_path="$(xcrun swift build --show-bin-path)"
profdata="$(find "${bin_path}/codecov" -name '*.profdata' | head -1)"
bundle="$(find "${bin_path}" -maxdepth 1 -name '*.xctest' | head -1)"
binary="${bundle}/Contents/MacOS/$(basename "${bundle}" .xctest)"
[ -f "${binary}" ] || binary="${bundle}"

# Ignore build artifacts, tests, and the SwiftUI view layer (views end in
# `*View.swift`; the UIComponents module is entirely views except GridGeometry,
# which stays tested but out of the gate for a stable logic-only denominator).
# The TOTAL row prints region/function/line/branch coverage; pick the 3rd
# percentage (line coverage) rather than the last column (branch, shown as "-").
percent="$(xcrun llvm-cov report "${binary}" \
	-instr-profile "${profdata}" \
	-ignore-filename-regex='\.build|Tests|Package\.swift|UIComponents/Sources|/Presentation/.*View\.swift' \
	2>/dev/null | awk '/^TOTAL/ {
		count = 0
		for (i = 1; i <= NF; i++) {
			if ($i ~ /%/) {
				count++
				if (count == 3) { gsub(/%/, "", $i); print $i }
			}
		}
	}')"
[[ "${percent}" =~ ^[0-9]+([.][0-9]+)?$ ]] || percent=0

printf 'Line coverage: %s%% (threshold %s%%)\n' "${percent}" "${THRESHOLD}"
awk -v p="${percent}" -v t="${THRESHOLD}" 'BEGIN { exit (p + 0 < t + 0) }'
