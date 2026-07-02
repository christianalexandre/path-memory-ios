#!/usr/bin/env bash
set -euo pipefail

# Runs the SwiftPM suite with coverage and fails if line coverage < threshold.
# Raise COVERAGE_THRESHOLD as real logic lands (placeholders start near zero).
THRESHOLD="${COVERAGE_THRESHOLD:-0}"

cd "$(dirname "$0")/../Modules"

xcrun swift test --enable-code-coverage

bin_path="$(xcrun swift build --show-bin-path)"
profdata="$(find "${bin_path}/codecov" -name '*.profdata' | head -1)"
bundle="$(find "${bin_path}" -maxdepth 1 -name '*.xctest' | head -1)"
binary="${bundle}/Contents/MacOS/$(basename "${bundle}" .xctest)"
[ -f "${binary}" ] || binary="${bundle}"

percent="$(xcrun llvm-cov report "${binary}" \
	-instr-profile "${profdata}" \
	-ignore-filename-regex='\.build|Tests|Package\.swift' \
	2>/dev/null | awk '/^TOTAL/ { gsub(/%/, "", $NF); print $NF }')"
[[ "${percent}" =~ ^[0-9]+([.][0-9]+)?$ ]] || percent=0

printf 'Line coverage: %s%% (threshold %s%%)\n' "${percent}" "${THRESHOLD}"
awk -v p="${percent}" -v t="${THRESHOLD}" 'BEGIN { exit (p + 0 < t + 0) }'
