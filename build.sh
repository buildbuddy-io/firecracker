#!/usr/bin/env bash
set -eu

tools/devtool build --release

: "${BAZEL_REPO_DIR:=/tmp/buildbuddy_firecracker}"

# TODO: remove this suffix
: "${SUFFIX:=-v1.4.0-20230720-cf5f56f}"

REPO_DIR="$PWD"

# Create a bazel repo that can be used with --override_repository
mkdir -p "$BAZEL_REPO_DIR"
touch "$BAZEL_REPO_DIR"/WORKSPACE
echo '
exports_files(["firecracker", "jailer"])
' > "$BAZEL_REPO_DIR"/BUILD
cp build/cargo_target/x86_64-unknown-linux-musl/release/firecracker "$BAZEL_REPO_DIR"/firecracker"$SUFFIX"
cp build/cargo_target/x86_64-unknown-linux-musl/release/jailer "$BAZEL_REPO_DIR"/jailer"$SUFFIX"

echo "=========="
echo "Done!"
echo "Run bazel with:"
echo "    --override_repository=com_github_buildbuddy_io_firecracker_firecracker$SUFFIX=$BAZEL_REPO_DIR"

